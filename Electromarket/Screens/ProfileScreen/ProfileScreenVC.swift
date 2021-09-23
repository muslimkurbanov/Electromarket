//
//  ProfileVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import DropDown

final class ProfileScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var testResultsTV: UITableView!
    
    //MARK: - Properties
    
//    private var ref: DatabaseReference!
//    private var newRef: DatabaseReference!
    private var user: UserProfile!
    private var database = Firestore.firestore()
    
    private var testResultNames = [String]()
    private var test = [String: [Int]]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testResultsTV.isHidden = true
        
        testResultsTV.delegate = self
        testResultsTV.dataSource = self
        
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
        
        let testsRef = database.collection("users")
            .document(String(user.uid))
        
        let testResultNameRef = database.collection("users")
            .document(String(user.uid))
            .collection("Тесты")
            .document("Информация по тестам")
        
        testResultNameRef.getDocument { [weak self] snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    
                    self?.testResultsTV.isHidden = true
                    
                    self?.createErrorLayout()
                }))
                
                self?.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self?.testResultNames = data["Названия результатов тестов"] as? [String] ?? []
            
            print("cccc",self?.testResultNames)
            
            self?.testResultsTV.isHidden = false
            self?.testResultsTV.reloadData()
        }
        
        testsRef.getDocument { [weak self] snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                }))
                self?.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if data["Результаты по тестам"] as? [String: [Int]] != nil {
                
                self?.test = data["Результаты по тестам"] as? [String: [Int]] ?? [:]
                
                print("cccc", self?.test)
                self?.testResultsTV.reloadData()
                
            } else { return }
        }
        
//        ref.observe(.value) { [weak self] (snapshot) in
//            if let keys = snapshot.value as? [String: Any] {
//
//                if keys["tests"] as? [String: [Int]] != nil {
//                    self?.test = keys["tests"] as! [String: [Int]]
//
//                    self?.testResultsTV.reloadData()
//
//                } else { return }
//
//            } else {
//
//                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки результатов", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
//                }))
//                self?.present(alertController, animated: true, completion: nil)
//            }
//        }


//        ref = Database.database().reference(withPath: "users").child(String(user.uid))
//
//        newRef = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child("Информация по тестам")
//
//        newRef.observe(.value) { [weak self] (snapshot) in
//            if let keys = snapshot.value as? [String: Any] {
//
//                self?.firKeys = keys["Названия результатов тестов"] as! [String]
//
//                self?.testResultsTV.isHidden = false
//                self?.testResultsTV.reloadData()
//
//            } else {
//
//
//            }
//        }
        
    }
    
    @objc private func logout() {
        
        let alertControllet = UIAlertController(title: "Вы действительно хотите выйти из профиля?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Отмена",
                                   style: .cancel,
                                   handler: nil)
        let actionTwo = UIAlertAction(title: "Выйти",
                                      style: .destructive) { [weak self] (action) in
            
            let vc = UIStoryboard(name: "LoginScreen", bundle: nil).instantiateInitialViewController()
            
            self?.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
            
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
        testResultNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        
        if test.isEmpty {
            
            cell.testNameLabel.text = "Тест ещё не пройден"

        } else {
            guard let tests = test[testResultNames[indexPath.row]] else {
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
            cell.testNameLabel.text = "\(testResultNames[indexPath.row]):  \(tests.last ?? 0)"
        }
        return cell
    }
}
