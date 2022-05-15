//
//  QuestionViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/14/22.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    
    // Quiz Data
    var subject: Subject = Subject(subjectTitle: "", description: "", questions: [])
    
    var currentQuestion = 0
    
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Current Question: \(currentQuestion)")
        print("Current Score: \(score)")
        
        self.subjectLabel.text = subject.subjectTitle
        self.currentQuestionLabel.text = subject.questions[currentQuestion].question

        questionsTableView.delegate = self
        questionsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

}

extension QuestionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let answer = subject.questions[currentQuestion].answers[indexPath.row]
        
        // Set the storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if(answer.isCorrect) {
            let vc = storyBoard.instantiateViewController(withIdentifier: "CorrectAnswerViewController") as! CorrectAnswerViewController
            score += 1
            vc.score = score
            vc.subject = subject
            vc.currentQuestion = currentQuestion
            
            // Present the Scene
            self.present(vc, animated:true, completion:nil)
        } else {
            let vc = storyBoard.instantiateViewController(withIdentifier: "WrongAnswerViewController") as! WrongAnswerViewController
            vc.score = score
            
            // Present the Scene
            self.present(vc, animated:true, completion:nil)
        }
    }
}

extension QuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.questions[currentQuestion].answers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as?  QuestionTableViewCell {
            // Setting the current answer
            let answer = subject.questions[currentQuestion].answers[indexPath.row]
            
            cell.configureCell(cellText: subject.questions[currentQuestion].answers[indexPath.row].answer, index: indexPath.row, isCorrect: answer.isCorrect)
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
}
