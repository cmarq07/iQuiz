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

extension Answer: Encodable {
    enum CodingKeys: String, CodingKey {
        case answer
        case isCorrect
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(answer, forKey: .answer)
        try container.encode(isCorrect, forKey: .isCorrect)
    }
}

extension Answer: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        answer = try values.decode(String.self, forKey: .answer)
        isCorrect = try values.decode(Bool.self, forKey: .isCorrect)
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

extension Question: Encodable {
    enum CodingKeys: String, CodingKey {
        case question
        case answers
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(question, forKey: .question)
        try container.encode(answers, forKey: .answers)
    }
}

extension Question: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        question = try values.decode(String.self, forKey: .question)
        answers = try values.decode([Answer].self, forKey: .answers)
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

extension Subject: Encodable {
    enum CodingKeys: String, CodingKey {
        case subjectTitle
        case description
        case questions
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subjectTitle, forKey: .subjectTitle)
        try container.encode(description, forKey: .description)
        try container.encode(questions, forKey: .questions)
    }
}

extension Subject: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        subjectTitle = try values.decode(String.self, forKey: .subjectTitle)
        description = try values.decode(String.self, forKey: .description)
        questions = try values.decode([Question].self, forKey: .questions)
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

extension Quiz: Encodable {
    enum CodingKeys: String, CodingKey {
        case subjects
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subjects, forKey: .subjects)
    }
}

extension Quiz: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        subjects = try values.decode([Subject].self, forKey: .subjects)
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
    var quiz: Quiz = Quiz()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let localData = self.readLocalFile(forName: "LocalQuizData") {
            print(localData)
            quiz = self.parse(jsonData: localData)
        }
        
        let urlString = "LocalQuizData"
        
    }
    
    // Function to read the Local Quiz Data
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    // Function to parse the json data read from the file
    private func parse(jsonData: Data) -> Quiz {
        do {
            let decodedData = try JSONDecoder().decode(Quiz.self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            return Quiz()
        }
    }
    
    // Function to load the JSON from the file
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
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
