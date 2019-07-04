//
//  ViewController.swift
//  CRBoostSwift
//
//  Created by csc-EricWu on 06/19/2019.
//  Copyright (c) 2019 csc-EricWu. All rights reserved.
//

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
           print("Hello word!/".joinUrl(url: "/333"))
           print("Hello word!".joinUrl(url: "333"))
        print("Hello word!".joinUrl(url: "/333"))
        print("Hello word!/".joinUrl(url: "333"))
        print(String(number:10,padding:10))
        print("c2RzZHNkce2Q8".isBase64())
        print(CRIsNullOrEmpty(text: nil))
    }
}
