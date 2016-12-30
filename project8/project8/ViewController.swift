//
//  ViewController.swift
//  project8
//
//  Created by Yuen Hsi Chang on 12/21/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for subview in view.subviews where subview.tag == 1001 {
            let button = subview as! UIButton
            letterButtons.append(button)
            button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        loadLevel(level: level)
    }
    
    func letterTapped(button: UIButton) {
        currentAnswer.text = currentAnswer.text! + button.titleLabel!.text!
        activatedButtons.append(button)
        button.isHidden = true
    }
    
    func loadLevel(level: Int) {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            if let levelFileContent = try? String(contentsOfFile: levelFilePath) {
                var lines = levelFileContent.components(separatedBy: "\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ":")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        clueLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel(level: level)
        
        for button in letterButtons {
            button.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(_ sender: Any) {
        if let solutionIndex = solutions.index(of: currentAnswer.text!) {
            activatedButtons.removeAll()
            
            var splitClues = answerLabel.text!.components(separatedBy: "\n")
            splitClues[solutionIndex] = currentAnswer.text!
            answerLabel.text = splitClues.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let alert = UIAlertController(title: "Congratulations!", message: "Would you like to move on to the next level?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "aite", style: .default, handler: levelUp))
                present(alert, animated: true)
            }
        }
    }

    @IBAction func clearTapped(_ sender: Any) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
}

