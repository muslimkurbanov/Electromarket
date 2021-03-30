//
//  ProfileVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var stabilizerScoreLabel: UILabel!
    
    private var ref: DatabaseReference!
    private var user: UserProfile!

    private var stabilizerScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if ScoreSettings.stabilizerResults != nil {
//            stabilizerScoreLabel.text = "Результат по стабилизаторам: \(ScoreSettings.stabilizerResults ?? 0)"
//        } else {
//            stabilizerScoreLabel.text = "Тест по стабилизаторам еще не пройден"
//        }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tests")
        
        ref.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                self?.stabilizerScore = keys["Результат по стабилизаторам"] as? Int
                self?.stabilizerScoreLabel.text = "Результат по стабилизаторам: \(self?.stabilizerScore ?? 0)"
                
                
            } else {
                self?.stabilizerScoreLabel.text = "Тест по стабилизаторам еще не пройден"
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    self?.viewWillAppear(true)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @objc func showAllUsers() {
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let alertControllet = UIAlertController(title: "Вы действительно хотите выйти из профиля?", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let actionTwo = UIAlertAction(title: "Выйти", style: .destructive) { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "registrationVC")
            self.navigationController?.pushViewController(vc, animated: true)
            RootViewController.rootViewController = "registrationVC"
        }
        alertControllet.addAction(action)
        alertControllet.addAction(actionTwo)
        present(alertControllet, animated: true, completion: nil)
    }
    
}
