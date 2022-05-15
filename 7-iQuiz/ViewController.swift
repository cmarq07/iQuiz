//
//  ViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/12/22.
//

import UIKit

// Answer Class
class Answer {
    var answer: String
    var isCorrect: Bool
    
    init(answer: String, isCorrect: Bool) {
        self.answer = answer
        self.isCorrect = isCorrect
    }
}

// Question Class
class Question {
    var question: String
    var answers: [Answer]
    
    init(question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
    }
}

// Subject Class
class Subject {
    var subjectTitle: String
    var description: String
    var questions: [Question]
    
    init(subjectTitle: String, description: String, questions: [Question]) {
        self.subjectTitle = subjectTitle
        self.description = description
        self.questions = questions
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
    let quiz: [AnyObject] = [
        // Math Questions
        Subject(subjectTitle: "Mathematics",
                description: "Lots of numbers",
                questions: [
                    Question(question: "What is 7 + 3?", answers: [
                        Answer(answer: "10", isCorrect: true),
                        Answer(answer: "73", isCorrect: false),
                        Answer(answer: "9", isCorrect: false),
                        Answer(answer: "17", isCorrect: false)
                    ]),
                    Question(question: "What is 9 * 8?", answers: [
                        Answer(answer: "63", isCorrect: false),
                        Answer(answer: "98", isCorrect: false),
                        Answer(answer: "72", isCorrect: true),
                        Answer(answer: "81", isCorrect: false)
                    ]),
                    Question(question: "What is 60 / 5?", answers: [
                        Answer(answer: "13", isCorrect: false),
                        Answer(answer: "12", isCorrect: true),
                        Answer(answer: "10", isCorrect: false),
                        Answer(answer: "11", isCorrect: false)
                    ]),
                ]
               ),
        // Marvel Questions
        Subject(subjectTitle: "Marvel Super Heroes",
                description: "Avengers assemble",
                questions: [
                    Question(question: "What is 60 / 5?", answers: [
                        Answer(answer: "10", isCorrect: true),
                        Answer(answer: "12", isCorrect: true),
                        Answer(answer: "9", isCorrect: false),
                        Answer(answer: "17", isCorrect: false)
                    ]),
                ]
               ),
        // Science Questions
        Subject(subjectTitle: "Science",
                description: "How the world works",
                questions: [
                    Question(question: "What is 7+3?", answers: [
                        Answer(answer: "10", isCorrect: true),
                        Answer(answer: "73", isCorrect: false),
                        Answer(answer: "9", isCorrect: false),
                        Answer(answer: "17", isCorrect: false)
                    ]),
                ]
               ),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        // Locate the QuestionViewController
        let questionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        // Pass data to the Question Scene
        questionVC.subject = quiz[indexPath.row] as! Subject
        questionVC.currentQuestion = 0
        
        // Present the Question Scene
        self.present(questionVC, animated:true, completion:nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as?  SubjectTableViewCell {
            let currentSubject = quiz[indexPath.row] as! Subject
            
            cell.subjectLabel?.text = currentSubject.subjectTitle
            cell.descriptionLabel?.text = currentSubject.description
            
            return cell
        }
        
        return UITableViewCell()
        
    }
}
