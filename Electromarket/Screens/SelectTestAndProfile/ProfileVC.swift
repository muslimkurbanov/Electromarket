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
        newRef = Database.database().reference(withPath: "Tests").child("TestsInformation")
        
        newRef.observe(.value) { [weak self] (snapshot) in
            if let keys = snapshot.value as? [String: Any] {
                
                self?.firKeys = keys["TestsResultChild"] as! [String]
                self?.testResultsTV.reloadData()
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
     
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
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
//        cell.backgroundColor = .lightGray
      
        if test.isEmpty {
            cell.textLabel?.text = "Тест ещё не пройден"
        } else {
            guard let tests = test[firKeys[indexPath.section]]?[indexPath.row] else {
                cell.textLabel?.text = "Тест ещё не пройден"
                return cell
            }
//            cell.textLabel?.text = "Тест \(indexPath.row + 1): \(test[firKeys[indexPath.section]]?[indexPath.row] ?? 0)"
            cell.textLabel?.text = "Тест \(indexPath.row + 1): \(tests)"

        }
        return cell
    }
}
