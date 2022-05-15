//
//  ViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/12/22.
//

import UIKit

private class Subject {
    var subjectTitle: String
    var description: String

    init(subjectTitle: String, description: String) {
        self.subjectTitle = subjectTitle
        self.description = description
    }
}

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var subjectsTableView: UITableView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Data
    let quizSubjects: [AnyObject] = [
        Subject(subjectTitle: "Mathematics", description: "1+1=?"),
        Subject(subjectTitle: "Marvel Super Heroes", description: "Avengers Assemble"),
        Subject(subjectTitle: "Science", description: "It's how the world works"),
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
