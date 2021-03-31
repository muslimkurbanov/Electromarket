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

    private var ref: DatabaseReference!
    private var tasks = [Task]()
    private var firebaseNames = [String]()
    private var firebaseImages = [String]()
    private var testChilds = [String]()
    var testNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tabBarControllerSettings()
        addItemCenter()
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref = Database.database().reference(withPath: "Tests").child("TestsInformation")
        ref.observe(.value) { [weak self] (snapshot) in
            
            if let keys = snapshot.value as? [String: Any] {
                
                self?.firebaseImages = keys["TestsImage"] as! [String]
                self?.firebaseNames = keys["TestsName"] as! [String]
                self?.testChilds = keys["TestChilds"] as! [String]
                self?.testNames = keys["TestsResultChild"] as! [String]
                
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
        
        let leaderboardItem = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: .plain, target: self, action: #selector(showleaderboard))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = helpItem
        self.tabBarController?.navigationItem.leftBarButtonItem = leaderboardItem
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @objc func showleaderboard() {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "leadNavBar")
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showHelp() {
        let alertController = UIAlertController(title: "Инструкция", message: "После нажатия кнопки 'Приступить к тесту' вы перейдете к просмотру видеоролика с материалом по тесту. После просмотра видеоролика нажмите на кнопку 'Начать тест' и приступайте к выполнению теста", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func addItemCenter() {
        let image = #imageLiteral(resourceName: "Name")
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let contentView = UIView()
        self.tabBarController?.navigationItem.titleView = contentView
        self.tabBarController?.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

extension SelectTestVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firebaseNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Список тестов"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectTestCell
        cell.testName.text = firebaseNames[indexPath.row]
        guard let urlString = URL(string: firebaseImages[indexPath.row]) else { return cell }
        cell.testImage.sd_setImage(with: urlString, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Test", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "stabilizerVideo") as! StabilizerVideo
        vc.childName = testChilds[indexPath.row]
        vc.testName = testNames[indexPath.row]
        
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
