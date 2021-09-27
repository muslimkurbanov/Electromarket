//
//  TestVideo.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import WebKit
import AVKit
import FirebaseAuth
import FirebaseFirestore

final class TestVideoVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var goToTestButton: UIButton!
    
    //MARK: - Properties
    
    private var player = AVPlayer()
    
    private var video: String = ""
    private var user: UserProfile!
    private var database = Firestore.firestore()
    
    var testName: String?
    var testResultName: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        
        let docRef = database.collection("users")
            .document(String(user.uid))
            .collection("Тесты")
            .document(testName ?? "")
        
        docRef.getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки видео", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self?.video = data["Видео теста"] as? String ?? ""
            
            guard let urlString = self?.video else { return }
            guard let url = URL(string: urlString) else { return }
            
            let playerController = AVPlayerViewController()
            self?.player = AVPlayer(url: url)
            playerController.player = self?.player
            
            self?.present(playerController, animated: true) {
                self?.loadingIndicator.stopAnimating()
                self?.goToTestButton.isHidden = false
                self?.player.play()
            }

        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        player.pause()
    }
    
    //MARK: - IBActions
    
    @IBAction private func watchAgain(_ sender: Any) {
        
        guard let urlString = URL(string: video) else {
            let alertController = UIAlertController(title: nil, message: "Ошибка загрузки видео", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let player = AVPlayer(url: urlString)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction private func goToTest(_ sender: Any) {
        
        let viewController = UIStoryboard(name: "TestScreen", bundle: nil).instantiateInitialViewController() as? TestScreenVC
        
        viewController?.testName = testName
        viewController?.testResultName = testResultName
        
//
//        navigationController?.pushViewController(vc, animated: true)
//
//        let testVC = UIStoryboard(name: "WriteAnswerScreen", bundle: nil).instantiateInitialViewController()
//        guard let viewController = testVC else { return }
        guard let vc = viewController else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
