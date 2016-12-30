//
//  ViewController.swift
//  project7
//
//  Created by Yuen Hsi Chang on 12/20/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [[String: String]]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = petitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = DetailViewController()
        detailVc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        performSelector(inBackground: #selector(getJson), with: nil)
    }
    
    func getJson() {
        var urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    parseJson(json: json)
                    return
                }
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parseJson(json: JSON) {
        for result in json["results"].arrayValue {
            petitions.append( [
                "title": result["title"].stringValue,
                "body": result["body"].stringValue,
                "signatures": result["signatureCount"].stringValue  ] )
        }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Data not loaded successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

