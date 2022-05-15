//
//  CorrectAnswerViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/14/22.
//

import UIKit

class CorrectAnswerViewController: UIViewController {
    
    var score: Int = 0
    var subject: Subject = Subject(subjectTitle: "", description: "", questions: [])
    var currentQuestion: Int = 0
    
    @IBAction func nextQuestionButtonPressed(_ sender: Any) {
        // Set the storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        // Locate the QuestionViewController
        let questionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        // Pass data to the Question Scene
        questionVC.subject = subject
        questionVC.currentQuestion = currentQuestion + 1
        questionVC.score = score + 1
        
        // Present the Question Scene
        self.present(questionVC, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
