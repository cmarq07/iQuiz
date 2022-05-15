//
//  QuestionTableViewCell.swift
//  7-iQuiz
//
//  Created by Christian Marquis Calloway on 5/14/22.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var answerLabel: UILabel!
    
    var isCorrect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(cellText: String, index: Int, isCorrect: Bool) {
        self.answerLabel.text = cellText
        self.backgroundColor =  index % 2 == 0 ? .white : .lightGray
        self.isCorrect = isCorrect
    }
    
}
