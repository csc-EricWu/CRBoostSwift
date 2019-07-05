//
//  Foundation+CRBoost.swift
//  BSBacktraceLogger
//
//  Created by Eric Wu on 2019/6/21.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
    public init(number: Int, padding: Int) {
        let format = "%0\(padding)d"
        self.init(format: format, number)
    }

    @discardableResult
    public func pathByAppendingFlag(flag: String) -> String {
        let path = self as NSString
        let ext = path.pathExtension
        let pathBody = path.deletingPathExtension
        let newPath = "\(pathBody)\(flag).\(ext)"
        return newPath
    }
    @discardableResult
    public func join(path: String?) -> String {
        guard let appendPath = path else { return self  }
        let finalPath = self as NSString
        return finalPath.appending(appendPath)
    }
    @discardableResult
    public func joinExt(ext: String?) -> String {
        guard let appendExt = ext else { return self  }
        let finalPath = self as NSString
        return finalPath.appendingPathExtension(appendExt) ?? kEmptyString
    }
    @discardableResult
    public func joinPath(path: String?) -> String {
        guard let appendPath = path else { return self  }
        let finalPath = self as NSString
        return finalPath.appendingPathComponent(appendPath)
    }
    @discardableResult
    public func sizeWithFont(font: UIFont?, maxSize: CGSize) -> CGSize {
        let text = self as NSString
        if font != nil {
            let   attrs = [NSAttributedString.Key.font: font!]
            let rect =  text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            return rect.size
        }
        return CGSize.zero
    }
    @discardableResult
    public func widthWithFont(font: UIFont?) -> CGFloat {
        return self .sizeWithFont(font: font, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }
    @discardableResult
    public func heightForFont(font: UIFont?, width: CGFloat) -> CGFloat {
        return self .sizeWithFont(font: font, maxSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    @discardableResult
    public func md5String(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using: .utf8)!
        var digestData = Data(count: length)
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
    @discardableResult
    public func removeDecimalLastZeros () -> String {
        var result = self
        while result.contains(".") && result.hasSuffix("0") {
            let index = result.index(result.endIndex, offsetBy: -1)
            result = String(result[..<index])
        }
        if result.hasSuffix(".") {
            let index = result.index(result.endIndex, offsetBy: -1)
            result = String(result[..<index])
        }
        return result
    }
    @discardableResult
    public func randomStringLength (len: Int) -> String {

        let randomCharacters = (0..<len).map {_ in self.randomElement()!}
        let randomString = String(randomCharacters)
        return randomString
    }
    @discardableResult
    public func isBase64() -> Bool {
        if Data(base64Encoded: self, options: []) != nil {
            return true
        } else {
            return false
        }
    }

    @discardableResult
    public func joinUrl(url: String) -> String {
        var finaUrl = self
        var appendUrl = url
        if hasSuffix(kSeparatorSlash) {
            let index = finaUrl.index(finaUrl.endIndex, offsetBy: -1)
            finaUrl = String(finaUrl[..<index])
        }
        if url.hasPrefix(kSeparatorSlash) {
            let index = url.index(url.startIndex, offsetBy: 1)
            appendUrl = String(url[index...])
        }
        return "\(finaUrl)\(kSeparatorSlash)\(appendUrl)"
    }

    @discardableResult
    public func appendingQuery(query: String?) -> String {
        if CRIsNullOrEmpty(text: query) {
            return self
        }
        let distinctSuffix: (_ url: String) -> String = {
            url in
            var cleanUrl = url
            if cleanUrl.hasSuffix(kSymbolQuestion) {
                let index = cleanUrl.index(cleanUrl.endIndex, offsetBy: -1)
                cleanUrl = String(cleanUrl[..<index])
            }
            if cleanUrl.hasSuffix(kSeparatorBitAnd) {
                let index = url.index(cleanUrl.endIndex, offsetBy: -1)
                cleanUrl = String(cleanUrl[..<index])
            }
            return cleanUrl
        }

        let distinctPrefix: (_ url: String) -> String = {
            url in
            var cleanUrl = url
            if cleanUrl.hasPrefix(kSymbolQuestion) {
                let index = url.index(url.startIndex, offsetBy: 1)
                cleanUrl = String(url[index...])
            }
            if cleanUrl.hasPrefix(kSeparatorBitAnd) {
                let index = url.index(url.startIndex, offsetBy: 1)
                cleanUrl = String(url[index...])
            }
            return cleanUrl
        }
        let url = distinctSuffix(self)
        let cleanQuery = distinctPrefix(query!)
        let token = contains(kSymbolQuestion) ? kSeparatorBitAnd : kSymbolQuestion
        return "\(url)\(token)\(cleanQuery)"
    }

    @discardableResult
    public func appendingQuery(dict: [String: String]) -> String {
        if let query = CRQueryFromJSON(json: dict) {
            return appendingQuery(query: query)
        } else {
            return self
        }
    }

    @discardableResult
    public func phoneNumberFormat() -> String {
        if count == 11 {
            var formatPhone = self
            for (idx, _) in enumerated() {
                if idx == 2 || idx == 7 {
                    let index = formatPhone.index(formatPhone.startIndex, offsetBy: idx + 1)
                    formatPhone.insert(" ", at: index)
                }
            }
            return formatPhone
        }
        return self
    }
}
extension URL {
    @discardableResult
    public func trimmingQuery() -> String? {
        if var components = (URLComponents(url: self, resolvingAgainstBaseURL: false)) {
            components.query = nil
            return components.string
        }
        return self.absoluteString
    }

    @discardableResult
    public func appendingQueryString(query: String?) -> URL? {
        if let queryString = query {
            let separator = CRIsNullOrEmpty(text: self.query) ? "?" : "&"
            let URLString = "\(self.absoluteString)\(separator)\(queryString)"
            if let fullURL = URL(string: URLString) {
                return fullURL
            }
        }
        return self

    }

}

/**
 * date formatter
 *
 * date format
 * 0: no separator
 * 1: use '/' as separator
 * 2: use '-' as separator
 *
 * time format
 * 0: use ':' as separator
 */
public let kDateTemplate0yyyyMMdd = "yyyyMMdd"
public let kDateTemplate0hmma = "h:mm a"

public let kDateTemplate1MMddyyyy = "MM/dd/yyyy"
public let kDateTemplate1MMddyy = "MM/dd/yy"
public let kDateTemplate1ddMMyyyy0HHmmss = "dd/MM/yyyy HH:mm:ss"
public let kDateTemplate1ddMMyyyy0HHmm = "dd/MM/yyyy HH:mm"

public let kDateTemplate2MMddyyyy = "MM-dd-yyyy"
public let kDateTemplate2yyyyMMdd0HHmmss = "yyyy-MM-dd HH:mm:ss"
public let kDateTemplate2yyyyMMdd0HHmmssZZZ = "yyyy-MM-dd HH:mm:ss ZZZ"

extension Date {

    /// Year component
    public var year: Int {
        get {
            return   Calendar.current.component(Calendar.Component.year, from: self)
        }
    }

    /// Month component (1~12)
    public var month: Int {
        get {
            return   Calendar.current.component(Calendar.Component.month, from: self)
        }
    }

    /// Day component (1~31)
    public var day: Int {
        get {
            return   Calendar.current.component(Calendar.Component.day, from: self)
        }
    }

    /// Hour component (0~23)
    public var hour: Int {
        get {
            return   Calendar.current.component(Calendar.Component.hour, from: self)
        }
    }

    /// Minute component (0~59)
    public var minute: Int {
        get {
            return   Calendar.current.component(Calendar.Component.minute, from: self)
        }
    }

    /// Second component (0~59)
    public var second: Int {
        get {
            return   Calendar.current.component(Calendar.Component.second, from: self)
        }
    }

    /// Nanosecond component
    public var nanosecond: Int {
        get {
            return   Calendar.current.component(Calendar.Component.nanosecond, from: self)
        }
    }

    /// Weekday component (1~7, first day is based on user setting)
    public var weekday: Int {
        get {
            return   Calendar.current.component(Calendar.Component.weekday, from: self)
        }
    }

    /// WeekdayOrdinal component
    public var weekdayOrdinal: Int {
        get {
            return   Calendar.current.component(Calendar.Component.weekdayOrdinal, from: self)
        }
    }

    /// WeekOfMonth component (1~5)
    public var weekOfMonth: Int {
        get {
            return   Calendar.current.component(Calendar.Component.weekOfMonth, from: self)
        }
    }

    /// WeekOfYear component (1~53)
    public var weekOfYear: Int {
        get {
            return   Calendar.current.component(Calendar.Component.weekOfYear, from: self)
        }
    }

    /// YearForWeekOfYear component
    public var yearForWeekOfYear: Int {
        get {
            return   Calendar.current.component(Calendar.Component.yearForWeekOfYear, from: self)
        }
    }

    /// Quarter component
    public var quarter: Int {
        get {
            return   Calendar.current.component(Calendar.Component.quarter, from: self)
        }
    }

    /// whether the month is leap month
    public var isLeapMonth: Bool {
        get {
            return  Calendar.current.dateComponents([Calendar.Component.quarter], from: self).isLeapMonth ?? false
        }
    }

    /// whether the year is leap year
    public var isLeapYear: Bool {
        get {
            let year = self.year
            return  ((year % 400 == 0) ||  ((year % 100 != 0) &&  (year % 4 == 0)))
        }
    }

    /// whether date is today (based on current locale)
    public var isToday: Bool {
        get {
            if abs(self.timeIntervalSinceNow) >= 60 * 60 * 24 {
                return false
            }
            return Date().day == self.day

        }
    }

    /// whether date is yesterday (based on current locale)
    public var isYesterday: Bool {
        get {
            let added = self.byAddingDays(1)
            return added?.isToday ?? false
        }
    }
    @discardableResult

    public func byAddingYears(_ years: Int) -> Date? {
        var components = DateComponents()
        components.year = years
        return Calendar.current.date(byAdding: components, to: self)
    }
    @discardableResult

    public func byAddingMonths(_ months: Int) -> Date? {
        var components = DateComponents()
        components.month = months
        return Calendar.current.date(byAdding: components, to: self)
    }

    @discardableResult
    public func byAddingWeeks(_ weeks: Int) -> Date? {
        var components = DateComponents()
        components.weekOfYear = weeks
        return Calendar.current.date(byAdding: components, to: self)
    }

    @discardableResult
    public func byAddingDays(_ days: Int) -> Date? {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(86400 * days)

        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate

    }
    @discardableResult
    public func byAddingHours(_ hours: Int) -> Date? {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(3600 * hours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate

    }

    @discardableResult
    public func byAddingMinutes(_ minutes: Int) -> Date? {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(60 * minutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate

    }
    @discardableResult
    public func byAddingSeconds(_ seconds: Int) -> Date? {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(seconds)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate

    }
    @discardableResult
    public  static func timeIntervalSince1970Number(number: TimeInterval) -> Date {
        var timeInterval = number
        if timeInterval > 140000000000 {
            timeInterval = timeInterval / 1000
        }
        return Date(timeIntervalSince1970: timeInterval)
    }

    @discardableResult
    public static func dateWithString(string: String?, template: String?) -> Date? {
        if CRIsNullOrEmpty(text: string) || CRIsNullOrEmpty(text: template) {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = template
        return dateFormatter.date(from: string!)
    }

    @discardableResult
    public  func stringWithTemplate(template: String?) -> String? {
        if  CRIsNullOrEmpty(text: template) {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = template
        return dateFormatter.string(from: self)
    }
    @discardableResult
    public func timeIntervalSince1970String() -> String {
        let timeInterval = self.timeIntervalSince1970
        return "\(timeInterval)"
    }

    /// in seconds
    ///
    /// - Returns: in seconds
    public func timeIntervalSince1970Number() -> Int64 {
        let timeInterval = self.timeIntervalSince1970
        return Int64(timeInterval)
    }

    /// in milliseconds
    ///
    /// - Returns: in milliseconds
    public func timeIntervalSince1970Number13() -> Int64 {
        let timeInterval = self.timeIntervalSince1970 * 1000
        return Int64(timeInterval)
    }
    @discardableResult
    public func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.current
        let comp1 = calendar.dateComponents(Set(CRCOMPS_DATE), from: self)
        let comp2 = calendar.dateComponents(Set(CRCOMPS_DATE), from: date)
        return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day
    }

}
extension NSAttributedString {
    @discardableResult
    public func sizeThatFits(size: CGSize) -> CGSize {
        let rect = self .boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return rect.size

    }
    @discardableResult
    public func widthToFit() -> CGFloat {
        let size = self.sizeThatFits(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return size.width
    }
    @discardableResult
    public func heightForWidth(width: CGFloat) -> CGFloat {
        let size = self.sizeThatFits(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
}

//extension UIImage {
//    @discardableResult
//    public func
//}