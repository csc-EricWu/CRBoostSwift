//
//  Foundation+CRBoost.swift
//  BSBacktraceLogger
//
//  Created by Eric Wu on 2019/6/21.
//

import typealias CommonCrypto.CC_LONG
import func CommonCrypto.CC_MD5
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import Foundation

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
        guard let appendPath = path else { return self }
        let finalPath = self as NSString
        return finalPath.appending(appendPath)
    }

    @discardableResult
    public func joinExt(ext: String?) -> String {
        guard let appendExt = ext else { return self }
        let finalPath = self as NSString
        return finalPath.appendingPathExtension(appendExt) ?? kEmptyString
    }

    @discardableResult
    public func joinPath(path: String?) -> String {
        guard let appendPath = path else { return self }
        let finalPath = self as NSString
        return finalPath.appendingPathComponent(appendPath)
    }

    @discardableResult
    public func sizeWithFont(font: UIFont?, maxSize: CGSize) -> CGSize {
        let text = self as NSString
        if font != nil {
            let attrs = [NSAttributedString.Key.font: font!]
            let rect = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            return rect.size
        }
        return CGSize.zero
    }

    @discardableResult
    public func widthWithFont(font: UIFont?) -> CGFloat {
        return sizeWithFont(font: font, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }

    @discardableResult
    public func heightForFont(font: UIFont?, width: CGFloat) -> CGFloat {
        return sizeWithFont(font: font, maxSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

    @discardableResult
    public func md5String() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = data(using: .utf8)!
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
        let md5Hex = digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }

    @discardableResult
    public func base64String() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    @discardableResult
    public func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
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
    public func removeDecimalLastZeros() -> String {
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
    public func safeRemoveFirst(_ k: Int = 1) -> String {
        if count < k {
            return self
        }
        var result = self
        result.removeFirst(k)
        return result
    }

    @discardableResult
    public func safeRemoveLast(_ k: Int = 1) -> String {
        if count < k {
            return self
        }
        var result = self
        result.removeLast(k)
        return result
    }

    @discardableResult
    public func retainDecimal(_ digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = digits
        formatter.usesGroupingSeparator = false
        var decimal = NSDecimalNumber(string: isEmpty ? "0" : self)
        if decimal.decimalValue == .nan {
            decimal = NSDecimalNumber(string: "0")
        }
        if let value = formatter.string(for: decimal) {
            return value
        }
        return "0"
    }

    @discardableResult
    public func randomStringLength(len: Int) -> String {
        let randomCharacters = (0 ..< len).map { _ in self.randomElement()! }
        let randomString = String(randomCharacters)
        return randomString
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

    // MARK: - Int, Double, Float, Int8, Int16, Int32, Int64

    public var boolValue: Bool? {
        let trueValues = ["true", "yes", "1"]
        let falseValues = ["false", "no", "0"]
        let lowerSelf = lowercased()
        if trueValues.contains(lowerSelf) {
            return true
        } else if falseValues.contains(lowerSelf) {
            return false
        } else {
            return nil
        }
    }

    public var doubleValue: Double {
        let decimal = NSDecimalNumber(string: self)
        return decimal == .notANumber ? .zero : decimal.doubleValue
    }

    public var floatValue: Float {
        return Float(doubleValue)
    }

    public var intValue: Int {
        return Int(doubleValue)
    }

    public var uIntValue: UInt? {
        return UInt(doubleValue)
    }

    public var int8Value: Int8 {
        return Int8(doubleValue)
    }

    public var uInt8Value: UInt8 {
        return UInt8(doubleValue)
    }

    public var int16Value: Int16 {
        return Int16(doubleValue)
    }

    public var uInt16Value: UInt16 {
        return UInt16(doubleValue)
    }

    public var int32Value: Int32 {
        return Int32(doubleValue)
    }

    public var uInt32Value: UInt32 {
        return UInt32(doubleValue)
    }

    public var int64Value: Int64 {
        return Int64(doubleValue)
    }

    public var uInt64Value: UInt64 {
        return UInt64(doubleValue)
    }
}

extension Collection where Element: Equatable {
    public func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension StringProtocol {
    public func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}

//    https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    public subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    public subscript(i: Int) -> String {
        return String(self[i] as Character)
    }

    public subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }

    public subscript(bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }

    public subscript(bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }

    public subscript(bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }

    public subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }

    public subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

extension Substring {
    public subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    public subscript(bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }

    public subscript(bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }

    public subscript(bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }

    public subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }

    public subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

extension URL {
    @discardableResult
    public func trimmingQuery() -> String? {
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            components.query = nil
            return components.string
        }
        return absoluteString
    }

    @discardableResult
    public func appendingQueryString(query: String?) -> URL? {
        if let queryString = query {
            let separator = CRIsNullOrEmpty(text: self.query) ? "?" : "&"
            let URLString = "\(absoluteString)\(separator)\(queryString)"
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
        return Calendar.current.component(Calendar.Component.year, from: self)
    }

    /// Month component (1~12)
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }

    /// Day component (1~31)
    public var day: Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }

    /// Hour component (0~23)
    public var hour: Int {
        return Calendar.current.component(Calendar.Component.hour, from: self)
    }

    /// Minute component (0~59)
    public var minute: Int {
        return Calendar.current.component(Calendar.Component.minute, from: self)
    }

    /// Second component (0~59)
    public var second: Int {
        return Calendar.current.component(Calendar.Component.second, from: self)
    }

    /// Nanosecond component
    public var nanosecond: Int {
        return Calendar.current.component(Calendar.Component.nanosecond, from: self)
    }

    /// Weekday component (1~7, first day is based on user setting)
    public var weekday: Int {
        return Calendar.current.component(Calendar.Component.weekday, from: self)
    }

    /// WeekdayOrdinal component
    public var weekdayOrdinal: Int {
        return Calendar.current.component(Calendar.Component.weekdayOrdinal, from: self)
    }

    /// WeekOfMonth component (1~5)
    public var weekOfMonth: Int {
        return Calendar.current.component(Calendar.Component.weekOfMonth, from: self)
    }

    /// WeekOfYear component (1~53)
    public var weekOfYear: Int {
        return Calendar.current.component(Calendar.Component.weekOfYear, from: self)
    }

    /// YearForWeekOfYear component
    public var yearForWeekOfYear: Int {
        return Calendar.current.component(Calendar.Component.yearForWeekOfYear, from: self)
    }

    /// Quarter component
    public var quarter: Int {
        return Calendar.current.component(Calendar.Component.quarter, from: self)
    }

    /// whether the month is leap month
    public var isLeapMonth: Bool {
        return Calendar.current.dateComponents([Calendar.Component.quarter], from: self).isLeapMonth ?? false
    }

    /// whether the year is leap year
    public var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }

    /// whether date is today (based on current locale)
    public var isToday: Bool {
        if abs(timeIntervalSinceNow) >= 60 * 60 * 24 {
            return false
        }
        return Date().day == day
    }

    /// whether date is yesterday (based on current locale)
    public var isYesterday: Bool {
        let added = byAddingDays(1)
        return added?.isToday ?? false
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
        let aTimeInterval = timeIntervalSinceReferenceDate + TimeInterval(86400 * days)

        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    @discardableResult
    public func byAddingHours(_ hours: Int) -> Date? {
        let aTimeInterval = timeIntervalSinceReferenceDate + TimeInterval(3600 * hours)
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    @discardableResult
    public func byAddingMinutes(_ minutes: Int) -> Date? {
        let aTimeInterval = timeIntervalSinceReferenceDate + TimeInterval(60 * minutes)
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    @discardableResult
    public func byAddingSeconds(_ seconds: Int) -> Date? {
        let aTimeInterval = timeIntervalSinceReferenceDate + TimeInterval(seconds)
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }

    @discardableResult
    public static func timeIntervalSince1970Number(number: TimeInterval) -> Date {
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
    public func stringWithTemplate(template: String?) -> String? {
        if CRIsNullOrEmpty(text: template) {
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
        let timeInterval = timeIntervalSince1970
        return "\(timeInterval)"
    }

    /// in seconds
    ///
    /// - Returns: in seconds
    public func timeIntervalSince1970Number() -> Int64 {
        let timeInterval = timeIntervalSince1970
        return Int64(timeInterval)
    }

    /// in milliseconds
    ///
    /// - Returns: in milliseconds
    public func timeIntervalSince1970Number13() -> Int64 {
        let timeInterval = timeIntervalSince1970 * 1000
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
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return rect.size
    }

    @discardableResult
    public func widthToFit() -> CGFloat {
        let size = sizeThatFits(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return size.width
    }

    @discardableResult
    public func heightForWidth(width: CGFloat) -> CGFloat {
        let size = sizeThatFits(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
}

extension UIImage {
    @discardableResult
    public func scaleToSize(size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @discardableResult
    public func imageByApplyingAlpha(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @discardableResult
    public func resizeWithImageMode(_ resizingMode: UIImage.ResizingMode = .stretch) -> UIImage {
        let top = size.height / 2.0
        let left = size.width / 2.0
        let bottom = size.height / 2.0
        let right = size.width / 2.0
        return resizableImage(withCapInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right), resizingMode: resizingMode)
    }

    @discardableResult

    public class func imageFromeView(_ view: UIView) -> UIImage? {
        return imageFromeView(view, size: view.bounds.size)
    }

    @discardableResult

    public class func imageFromeView(_ view: UIView, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, view.isOpaque, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @discardableResult

    public class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @discardableResult
    public class func imageSizeWithURL(_ url: String?) -> CGSize {
        guard let urlStr = url else {
            return CGSize.zero
        }
        // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch23p829imageIO/ch36p1084imageIO/ViewController.swift
        var width: CGFloat = 0
        var height: CGFloat = 0
        if let trimUrl = URL(string: urlStr) {
            let imageSourceRef = CGImageSourceCreateWithURL(trimUrl as CFURL, nil)
            if let imageSRef = imageSourceRef {
                let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
                if let imageP = imageProperties {
                    let imageDict = imageP as Dictionary
                    width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                    height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
                }
            }
        }
        return CGSize(width: width, height: height)
    }

    @discardableResult
    public class func qrImageWithString(_ codeStr: String?) -> UIImage? {
        if CRIsNullOrEmpty(text: codeStr) {
            return nil
        }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        // 滤镜恢复默认设置
        filter.setDefaults()
        // 2. 给滤镜添加数据
        let data = codeStr!.data(using: String.Encoding.utf8)
        filter.setValue(data, forKey: "inputMessage")
        // 3. 生成高清二维码 CIImage
        if let image = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let output = image.transformed(by: transform)
            // 解决图片无法保存
            let context = CIContext(options: nil)
            if let bitmapImage = context.createCGImage(output, from: output.extent) {
                // 4. 显示二维码
                let newImage = UIImage(cgImage: bitmapImage, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
                return newImage
            }
        }
        return nil
    }
}

extension UIColor {
    public class func randomColor() -> UIColor {
        let red = arc4random_uniform(256)
        let green = arc4random_uniform(256)
        let blue = arc4random_uniform(256)
        return CRRGBA(r: Float(red), g: Float(green), b: Float(blue))
    }

    // MARK: - color from {R, G, B}

    public class func colorWithString(string: String) -> UIColor {
        return UIColor()
    }
}
