//
//  ViewController.swift
//  CRBoostSwift
//
//  Created by csc-EricWu on 06/19/2019.
//  Copyright (c) 2019 csc-EricWu. All rights reserved.
//

// MARK: - subscript

import CRBoostSwift
import UIKit

class ViewController: UIViewController {
    let btnAdd = UIButton(type: .contactAdd)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnAdd)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("a".retainDecimal(5))
//        print("1".retainDecimal(5))
//        print(".11".retainDecimal(5))
//        print(".".retainDecimal(5))

        print("".retainDecimal(5))

        let test = "Hello USA 🇺🇸!!! Hello Brazil 🇧🇷!!!"
        print(test[safe: 10] as Any) // "🇺🇸"
        print(test[11]) // "!"
        print(test[10...]) // "🇺🇸!!! Hello Brazil 🇧🇷!!!"
        print(test[10 ..< 12]) // "🇺🇸!"
        print(test[10 ... 12]) // "🇺🇸!!"
        print(test[...10]) // "Hello USA 🇺🇸"
        print(test[..<10]) // "Hello USA "
        print(test.first as Any) // "H"
        print(test.last as Any) // "!"

        // Subscripting the Substring
        print(test[...][...3]) // "Hell"

        // Note that they all return a Substring of the original String.
        // To create a new String from a substring
        print(test[10...].string) // "🇺🇸!!! Hello Brazil 🇧🇷!!!"

        let urlRegEx = "^(http://|https://)[A-Za-z0-9.-]+(?!.*\\|\\w*$)"
        let string = "https://pixabay.com/en/art-beauty-fairytales-fantasy-2436545/"
        let matched = matches(for: urlRegEx, in: string)
        print(matched)

        func matches(for regex: String, in text: String) -> [String] {
            do {
                let regex = try NSRegularExpression(pattern: regex)
//                regex.replaceMatchesInString(str, options: NSMatchingOptions.ReportProgress, range: NSRange(0,str.characters.count), withTemplate: "")

//                regex.replaceMatches(in: string, range: <#T##NSRange#>, withTemplate: "")

                let nsString = text as NSString
                let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
                return results.map { nsString.substring(with: $0.range) }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
    }
}
