//
//  ViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/12/22.
//

import UIKit

// Subject Class
class Subject {
    var subjectTitle: String
    var description: String

    init(subjectTitle: String, description: String) {
        self.subjectTitle = subjectTitle
        self.description = description
    }
}

// View Controller
class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var subjectsTableView: UITableView!
    
    // Actions
    // Action for when the settings button is pressed
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "The settings button was pressed", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                // Do something when the settings button is pressed
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Data
    let quizSubjects: [AnyObject] = [
        Subject(subjectTitle: "Mathematics", description: "Lots of numbers"),
        Subject(subjectTitle: "Marvel Super Heroes", description: "Avengers Assemble"),
        Subject(subjectTitle: "Science", description: "It's how the world works!"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell tapped")
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizSubjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as?  SubjectTableViewCell {
            let currentSubject = quizSubjects[indexPath.row] as! Subject
            
            cell.subjectLabel?.text = currentSubject.subjectTitle
            cell.descriptionLabel?.text = currentSubject.description
            
            return cell
        }
        
        return UITableViewCell()
        
    }
}
