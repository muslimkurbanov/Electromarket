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

final class TestListScreenVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var selectTestTableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    //MARK: - Properties
    
    private var ref: DatabaseReference!
    private var user: UserProfile!
    
    private var firebaseNames = [String]()
    private var firebaseImages = [String]()
    private var testChilds = [String]()
    
    private var testNames = [String]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarTitleViewCenter(image: #imageLiteral(resourceName: "Name"))
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
        
        
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
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    
                    self?.createErrorLabel()
                }))
                
                self?.present(alertController, animated: true, completion: {
                    self?.loadingIndicator.stopAnimating()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarControllerSettings()
    }
    
    //MARK: - Private funcs
    
    private func createErrorLabel() {
        
        let errLabel = UILabel()
        errLabel.text = "Тестов нет"
        errLabel.textColor = .black
        errLabel.frame.size = CGSize(width: 200, height: 30)
        errLabel.center.x = view.center.x
        errLabel.center.y = view.center.y - (tabBarController?.tabBar.frame.height ?? 0)
        errLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        errLabel.textAlignment = .center
        view.addSubview(errLabel)
    }
    
    private func tabBarControllerSettings() {
        
        let helpItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showHelp))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = helpItem
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @objc private func showHelp() {
        let alertController = UIAlertController(title: "Инструкция", message: "Когда вы выберете тест вы перейдете к просмотру видеоролика с материалом по тесту. После просмотра видеоролика нажмите на кнопку 'Начать тест' и приступайте к выполнению теста. По окончанию теста результаты будут опубликованы и размещены на экране профиля.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension TestListScreenVC: UITableViewDataSource {
    
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

//MARK: - UITableViewDelegate

extension TestListScreenVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "LearnInformationScreen", bundle: nil).instantiateInitialViewController() as! TestVideoVC
        
        vc.childName = testChilds[indexPath.row]
        vc.testName = testNames[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
