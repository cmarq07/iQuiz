//
//  SettingsPopoverViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/16/22.
//

import Foundation
import UIKit

protocol ChangeQuizDataDelegate: AnyObject {
    func changeQuizData(quiz: Quiz)
}

class SettingsPopoverViewController: UIViewController {
    
    @IBOutlet weak var urlInputField: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    
    weak var delegate: ChangeQuizDataDelegate?
    
    // Initial data URL
    var dataUrl: URL = URL(string: "http://tednewardsandbox.site44.com/questions.json")!
    
    // Gets the data from the URL and sets it as the quiz data (also shows up in the settings popover)
    @IBAction func retrieveDataPressed(_ sender: Any) {
        
        // Set the data URL to whatever is in the inputField
        dataUrl = URL(string: urlInputField.text!)!
        // idk what this does tbh
        URLSession.shared.dataTask(with: dataUrl) { [weak self] data, response, error in
            // Check if the data is valid
            if let data = data {
                // Try to serialize the data as JSON
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
                    
                    var newQuiz: Quiz = Quiz()
                    for subject in json {
                        let title = subject["title"]!!
                        let desc = subject["desc"]!!
                        let questions = subject["questions"]!! as! [AnyObject]
                        
                        var newQuestions: [Question] = []
                        
                        for question in questions {
                            let correctAnswer = Int((question["answer"]!! as! NSString).intValue)
                            
                            let answers = question["answers"]!! as! [String]
                            var newAnswers: [Answer] = []
                            var index = 1
                            for answer in answers {
                                let isAnswer = correctAnswer == index
                                index += 1
                                let newAnswer = Answer(answer: answer, isCorrect: isAnswer)
                                newAnswers.append(newAnswer)
                            }
                            let newQuestion: Question = Question(question: question["text"] as! String, answers: newAnswers)
                            newQuestions.append(newQuestion)
                        }
                        
                        let newSubject: Subject = Subject(subjectTitle: title as! String, description: desc as! String, questions: newQuestions)
                        
                        newQuiz.add(subject: newSubject)
                    }
                    
                    // On the main thread...
                    DispatchQueue.main.async {
                        self!.resultsLabel.text = newQuiz.toString()
                        self!.delegate?.changeQuizData(quiz: newQuiz)
                    }
                } catch {
                    
                }
                
                // Check if JSON can be made out of the data
                //                if let jsonString = String(data: data, encoding: .utf8) {
                //                    // On the main thread...
                //                    DispatchQueue.main.async {
                //                        let dataObject = jsonString.toJSON()!
                //                        print(dataObject as AnyObject)
                //
                //                        // var newQuiz = [Subject(subjectTitle: dataObject[0].title, description: dataObject[0].desc, questions: [])]
                //                        if let rootVC = self!.navigationController?.viewControllers.first as? ViewController {
                //                            rootVC.quiz = jsonString.toJSON() as! [AnyObject]
                //                            rootVC.subjectsTableView.reloadData()
                //                        }
                //                        self!.resultsLabel.text = jsonString
                //                    }
                //                    // Couldn't make a JSON string out of the data
                //                } else {
                //                    // handle error...
                //                }
                // Data was invalid for some reason
            } else {
                // handle error...
                return
            }
        }.resume() // If it gets here, the code was successful
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension String {
    // Converts a string to JSON
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
