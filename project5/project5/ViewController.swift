//
//  ViewController.swift
//  project5
//
//  Created by Yuen Hsi Chang on 12/20/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForWord))
        
        if let path = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                allWords = text.components(separatedBy: "\n")
            }
        } else {
            allWords = ["Error"]
        }
        startGame()
    }
    
    func promptForWord() {
        let alert = UIAlertController(title: "Enter a word", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: {
            [unowned self, alert] (action: UIAlertAction) in
            let submission = alert.textFields![0]
            self.submit(submission: submission.text!)
        })
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    func submit(submission: String) {
        if (isValid(text: submission) && isUnique(text: submission) && isReal(text: submission)) {
            usedWords.insert(submission, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let errorTitle = "Error!"
            let errorMessage = "Word submitted either exists, is invalid, or doesn't use words from title."
            let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }

    func isValid(text: String) -> Bool {
        var tempTitle = title!.lowercased()
        for letter in text.characters {
            if let index = tempTitle.range(of: String(letter)) {
                tempTitle.remove(at: index.lowerBound)
            }
            else {
                return false
            }
        }
        return true
    }
    
    func isUnique(text: String) -> Bool {
        return !usedWords.contains(text)
    }
    
    func isReal(text: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, text.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: text, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

