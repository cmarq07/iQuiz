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
    
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var urlInputField: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    
    weak var delegate: ChangeQuizDataDelegate?
    
    // Initial data URL
    var dataUrl: URL = URL(string: "http://google.com")!
    
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
                // Data was invalid for some reason
            } else {
                // handle error...
                return
            }
        }.resume() // If it gets here, the code was successful
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: [String : Any]())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get URL from settings
        let userDefaults = UserDefaults.standard
        userDefaults.synchronize()
        
        var quizUrl = userDefaults.string(forKey: "quiz_url")
        if quizUrl == nil {
            quizUrl = "http://tednewardsandbox.site44.com/questions.json"
        }
        urlInputField.text = quizUrl
        
        let reachability = try! Reachability(hostname: quizUrl!)
        if(reachability.connection == .wifi || reachability.connection == .cellular) {
            resultsLabel.text = "Data preview will appear here after clicking check now"
        } else {
            resultsLabel.text = "You are currently offline"
            urlInputField.isEnabled = false
            checkNowButton.isEnabled = false
        }
        
    }
}

extension String {
    // Converts a string to JSON
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
