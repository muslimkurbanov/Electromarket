//
//  ProfileVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit
import Firebase
import DropDown

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var testResultsTV: UITableView!
    
    
    private var ref: DatabaseReference!
    private var newRef: DatabaseReference!
    private var user: UserProfile!
    
    private var firKeys = [String]() {
        didSet {
            print(firKeys)

        }
    }
    private var test = [String: [Int]]() {
        didSet {
            print(test)
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testResultsTV.isHidden = true
        
        self.testResultsTV.delegate = self
        self.testResultsTV.dataSource = self
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let logoutItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logout))
        
        let showLeaderboardItem = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: .plain, target: self, action: #selector(showleaderboard))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutItem
        self.tabBarController?.navigationItem.leftBarButtonItem = showLeaderboardItem
    }
    
    @objc private func loadData() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        
        newRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child("TestsInformation")
        
        newRef.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                
                self?.firKeys = keys["TestsResultChild"] as! [String]
                
                self?.testResultsTV.isHidden = false
                self?.testResultsTV.reloadData()
                
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    
                    self?.testResultsTV.isHidden = true
                    
                    let errLabel = UILabel()
                    errLabel.text = "Тесты не пройдены"
                    errLabel.textColor = .black
                    errLabel.frame.size = CGSize(width: 400, height: 30)
                    errLabel.center.x = self!.view.center.x
                    errLabel.center.y = self!.view.center.y - (self?.tabBarController?.tabBar.frame.height ?? 0)
                    errLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
                    errLabel.textAlignment = .center
                    
                    self?.view.addSubview(errLabel)

                    
                    let retryButton = UIButton()
                    retryButton.setTitle("Повторить попытку", for: .normal)
                    retryButton.frame.size = CGSize(width: 300, height: 50)
                    retryButton.layer.cornerRadius = 20
                    retryButton.center.x = self?.view.center.x ?? 0
                    retryButton.center.y = errLabel.center.y + 50
                    
                    retryButton.backgroundColor = .none
                    retryButton.setTitleColor(.label, for: .normal)
                    
                    retryButton.addTarget(self, action: #selector(self?.loadData), for: .touchUpInside)
                    
                    self?.view.addSubview(retryButton)
                    
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        ref.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                
                if keys["tests"] as? [String: [Int]] != nil {
                    self?.test = keys["tests"] as! [String: [Int]]
                    
                    self?.testResultsTV.reloadData()
                    
                } else { return }
                
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func logout() {
        
        let alertControllet = UIAlertController(title: "Вы действительно хотите выйти из профиля?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Отмена",
                                   style: .cancel,
                                   handler: nil)
        let actionTwo = UIAlertAction(title: "Выйти",
                                      style: .destructive) { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "registrationVC")
            self.navigationController?.pushViewController(vc, animated: true)
            
            do {
                try Auth.auth().signOut()
                
            } catch { print(error.localizedDescription) }
            
            RootViewController.rootViewController = "registrationVC"
        }
        
        for action in [action, actionTwo] {
            alertControllet.addAction(action)
        }
        present(alertControllet, animated: true, completion: nil)
    }
    
    @objc func showleaderboard() {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "leadNavBar")
        present(vc, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firKeys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        
        if test.isEmpty {
            
            cell.testNameLabel.text = "Тест ещё не пройден"

        } else {
            guard let tests = test[firKeys[indexPath.row]] else {
                cell.testNameLabel.text = "Тест ещё не пройден"
                return cell
            }
            
            var arr = [String]()
            var number = 1
            for i in tests {
                arr.append("Тест \(number): \(i)")
                number += 1
            }
            
            cell.subviewsSettings(dataSource: arr)
            cell.testNameLabel.text = "\(firKeys[indexPath.row]):  \(tests.last ?? 0)"
        }
        return cell
    }
}
