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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CRPresentAlert(title: nil, msg: "安全验证", config: { alert in
            alert.addTextField { textField in
                textField.keyboardType = .asciiCapable
                textField.isSecureTextEntry = true
                textField.placeholder = "请输入登陆密码"
            }
        }, handler: { _ in

        }, canel: "取消", action: "确定")
    }
}
