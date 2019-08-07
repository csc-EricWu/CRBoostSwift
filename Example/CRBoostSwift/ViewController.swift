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
        let rect = CGRect(x: 25, y: 20, width: 100, height: 100)
        print("midX\(rect.midX),midY:\(rect.midY)")
        print(CRFrameCenter(rect: rect))
        btnAdd.centerX = view.centerX
        btnAdd.centerY = view.centerY
        print(CRIdfa)

    }
}
