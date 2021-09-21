//
//  TestVideo.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import WebKit
import AVKit
import Firebase

final class TestVideoVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var goToTestButton: UIButton!
    
    //MARK: - Properties
    
    private var player = AVPlayer()
    
    private var ref: DatabaseReference!
    private var video: String = ""
    private var user: UserProfile!
    
    var childName: String?
    var testName: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("Tests").child(childName ?? "")
        
        ref.observe(.value) { [weak self] (snapshot) in
            
            if let video = snapshot.value as? [String: Any] {
                self?.video = video["TestsVideo"] as! String
                
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
                
            } else {
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки видео", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
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
        
//        let vc = UIStoryboard(name: "TestScreen", bundle: nil).instantiateViewController(identifier: "testViewController") as! TestScreenVC
//        
//        vc.childName = childName
//        vc.testName = testName
        
        
//        navigationController?.pushViewController(vc, animated: true)
        
        let testVC = UIStoryboard(name: "WriteAnswerScreen", bundle: nil).instantiateInitialViewController()
        guard let viewController = testVC else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
