//
//  SelectTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 09.02.2021.
//

import UIKit
import Firebase
import SDWebImage

class SelectTestVC: UIViewController {
    
    @IBOutlet weak var selectTestTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let arrayOfNames = ["Тест по стабилизаторыам"]
    private let arrayOfImages = [#imageLiteral(resourceName: "stable")]
    private var keys = ["stabilizerVideo"]

    private var ref: DatabaseReference!
    private var tasks = [Task]()
    private var firebaseKeys = [String]()
    private var firebaseNames = [String]()
    private var firebaseImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarControllerSettings()
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref = Database.database().reference(withPath: "Tests").child("TestsInformation")
        
        ref.observe(.value) { [weak self] (snapshot) in
            
            if let keys = snapshot.value as? [String: Any] {
//                self?.firebaseKeys.append(keys["identifier"] as! String)
//                self?.firebaseNames.append(keys["testName"] as! String)
//                self?.firebaseImages.append(keys["TestImage"] as! String)
                self?.firebaseImages = keys["TestsImage"] as! [String]
                self?.firebaseNames = keys["TestsName"] as! [String]
                
                self?.loadingIndicator.stopAnimating()
                self?.selectTestTableView.isHidden = false
                self?.selectTestTableView.reloadData()
            } else {
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки Тестов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tabBarControllerSettings() {
        
        let helpItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showHelp))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = helpItem
        self.tabBarController?.title = "Список тестов"
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @objc func showHelp() {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//
//        let vc = sb.instantiateViewController(identifier: "stable")
//        navigationController?.present(vc, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "Инструкция", message: "После нажатия кнопки 'Приступить к тесту' вы перейдете к просмотру видеоролика с материалом по тесту. После просмотра видеоролика нажмите на кнопку 'Начать тест' и приступайте к выполнению теста", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension SelectTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firebaseNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectTestCell
        cell.testName.text = firebaseNames[indexPath.row]
        guard let urlString = URL(string: firebaseImages[indexPath.row]) else { return cell }
        cell.testImage.sd_setImage(with: urlString, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        pushToTest(key: firebaseKeys[indexPath.row])
        let sb = UIStoryboard(name: "Test", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "stabilizerVideo")
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectTestVC {
    func pushToTest(key: String) {
        let sb = UIStoryboard(name: "Test", bundle: nil)
        let vc = sb.instantiateViewController(identifier: key)
        navigationController?.pushViewController(vc, animated: true)
    }
}
