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
}
