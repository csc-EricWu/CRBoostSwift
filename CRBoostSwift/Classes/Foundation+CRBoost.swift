//
//  Foundation+CRBoost.swift
//  BSBacktraceLogger
//
//  Created by Eric Wu on 2019/6/21.
//

import Foundation

extension String {
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
