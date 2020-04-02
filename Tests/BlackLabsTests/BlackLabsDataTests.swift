import XCTest
@testable import BlackLabs

struct Pet: Codable {
    let id: Int?
    let name: String
}

//  cd to PROJECT/Tests dir with db.json
//  run: json-server --watch db.json
class PetService: DataService<Pet> {
    init() {
        let base = "http://localhost:3000"
//        let base = "https://my-json-server.typicode.com/nbasham/pet_database"
        let path = "pets"
        super.init(base: base, path: path)
        URLSession.shared.log()
    }
}

final class BlackLabsDataTests: XCTestCase {

    func testGet() {
        let expectation = XCTestExpectation(description: "Get pet.")
        let service = PetService()
        service.get(id: 0) { pet in
            if let pet = pet {
                XCTAssertNotNil(pet)
                XCTAssertEqual(pet.id, 0)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetAll() {
        let expectation = XCTestExpectation(description: "Get all pets.")
        let service = PetService()
        service.get { pets in
            XCTAssertNotNil(pets?[0])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetParallel() {
        let expectation = XCTestExpectation(description: "Get pets in parallel.")
        let service = PetService()
        service.get(ids: [0, 0, 0]) { pets in
            XCTAssertNotNil(pets)
            XCTAssertEqual(pets?.count, 3)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetParallelWithFails() {
        let expectation = XCTestExpectation(description: "Get pets in parallel with fails.")
        let service = PetService()
        service.get(ids: [0, -1, -1]) { pets in
            XCTAssertNotNil(pets)
            XCTAssertEqual(pets?.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testPost() {
        let expectation = XCTestExpectation(description: "Create pet.")
        let service = PetService()
        let model = Pet(id: nil, name: "Dawn")
        service.create(model: model) { pet in
            if let pet = pet {
                print(pet)
                XCTAssertNotNil(pet.id)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testPut() {
        let expectation = XCTestExpectation(description: "Update pet.")
        let service = PetService()
        let model = Pet(id: nil, name: "Elon")
        service.add(model: model) { pet in
            if let id = pet?.id {
                let updatedPet = Pet(id: id, name: "Musky")
                service.update(id: id, model: updatedPet) { _ in
                    // REST convention doesn't specify that PUT should return updated object,
                    // though it is common practice. So do a GET here just in case it doesn't.
                    print(updatedPet)
                    service.get(id: id) { pet in
                        XCTAssertEqual(pet?.name, "Musky")
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testDelete() {
        let expectation = XCTestExpectation(description: "Delete pet.")
        let service = PetService()
        service.create(model: Pet(id: nil, name: "Sparky")) { pet in
            if let id = pet?.id {
                service.delete(id: id) {
                    service.get(id: id) { pet in
                        XCTAssertNil(pet)
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetModel() {
        let expectation = XCTestExpectation(description: "Get image.")
        let url = URL("http://localhost:3000/pets/0")
        url.getModel(type: Pet.self) { pet in
            XCTAssertNotNil(pet)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetImage() {
        let expectation = XCTestExpectation(description: "Get image.")
        let url = URL("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
        url.getImage { image in
            XCTAssertNotNil(image)
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetImageFail() {
        let expectation = XCTestExpectation(description: "Get image.")
        let url = URL("https://www.google.com/images/branding/googlelogo/2x/badImageName.png")
        url.getImage { image in
            XCTAssertNil(image)
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    static var allTests = [
        ("testGet", testGet),
        ("testGetAll", testGetAll),
        ("testGetParallel", testGetParallel),
        ("testGetParallelWithFails", testGetParallelWithFails),
        ("testPost", testPost),
        ("testPut", testPut),
        ("testDelete", testDelete),
        ("testGetModel", testGetModel),
        ("testGetImage", testGetImage),
        ("testGetImageFail", testGetImageFail),
    ]
}
