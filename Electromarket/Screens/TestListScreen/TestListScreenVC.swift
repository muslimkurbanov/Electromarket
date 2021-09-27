//
//  SelectTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 09.02.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class TestListScreenVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var selectTestTableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    //MARK: - Properties
    
    private var user: UserProfile!
    private var database = Firestore.firestore()
    
    private var testNames = [String]()
    private var testImages = [String]()
    private var testResultNames = [String]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarTitleViewCenter(image: #imageLiteral(resourceName: "Name"))
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserProfile(user: currentUser)
        
        let docRef = database.collection("users")
            .document(String(user.uid))
            .collection("Тесты")
            .document("Информация по тестам")
        
        docRef.getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки Тестов", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    
                    self?.createErrorLabel()
                }))
                
                self?.present(alertController, animated: true, completion: {
                    self?.loadingIndicator.stopAnimating()
                })
                
                return
            }
            
            self?.testImages = data["Картинки тестов"] as? [String] ?? []
            self?.testNames = data["Названия тестов"] as? [String] ?? []
            self?.testResultNames = data["Названия результатов тестов"]  as? [String] ?? []
            
            self?.loadingIndicator.stopAnimating()
            self?.selectTestTableView.isHidden = false
            self?.selectTestTableView.reloadData()
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
        errLabel.alpha = 0
        
        view.addSubview(errLabel)
        
        UIView.animate(withDuration: 0.5) {
            errLabel.alpha = 1
        }
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
        testNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Список тестов"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TestListCell
        
        cell?.configurate(name: testNames[indexPath.row],
                         image: testImages[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension TestListScreenVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "LearnInformationScreen", bundle: nil).instantiateInitialViewController() as? TestVideoVC
        
        vc?.testName = testNames[indexPath.row]
        vc?.testResultName = testResultNames[indexPath.row]
        
        navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
