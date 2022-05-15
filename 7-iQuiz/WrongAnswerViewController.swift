//
//  WrongAnswerViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/14/22.
//

import UIKit

class WrongAnswerViewController: UIViewController {
    
    var score: Int = 0
    var subject: Subject = Subject(subjectTitle: "", description: "", questions: [])
    var currentQuestion: Int = 0
    
    @IBAction func nextQuestionButtonPressed(_ sender: Any) {
        // Set the storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        currentQuestion += 1
        if(currentQuestion == subject.questions.count) {
            let finalScoreVC = storyBoard.instantiateViewController(withIdentifier: "FinalScoreViewController") as! FinalScoreViewController
            // Present the Question Scene
            self.present(finalScoreVC, animated:true, completion:nil)
            
        } else {
            // Locate the ViewController
            let questionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            // Pass data to the Question Scene
            questionVC.subject = subject
            questionVC.currentQuestion = currentQuestion
            
            // Present the Question Scene
            self.present(questionVC, animated:true, completion:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
