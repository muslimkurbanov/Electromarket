//
//  StabilizerTest.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit

class StabilizerTest: UIViewController {
    @IBOutlet weak var finishTest: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = StabilizerQuestions.shared.questionsArray[index]
        for (index, button) in buttons.enumerated() {
            button.setTitle(StabilizerQuestions.shared.firstAnswers[index], for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishTestAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func buttons(_ sender: UIButton) {
        if sender.title(for: .normal) == StabilizerQuestions.shared.rightAnswers[index] {
            index += 1
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
            finishTest.isHidden = false
        }
    }
    

}
