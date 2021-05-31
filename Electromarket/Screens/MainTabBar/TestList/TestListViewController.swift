//
//  SelectTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 09.02.2021.
//

import UIKit
import Firebase
import SDWebImage
import SkeletonView

final class TestListViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var selectTestTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    //MARK: - Properties
    private var ref: DatabaseReference!
    private var user: UserProfile!
    
    private var firebaseNames = [String]()
    private var firebaseImages = [String]()
    private var testChilds = [String]()
    
    var testNames = [String]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarAddItemCenter()
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarControllerSettings()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserProfile(user: currentUser)
        
        ref = Database.database().reference(withPath: "users")
            .child(String(user.uid))
            .child("Tests")
            .child("TestsInformation")
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
    
    //MARK: - Private unctions
    private func tabBarControllerSettings() {
        
        let helpItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showHelp))
        
        let leaderboardItem = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: .plain, target: self, action: #selector(showleaderboard))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = helpItem
        self.tabBarController?.navigationItem.leftBarButtonItem = leaderboardItem
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @objc private func showleaderboard() {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "leadNavBar")
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func showHelp() {
        let alertController = UIAlertController(title: "Инструкция", message: "После нажатия кнопки 'Приступить к тесту' вы перейдете к просмотру видеоролика с материалом по тесту. После просмотра видеоролика нажмите на кнопку 'Начать тест' и приступайте к выполнению теста", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - DataSource
extension TestListViewController: UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestListCell
        cell.testName.text = firebaseNames[indexPath.row]
        guard let urlString = URL(string: firebaseImages[indexPath.row]) else { return cell }
        
        cell.testImage.isSkeletonable = true
        cell.testImage.showAnimatedSkeleton()
        cell.testImage.sd_imageTransition = .fade
        cell.testImage.sd_setImage(with: urlString, completed: {_,_,_,_ in
            cell.testImage.stopSkeletonAnimation()
            cell.testImage.hideSkeleton()
        })
        return cell
    }
}

//MARK: - Delegate
extension TestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Test", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "stabilizerVideo") as! StabilizerVideo
        vc.childName = testChilds[indexPath.row]
        vc.testName = testNames[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
