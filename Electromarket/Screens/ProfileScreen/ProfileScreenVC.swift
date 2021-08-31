//
//  ProfileVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit
import Firebase
import DropDown

final class ProfileScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var testResultsTV: UITableView!
    
    //MARK: - Properties
    
    private var ref: DatabaseReference!
    private var newRef: DatabaseReference!
    private var user: UserProfile!
    
    private var firKeys = [String]()
    private var test = [String: [Int]]()
    
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
        
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutItem
    }
    
    //MARK: - Private funcs
    
    private func createErrorLayout() {
        
        let errLabel = UILabel()
        errLabel.text = "Тесты не пройдены"
        errLabel.textColor = .black
        errLabel.frame.size = CGSize(width: 400, height: 30)
        errLabel.center.x = view.center.x
        errLabel.center.y = view.center.y - (tabBarController?.tabBar.frame.height ?? 0)
        errLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        errLabel.textAlignment = .center
        
        view.addSubview(errLabel)
        
        let retryButton = UIButton()
        retryButton.setTitle("Обновить", for: .normal)
        retryButton.frame.size = CGSize(width: 300, height: 50)
        retryButton.layer.cornerRadius = 20
        retryButton.center.x = view.center.x
        retryButton.center.y = errLabel.center.y + 50
        
        retryButton.backgroundColor = .none
        retryButton.setTitleColor(.label, for: .normal)
        
        retryButton.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        
        view.addSubview(retryButton)
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
                    
                    self?.createErrorLayout()
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
    
    @objc private func logout() {
        
        let alertControllet = UIAlertController(title: "Вы действительно хотите выйти из профиля?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Отмена",
                                   style: .cancel,
                                   handler: nil)
        let actionTwo = UIAlertAction(title: "Выйти",
                                      style: .destructive) { (action) in
            
            let vc = UIStoryboard(name: "LoginScreen", bundle: nil).instantiateInitialViewController()
            self.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
            
            do {
                try Auth.auth().signOut()
                
            } catch { print(error.localizedDescription) }
            
            RootStoryboard.rootStoryboard = "LoginScreen"
        }
        
        for action in [action, actionTwo] {
            alertControllet.addAction(action)
        }
        present(alertControllet, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate

extension ProfileScreenVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - UITableViewDataSource

extension ProfileScreenVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firKeys.count
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
            
            cell.configurate(dataSource: arr)
            cell.testNameLabel.text = "\(firKeys[indexPath.row]):  \(tests.last ?? 0)"
        }
        return cell
    }
}
