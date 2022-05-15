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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subjectLabel.text = subject.subjectTitle
        self.currentQuestionLabel.text = subject.questions[0].question

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
            
            // Present the Scene
            self.present(vc, animated:true, completion:nil)
        } else {
            let vc = storyBoard.instantiateViewController(withIdentifier: "WrongAnswerViewController") as! WrongAnswerViewController
            
            // Present the Scene
            self.present(vc, animated:true, completion:nil)
        }
    }
}

extension QuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.questions[0].answers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as?  QuestionTableViewCell {
            // Setting the current answer
            let answer = subject.questions[currentQuestion].answers[indexPath.row]
            
            cell.configureCell(cellText: subject.questions[0].answers[indexPath.row].answer, index: indexPath.row, isCorrect: answer.isCorrect)
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
}
