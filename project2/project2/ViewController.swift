//
//  ViewController.swift
//  project2
//
//  Created by Yuen Hsi Chang on 12/17/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//
import GameplayKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var flags = [String]()
    var correctAnswer = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flags += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (sender.tag == correctAnswer) {
            title = "Correct!"
            score += 1
        } else {
            title = "Incorrect!"
        }
        let alert = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(alert, animated: true)
    }
    
    func askQuestion(_ : UIAlertAction! = nil) {
        flags = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: flags) as! [String]
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        title = flags[correctAnswer].uppercased()
        
        button1.setImage(UIImage(named:flags[0]), for: .normal)
        button2.setImage(UIImage(named:flags[1]), for: .normal)
        button3.setImage(UIImage(named:flags[2]), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

