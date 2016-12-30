//
//  ViewController.swift
//  project6b
//
//  Created by Yuen Hsi Chang on 12/20/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "One"
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.green
        label2.text = "Two"
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.blue
        label3.text = "Three"
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.purple
        label4.text = "Four"
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "Five"
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        var previous: UILabel!
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        let metrics = ["labelHeight": 80]
        for viewKey in viewsDictionary.keys {
            viewsDictionary[viewKey]!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            viewsDictionary[viewKey]!.heightAnchor.constraint(equalToConstant: 88).isActive = true
            if previous != nil {
                viewsDictionary[viewKey]!.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            }
            previous = viewsDictionary[viewKey]!
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(viewKey)]|", options: [], metrics: nil, views: viewsDictionary))
        }
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

