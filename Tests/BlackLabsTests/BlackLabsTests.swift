import XCTest
@testable import BlackLabs

final class BlackLabsTests: XCTestCase {
    func testBundle() {
         let testBundle = Bundle(for: type(of: self))
         XCTAssertEqual(testBundle.appName, "BlackLabsTests")
    }
    func testArray2D() {
        var tda = Array2D(numRows: 5, numCols: 10, defaultValue: 0)
        var value = 0
        for row in 0..<tda.rows {
            for col in 0..<tda.cols {
                tda[row, col] = value
                value += 1
            }
        }
        XCTAssertEqual(tda[0, 0], 0)
        XCTAssertEqual(tda[4, 9], 49)
        value = 0
        for row in 0..<tda.rows {
            for col in 0..<tda.cols {
                XCTAssertEqual(tda[row, col], value)
                value += 1
            }
        }
    }

    func testStack() {
        var stack = Stack<CGFloat>()
        for i in 0..<3 {
            stack.push(CGFloat(i))
        }
        // LIFO
        for i in (0..<3).reversed() {
            let o = stack.pop()!
            XCTAssertEqual(o, CGFloat(i))
        }
    }

    func testQueue() {
        var queue = Queue<CGFloat>()
        for i in 0..<3 {
            queue.enqueue(CGFloat(i))
        }
        // FIFO
        for i in (0..<3) {
            let o = queue.dequeue()!
            XCTAssertEqual(o, CGFloat(i))
        }
    }
    func testColor() {
        XCTAssertNotNil(UIColor.appBlack)
    }

    func testToday() {
        XCTAssertEqual(HolidayCalculator.getHoliday(forDate: Date()), HolidayCalculator.today)
    }

    func testHolidays() {
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2019-01-21"), .mlk)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2020-01-20"), .mlk)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2021-01-18"), .mlk)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2022-01-17"), .mlk)

        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2019-02-18"), .washington)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2020-02-17"), .washington)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2021-02-15"), .washington)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2022-02-21"), .washington)

        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2019-04-21"), .easter)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2020-04-12"), .easter)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2021-04-04"), .easter)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2022-04-17"), .easter)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2024-03-31"), .easter)

        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2019-05-27"), .memorial)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2020-05-25"), .memorial)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2021-05-31"), .memorial)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2022-05-30"), .memorial)

        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2019-11-28"), .thanksgiving)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2020-11-26"), .thanksgiving)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2021-11-25"), .thanksgiving)
        XCTAssertEqual(HolidayCalculator.getHoliday(forDateString: "2022-11-24"), .thanksgiving)

    }
    func testDevice() {
        XCTAssertNotNil(UIDevice.modelName)
    }
    func testNumberFormatting() {
        XCTAssertEqual(1.format("03"), "001")
        let cgf: CGFloat = 8
        XCTAssertEqual(cgf.format("3"), "8.000")
        XCTAssertEqual(Double.pi.format("3"), "3.142")
        XCTAssertEqual(96.timerValue, "1:36")
    }
    struct TestObj: Codable {
        let a = "hi"
    }
    func testUserDefaults() {
        let obj = TestObj()
        let key = "___BlackLabsUserDefaultsTests__"
        UserDefaults.set(obj, forKey: key)
        let read: TestObj? = UserDefaults.get(forKey: key)
        XCTAssertEqual(obj.a, read?.a)
    }

    func testStrings() {
        let s = """
            a

            b
            c

        """
        let a = s.toLines
        XCTAssertEqual(a.count, 5)
        let fa = a.removeEmptyLines
        XCTAssertEqual(fa[0], "a")
        XCTAssertEqual(fa[1], "b")
        XCTAssertEqual(fa[2], "c")
        XCTAssertEqual(fa.count, 3)
    }

    func testStringToDictionary() {
        let s = """
            key1\tvalue1

            key2\tvalue2
            key3\tvalue3

        """
        let d = s.toDictionary
        XCTAssertEqual(d.count, 3)
        XCTAssertEqual(d["key1"], "value1")
        XCTAssertEqual(d["key2"], "value2")
        XCTAssertEqual(d["key3"], "value3")
    }

    static var allTests = [
        ("testBundle", testBundle),
        ("testArray2D", testArray2D),
        ("testStack", testStack),
        ("testQueue", testQueue),
        ("testColor", testColor),
        ("testToday", testToday),
        ("testHolidays", testHolidays),
        ("testDevice", testDevice),
        ("testNumberFormatting", testNumberFormatting),
        ("testUserDefaults", testUserDefaults),
        ("testStrings", testStrings),
        ("testStringToDictionary", testStringToDictionary),
        ] + BlackLabsDataTests.allTests
}
