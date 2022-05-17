//
//  ViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/12/22.
//

import UIKit

// Answer Class
struct Answer {
    var answer: String
    var isCorrect: Bool
    
    init(answer: String, isCorrect: Bool) {
        self.answer = answer
        self.isCorrect = isCorrect
    }
    
    func toString() -> String {
        return "{ answer: \"\(answer)\", isCorrect: \(isCorrect) }"
    }
}

// Question Class
struct Question {
    var question: String
    var answers: [Answer]
    
    init(question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
    }
    
    func toString() -> String {
        var answerString = ""
        for answer in answers {
            answerString += answer.toString() + " "
        }
        return "{ question: \"\(question)\", answers: \(answerString) }"
    }
}

// Subject Class
struct Subject {
    var subjectTitle: String
    var description: String
    var questions: [Question]
    
    init(subjectTitle: String, description: String, questions: [Question]) {
        self.subjectTitle = subjectTitle
        self.description = description
        self.questions = questions
    }
    
    func toString() -> String {
        var questionString = ""
        for question in questions {
            questionString += question.toString() + " "
        }
        return "{ subjectTitle: \(subjectTitle), description: \(description), questions: { \(questionString) } }"
    }
}

// Quiz Class
struct Quiz {
    var subjects: [Subject] = []
    
    init() {
        self.subjects = []
    }
    
    init(subjects: [Subject]) {
        self.subjects = subjects
    }
    
    mutating func add(subject: Subject) {
        self.subjects.append(subject)
    }
    
    func toString() -> String {
        var returnString = "[ "
        for subject in 0..<subjects.count - 1 {
            returnString += subjects[subject].toString() + ", "
        }
        returnString += subjects[subjects.count - 1].toString() + " ]"
        return returnString
    }
}

// View Controller
class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var subjectsTableView: UITableView!
    
    // Actions
    // Action for when the settings button is pressed
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as! SettingsPopoverViewController
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        print(self)
        popover.delegate = self
        popover.barButtonItem = sender
        present(vc, animated: true, completion:nil)
    }
    
    // Data
    var quiz: Quiz = Quiz(subjects: [
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
                    Question(question: "What is 23 - 8?", answers: [
                        Answer(answer: "14", isCorrect: false),
                        Answer(answer: "16", isCorrect: false),
                        Answer(answer: "20", isCorrect: false),
                        Answer(answer: "15", isCorrect: true)
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
                    Question(question: "What is (30 * 2) - 4?", answers: [
                        Answer(answer: "56", isCorrect: true),
                        Answer(answer: "-60", isCorrect: false),
                        Answer(answer: "46", isCorrect: false),
                        Answer(answer: "33", isCorrect: false)
                    ]),
                    Question(question: "What is 3^5?", answers: [
                        Answer(answer: "15", isCorrect: false),
                        Answer(answer: "243", isCorrect: true),
                        Answer(answer: "128", isCorrect: false),
                        Answer(answer: "35", isCorrect: false)
                    ]),
                ]
               ),
        // Marvel Questions
        Subject(subjectTitle: "Marvel Super Heroes",
                description: "Avengers assemble",
                questions: [
                    Question(question: "Which of these is an Avenger?", answers: [
                        Answer(answer: "The Flash", isCorrect: false),
                        Answer(answer: "Doctor Strange", isCorrect: true),
                        Answer(answer: "Wolverine", isCorrect: false),
                        Answer(answer: "Thanos", isCorrect: false)
                    ]),
                    Question(question: "Which Avenger uses a round shield that acts as a boomerang?", answers: [
                        Answer(answer: "ShieldMan", isCorrect: false),
                        Answer(answer: "AntMan", isCorrect: false),
                        Answer(answer: "Captain America", isCorrect: true),
                        Answer(answer: "Captain Marvel", isCorrect: false)
                    ]),
                    Question(question: "Which Marvel Hero beheads Thanos (MCU)?", answers: [
                        Answer(answer: "Thor", isCorrect: true),
                        Answer(answer: "Iron Man", isCorrect: true),
                        Answer(answer: "Wolverine", isCorrect: false),
                        Answer(answer: "Galactus", isCorrect: false)
                    ]),
                    Question(question: "Name the Infinity Stones.", answers: [
                        Answer(answer: "Space, Reality, Power, Mind, Time", isCorrect: true),
                        Answer(answer: "Death, Power, Life, Love, Rage", isCorrect: false),
                        Answer(answer: "Power, Courage, Wisdom", isCorrect: false),
                        Answer(answer: "Earth, Wind, Water, Fire", isCorrect: false)
                    ]),
                ]
               ),
        // Science Questions
        Subject(subjectTitle: "Science",
                description: "How the world works",
                questions: [
                    Question(question: "Why is the sky blue?", answers: [
                        Answer(answer: "The way the sun's light travels through the atmosphere", isCorrect: true),
                        Answer(answer: "A reflection of all the water on Earth", isCorrect: false),
                        Answer(answer: "The atmosphere contains particles that are blueish in color", isCorrect: false),
                        Answer(answer: "It's not blue, but in fact the way our eyes see space", isCorrect: false)
                    ]),
                ]
               ),
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDelegate, ChangeQuizDataDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        // Locate the QuestionViewController
        let questionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        // Pass data to the Question Scene
        questionVC.subject = quiz.subjects[indexPath.row]
        questionVC.currentQuestion = 0
        
        // Present the Question Scene
        self.present(questionVC, animated:true, completion:nil)
    }
    
    func changeQuizData(quiz: Quiz) {
        self.dismiss(animated: true) {
            self.quiz = quiz
            self.subjectsTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.subjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as?  SubjectTableViewCell {
            let currentSubject = quiz.subjects[indexPath.row]
            
            cell.subjectLabel?.text = currentSubject.subjectTitle
            cell.descriptionLabel?.text = currentSubject.description
            
            return cell
        }
        
        return UITableViewCell()
        
    }
}
