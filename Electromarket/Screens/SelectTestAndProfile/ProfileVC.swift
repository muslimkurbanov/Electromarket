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
    
    @IBOutlet weak var testResultsTV: UITableView!
    
    private var ref: DatabaseReference!
    private var newRef: DatabaseReference!
    private var user: UserProfile!

    private var stabilizerScore: Int?
    private var testResultArray = [Int]()
    
    private var firKeys = [String]()
    private var test = [String: [Int]]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        newRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child("TestsInformation")
        
        newRef.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                
                self?.firKeys = keys["TestsResultChild"] as! [String]
                self?.testResultsTV.reloadData()
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        ref.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                
                if keys["tests"] as? [String: [Int]] != nil {
                    self?.test = keys["tests"] as! [String: [Int]]
                    self?.testResultsTV.reloadData()
                } else {
                    return
                }
                
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        self.testResultsTV.delegate = self
        self.testResultsTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let logoutItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logout))
        
        let showLeaderboardItem = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: .plain, target: self, action: #selector(showleaderboard))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutItem
        self.tabBarController?.navigationItem.leftBarButtonItem = showLeaderboardItem
    }
    
    @objc func logout() {
        
        let alertControllet = UIAlertController(title: "Вы действительно хотите выйти из профиля?", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let actionTwo = UIAlertAction(title: "Выйти", style: .destructive) { (action) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "registrationVC")
            self.navigationController?.pushViewController(vc, animated: true)
            do {
                try Auth.auth().signOut()
                
            } catch {
                print(error.localizedDescription)
            }
            RootViewController.rootViewController = "registrationVC"
        }
        
        alertControllet.addAction(action)
        alertControllet.addAction(actionTwo)
        present(alertControllet, animated: true, completion: nil)
    }
    
    @objc func showleaderboard() {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "leadNavBar")
        present(vc, animated: true, completion: nil)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        test[firKeys[section]]?.count ?? 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        firKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firKeys[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if test.isEmpty {
            cell.textLabel?.text = "Тест ещё не пройден"
        } else {
            guard let tests = test[firKeys[indexPath.section]]?[indexPath.row] else {
                cell.textLabel?.text = "Тест ещё не пройден"
                return cell
            }
            cell.textLabel?.text = "Тест \(indexPath.row + 1): \(tests)"
        }
        return cell
    }
}
