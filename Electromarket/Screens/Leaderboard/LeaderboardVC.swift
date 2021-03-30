//
//  LeaderboardVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 29.03.2021.
//

import UIKit
import Firebase

class LeaderboardVC: UIViewController {

    @IBOutlet weak var leaderboardTV: UITableView!
    
    private let array = [["Тест по релле: 4", "Тест по проводам: 3"], ["Тест по релле: 2", "Тест по проводам: 1"], ["Тест по релле: 4", "Тест по проводам: 3", "Тест по стабилизаторам: 4"], ["Тест по релле: 4", "Тест по проводам: 4"], ["Тест по релле: 4", "Тест по проводам: 1"]]
    private var headderTitles = ["Камиль Хаметов", "Муслим Курбанов", "Максим Алмазов", "Алексей Степанов", "Вадим Эвелон"]
    private var namesArray = [String]()
    private var user: UserProfile!
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        leaderboardTV.delegate = self
        leaderboardTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        guard let currentUser = Auth.auth().currentUser else { return }

        user = UserProfile(user: currentUser)
        

        ref = Database.database().reference(withPath: "users")
        
        print(ref)
        ref.observe(.value) { [weak self] (snapshot) in
            
            if let keys = snapshot.value as? [String: Any] {
                
//                self?.namesArray.append(keys["users"] as! String)
                self?.leaderboardTV.reloadData()
            } else {
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки тестов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension LeaderboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headderTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headderTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
