//
//  FinalScoreViewController.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/14/22.
//

import UIKit

class FinalScoreViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Quiz Data
    var finalScore: Int = 0
    var totalQuestions: Int = 0
    
    // Actions
    @IBAction func backToHomePagePressed(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = getScoreTitle()
        self.scoreLabel.text = "Score: \(finalScore) / \(totalQuestions)"
    }
    
    func getScoreTitle() -> String {
        let finalScoreRatio: Double = Double(finalScore) / Double(totalQuestions)
        var scoreTitle: String = ""
        if(finalScoreRatio >= 1.0) {
            scoreTitle = "Perfect!"
        } else if(finalScoreRatio >= 0.85) {
            scoreTitle = "Great!"
        } else if(finalScoreRatio >= 0.7) {
            scoreTitle = "Almost!"
        } else if(finalScoreRatio >= 0.5) {
            scoreTitle = "Mehhh!"
        } else if(finalScoreRatio < 0.5) {
            scoreTitle = "Bad!"
        }
        
        return scoreTitle
    }
}
