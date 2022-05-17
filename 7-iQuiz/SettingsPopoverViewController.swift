//
//  SettingsPopoverViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/16/22.
//

import Foundation
import UIKit

class SettingsPopoverViewController: UIViewController {
    
    @IBOutlet weak var urlInputField: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var dataUrl: URL = URL(string: "http://tednewardsandbox.site44.com/questions.json")!
    
    @IBAction func retrieveDataPressed(_ sender: Any) {
        dataUrl = URL(string: urlInputField.text!)!
        URLSession.shared.dataTask(with: dataUrl) { [weak self] data, response, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self!.resultsLabel.text = jsonString
                    }
                }
            } else {
                // handle error...
                return
            }
        }.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
