//
//  StabilizerTest.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class TestScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var finishTest: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var finishLabel: UILabel!
    @IBOutlet private weak var questionScrollView: UIScrollView!
    
    @IBOutlet private var buttons: [UIButton]!
    
    //MARK: - Properties
    
//    private var testsRef: DatabaseReference!
//    private var ref: DatabaseReference!
    private var user: UserProfile!
    private var database = Firestore.firestore()
    
    private var firebaseQuestions = [String]()
    private var firebaseRightAnswers = [String]()
    private var firebaseAnswers = [[String: String]]()
    
    private var testResults = [Int]()
    
    private var index = 0
    private var testScore = 0
    
    var testName: String?
    var testResultName: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionScrollView.contentSize = CGSize(width: 376, height: 196)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        
        let resultsRef = database.collection("users")
            .document(String(user.uid))
        
        resultsRef.getDocument { [weak self] snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else { return }
            
            let testres = data["Результаты по тестам"] as? [String: [Int]]
            
            if testres?[self?.testResultName ?? ""] != nil {
                
                self?.testResults = testres?[self?.testResultName ?? ""] ?? []
            } else {
                return
            }
        }
        
//        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tests")
//
//        ref.observe(.value) { [weak self] (snapshot) in
//
//            if let keys = snapshot.value as? [String: Any] {
//
//                if keys[self?.testResultName ?? ""] as? [Int] != nil {
//
//                    self?.testResults = keys[(self?.testResultName)!] as! [Int]
//                } else {
//                    return
//                }
//            } else {
//                return
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let testRef = database.collection("users")
            .document(String(user.uid))
            .collection("Тесты")
            .document(testName ?? "")
        
        testRef.getDocument { [weak self] snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                
                self?.showAlert(title: nil, message: "Ошибка загрузки тестов")
                return
            }
            
            self?.firebaseQuestions = data["Вопросы"] as? [String] ?? []
            self?.firebaseRightAnswers = data["Правильные ответы"] as? [String] ?? []
            self?.firebaseAnswers = data["Ответы"] as? [[String: String]] ?? [[:]]
            
            self?.questionLabel.text = self?.firebaseQuestions[self?.index ?? 0]
            
            for (index, button) in self!.buttons.enumerated() {
                
                button.setTitle(self?.firebaseAnswers[self?.index ?? 0][String(index)], for: .normal)
            }
        }
        
//        testsRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child(testName ?? "")
//
//        testsRef.observe(.value) { [weak self] (snapshot) in
//
//            if let keys = snapshot.value as? [String: Any] {
//
//                self?.firebaseQuestions = keys["Questions"] as! [String]
//                self?.firebaseRightAnswers = keys["RightAnswers"] as! [String]
//                self?.firebaseAnswers = keys["Answers"] as! [[String]]
//
//                self?.questionLabel.text = self?.firebaseQuestions[self?.index ?? 0]
//
//
//                for (index, button) in self!.buttons.enumerated() {
//                    button.setTitle(self?.firebaseAnswers[self!.index][index], for: .normal)
//                }
//
//            } else {
//                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки тестов", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                self?.present(alertController, animated: true, completion: nil)
//            }
//        }
    }
    
    //MARK: - IBActions
    
    @IBAction private func finishTestAction(_ sender: Any) {
        
        testResults.append(testScore)
        
        let testRef = database.collection("users")
            .document(String(user.uid))
        
        print(testResults, "aqqqq")
        print(testResultName, "aqqqq")
//        [testResultName ?? "": testResults]
        testRef.setData(["Результаты по тестам": [testResultName ?? "": testResults]], merge: true)
//        testRef.setValue(testResults, forKey: testResultName ?? "")

//        let testRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("tests")
//        testRef.child(testResultName!).setValue(testResults)

        let vc = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateInitialViewController()

        navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
    }
    
    @IBAction private func buttons(_ sender: UIButton) {
        
        if sender.title(for: .normal) == firebaseRightAnswers[index] {
            index += 1
            testScore += 1
            questionLabel.text = firebaseQuestions[index]
            print("right")
        } else if index <= firebaseQuestions.count {
            index += 1
            questionLabel.text = firebaseQuestions[index]
            print("wrong")
        } else {
            return
        }
        
        if index == firebaseQuestions.count - 1 {
            for i in buttons {
                i.isHidden = true
                scoreLabel.text = "Ваш результат: \(testScore)"
                finishTest.isHidden = false
                questionScrollView.isHidden = true
                finishLabel.isHidden = false
            }
        } else {
            for (index, button) in buttons.enumerated() {
                button.setTitle(firebaseAnswers[self.index][String(index)], for: .normal)
            } 
        }
    }
}
