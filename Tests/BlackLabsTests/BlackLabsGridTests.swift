import XCTest
@testable import BlackLabs

class SubGrid: Grid<Int> {
    let name: String = "bob"
}

final class BlackLabsGridTests: XCTestCase {

    /*

     Use if when `Grid` conforms to `Codable`.
     
    func testCodable() {
        let grid = Grid.init(numRows: 2, numCols: 3, initalValue: 7)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(grid) else { fatalError() }
        let o: Grid<Int>? = data.decode()
        guard let grid2 = o else { fatalError() }
        XCTAssertEqual(grid2.numRows, 2)
        XCTAssertEqual(grid2.numCols, 3)
        XCTAssertEqual(grid2.count, 6)
    }

    func testSubclassCodable() {
        let grid = SubGrid.init(numRows: 2, numCols: 3, initalValue: 7)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(grid) else { fatalError() }
        let o: SubGrid? = data.decode()
        guard let grid2 = o else { fatalError() }
        XCTAssertEqual(grid2.numRows, 2)
        XCTAssertEqual(grid2.numCols, 3)
        XCTAssertEqual(grid2.count, 6)
        XCTAssertEqual(grid2.name, "bob")
    }
*/

}
