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
    public init(number:Int,padding:Int) {
        let format = "%0\(padding)d"
        self.init(format:format , number)
    }
    
    @discardableResult
    public func pathByAppendingFlag(flag:String)->String
    {
        let path = self as NSString
        let ext = path.pathExtension
        let pathBody = path.deletingPathExtension
        let newPath = "\(pathBody)\(flag).\(ext)"
        return newPath;
    }
    @discardableResult
    public func join(path:String?)->String
    {
        guard let appendPath = path else { return self  }
        let finalPath = self as NSString
        return finalPath.appending(appendPath)
    }
    @discardableResult
    public func joinExt(ext:String?)->String
    {
        guard let appendExt = ext else { return self  }
        let finalPath = self as NSString
        return finalPath.appendingPathExtension(appendExt) ?? kEmptyString
    }
    @discardableResult
    public func joinPath(path:String?)->String
    {
        guard let appendPath = path else { return self  }
        let finalPath = self as NSString
        return finalPath.appendingPathComponent(appendPath)
    }
    @discardableResult
    public func sizeWithFont(font:UIFont?,maxSize:CGSize)->CGSize
    {
        let text = self as NSString
        if font != nil {
            let   attrs = [NSAttributedString.Key.font:font!]
            let rect =  text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            return rect.size
        }
        return CGSize.zero
    }
    @discardableResult
    public func widthWithFont(font:UIFont?)->CGFloat
    {
        return self .sizeWithFont(font: font, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }
    @discardableResult
    public func heightForFont(font:UIFont?,width :CGFloat)->CGFloat
    {
        return self .sizeWithFont(font: font, maxSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    @discardableResult
    func md5String(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
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
    func removeDecimalLastZeros ()->String{
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
    func randomStringLength (len:Int)->String{
        
        let randomCharacters = (0..<len).map{_ in self.randomElement()!}
        let randomString = String(randomCharacters)
        return randomString
    }
    @discardableResult
    public func isBase64()->Bool{
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
    public func absoluteStringByTrimmingQuery() -> String?
    {
        if var components = (URLComponents(url: self, resolvingAgainstBaseURL: false)) {
            components.query = nil
            return components.string
        }
        return self.absoluteString
    }
    
    @discardableResult
    public func URLByAppendingQueryString(query:String?) -> URL?
    {
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


