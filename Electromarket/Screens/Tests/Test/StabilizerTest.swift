//
//  StabilizerTest.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import Firebase

class StabilizerTest: UIViewController {
    
    @IBOutlet private weak var finishTest: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var buttons: [UIButton]!
    
    private var testsRef: DatabaseReference!
    private var ref: DatabaseReference!
    private var user: UserProfile!
    
    private var index = 0
    private var stabilizerScore = 0
    
    private var firebaseQuestions = [String]()
    private var firebaseRightAnswers = [String]()
    private var firebaseAnswers = [[String]]()
    
    private var testResults = [Int]()
    private var testChild: String?
    
    var childName: String?
    var testName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }

        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tests")
        
        ref.observe(.value) { [weak self] (snapshot) in

            if let keys = snapshot.value as? [String: Any] {
                
                if keys[self?.testName ?? ""] as? [Int] != nil {
                    
                    self?.testResults = keys[(self?.testName)!] as! [Int]
                } else {
                    return
                }
            } else {
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        testsRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child(childName ?? "")
        
        testsRef.observe(.value) { [weak self] (snapshot) in
            
            if let keys = snapshot.value as? [String: Any] {

                self?.firebaseQuestions = keys["Questions"] as! [String]
                self?.firebaseRightAnswers = keys["RightAnswers"] as! [String]
                self?.firebaseAnswers = keys["Answers"] as! [[String]]
                
                self?.questionLabel.text = self?.firebaseQuestions[self?.index ?? 0]
                
                
                for (index, button) in self!.buttons.enumerated() {
                    button.setTitle(self?.firebaseAnswers[index][index], for: .normal)
                }
//
            } else {
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки тестов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func finishTestAction(_ sender: Any) {
        
        testResults.append(stabilizerScore)
        
        let testRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("tests")
        testRef.child(testName!).setValue(testResults)
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainTabBar")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func buttons(_ sender: UIButton) {
        if sender.title(for: .normal) == firebaseRightAnswers[index] {
            index += 1
            stabilizerScore += 1
            questionLabel.text = firebaseQuestions[index]
            print("right")
        } else if index <= firebaseQuestions.count {
            index += 1
            questionLabel.text = firebaseQuestions[index]
            print("wrong")
        } else {
            return
        }
        
//        if index == 1 {
        if index == firebaseQuestions.count - 1 {
            for i in buttons {
                i.isHidden = true
            scoreLabel.text = "Ваш результат: \(stabilizerScore)"
            finishTest.isHidden = false
            }
        } else {
            for (index, button) in buttons.enumerated() {
                button.setTitle(firebaseAnswers[self.index][index], for: .normal)
            }

        }
//        } else if index == 2 {
//            for (index, button) in buttons.enumerated() {
//                button.setTitle(thirdAnswers[index], for: .normal)
//            }
//        } else if index == 3 {
//            for (index, button) in buttons.enumerated() {
//                button.setTitle(fourthAnswers[index], for: .normal)
//            }
//        } else {
        //}
            
    }
}
 
