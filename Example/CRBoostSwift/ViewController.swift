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

    }
}
