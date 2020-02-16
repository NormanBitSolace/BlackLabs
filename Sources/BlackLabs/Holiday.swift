import Foundation

public enum Holiday {
    case newYears, mlk, washington, easter, memorial, july4, labor, columbus, veterans, thanksgiving, christmas, newYearsEve
}

public struct HolidayCalculator {

    public static var today: Holiday? {
        return HolidayCalculator.getHoliday(forDate: Date())
    }

    public static func getHoliday(forDateString str: String) -> Holiday? {
        let date = Date.parse(str)
        return HolidayCalculator.getHoliday(forDate: date)
    }

    public static func getHoliday(forDate date: Date) -> Holiday? {
        let dc = Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: date)
        guard dc.year != nil && dc.month != nil && dc.day != nil && dc.weekday != nil && dc.weekdayOrdinal != nil  else { return nil }
        let year = dc.year!
        let month = dc.month!
        let day = dc.day!
        let weekday = dc.weekday!
        let weekdayOrdinal = dc.weekdayOrdinal!
        let easterDateComponents = Date.dateComponentsForEaster(year: year)
        let easterMonth: Int = easterDateComponents?.month ?? -1
        let easterDay: Int = easterDateComponents?.day ?? -1
        let memorialDay = Date.dateComponentsForMemorialDay(year: year)?.day ?? -1
        switch (month, day, weekday, weekdayOrdinal) {
            case (1, 1, _, _): return .newYears                   // Happy New Years
            case (1, _, 2, 3): return .mlk                         // MLK - 3rd Mon in Jan
            case (2, _, 2, 3): return .washington                  // Washington - 3rd Mon in Feb
            case (easterMonth, easterDay, _, _): return .easter    // Easter - rocket science calculation
            case (5, memorialDay, _, _): return .memorial          // Memorial Day
            case (7, 4, _, _): return .july4                       // Independence Day
            case (9, 0, 2, 1): return .labor                       // Labor Day - 1st Mon in Sept
            case (10, 0, 2, 2): return .columbus                   // Columbus Day - 2nd Mon in Oct
            case (11, 11, _, _): return .veterans                  // Veterans Day
            case (11, _, 5, 4): return .thanksgiving               // Happy Thanksgiving - 4th Thurs in Nov
            case (12, 25, _, _): return .christmas                 // Happy Holidays
            case (12, 31, _, _): return .newYearsEve               // New years Eve
            default: return nil
        }
    }
}

fileprivate extension Date {

    static func dateComponentsForMemorialDay(year: Int) -> DateComponents? {
        guard let memorialDay = Date.memorialDay(year: year) else { return nil }
        return NSCalendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: memorialDay)
    }

    static func memorialDay(year: Int) -> Date? {
        let calendar = Calendar.current
        var firstMondayJune = DateComponents()
        firstMondayJune.month = 6
        firstMondayJune.weekdayOrdinal = 1  // 1st in month
        firstMondayJune.weekday = 2 // Monday
        firstMondayJune.year = year
        guard let refDate = calendar.date(from: firstMondayJune) else { return nil }
        var timeMachine = DateComponents()
        timeMachine.weekOfMonth = -1
        return calendar.date(byAdding: timeMachine, to: refDate)
    }

    static func easterHoliday(year: Int) -> Date? {
        guard let dateComponents = Date.dateComponentsForEaster(year: year) else { return nil }
        return Calendar.current.date(from: dateComponents)
    }

    static func dateComponentsForEaster(year: Int) -> DateComponents? {
        // Easter calculation from Anonymous Gregorian algorithm
        // AKA Meeus/Jones/Butcher algorithm
        let a = year % 19
        let b = Int(floor(Double(year) / 100))
        let c = year % 100
        let d = Int(floor(Double(b) / 4))
        let e = b % 4
        let f = Int(floor(Double(b+8) / 25))
        let g = Int(floor(Double(b-f+1) / 3))
        let h = (19*a + b - d - g + 15) % 30
        let i = Int(floor(Double(c) / 4))
        let k = c % 4
        let L = (32 + 2*e + 2*i - h - k) % 7
        let m = Int(floor(Double(a + 11*h + 22*L) / 451))
        var dateComponents = DateComponents()
        dateComponents.month = Int(floor(Double(h + L - 7*m + 114) / 31))
        dateComponents.day = ((h + L - 7*m + 114) % 31) + 1
        dateComponents.year = year
        guard let easter = Calendar.current.date(from: dateComponents) else { return nil } // Convert to calculate weekday, weekdayOrdinal
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal], from: easter)
    }
}
