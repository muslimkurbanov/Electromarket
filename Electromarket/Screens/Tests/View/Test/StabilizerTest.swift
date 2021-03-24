//
//  StabilizerTest.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import FirebaseDatabase

class StabilizerTest: UIViewController {
    @IBOutlet weak var finishTest: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var index = 0
    var stabilizerScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = StabilizerQuestions.shared.questionsArray[index]
        for (index, button) in buttons.enumerated() {
            button.setTitle(StabilizerQuestions.shared.firstAnswers[index], for: .normal)
        }
    }
    
    @IBAction func finishTestAction(_ sender: Any) {
        
        let searchRef = Database.database().reference()
        searchRef.child("TestResults").setValue([
            "Результат по стабилизаторам": stabilizerScore
        ])
        
        searchRef.child("TestResults").updateChildValues(["stabilizerTest": stabilizerScore])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainTabBar")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func buttons(_ sender: UIButton) {
        if sender.title(for: .normal) == StabilizerQuestions.shared.rightAnswers[index] {
            index += 1
            stabilizerScore += 1
            questionLabel.text = StabilizerQuestions.shared.questionsArray[index]
            print("right")
        } else if index <= 3 {
            index += 1
            questionLabel.text = StabilizerQuestions.shared.questionsArray[index]
            print("wrong")
        } else {
            return
        }
        
        if index == 1 {
            for (index, button) in buttons.enumerated() {
                button.setTitle(StabilizerQuestions.shared.secondAnswers[index], for: .normal)
            }
        } else if index == 2 {
            for (index, button) in buttons.enumerated() {
                button.setTitle(StabilizerQuestions.shared.thirdAnswers[index], for: .normal)
            }
        } else if index == 3 {
            for (index, button) in buttons.enumerated() {
                button.setTitle(StabilizerQuestions.shared.fourthAnswers[index], for: .normal)
            }
        } else {
            for i in buttons {
                i.isHidden = true
            }
            scoreLabel.text = "Ваш результат: \(stabilizerScore)"
            finishTest.isHidden = false
            ScoreSettings.stabilizerResults = stabilizerScore
        }
    }
    

}
