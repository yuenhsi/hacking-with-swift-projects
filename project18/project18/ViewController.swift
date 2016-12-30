//
//  ViewController.swift
//  project18
//
//  Created by Yuen Hsi Chang on 12/28/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 1 ... 100 {
            print("got number \(i)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

