//
//  StabilizerVideo.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import WebKit
import AVKit
import Firebase

class StabilizerVideo: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var videoIsWatched: UILabel!
    
    private let url = "https://youtu.be/bwDCAFJQCuQ"
    private var ref: DatabaseReference!

    private var video: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "TestsVideo")
        
        ref.observe(.value) { [weak self] (snapshot) in
         
            if let video = snapshot.value as? [String: Any] {
                self?.video = video["RellayTestVideo"] as! String
                
                guard let urlString = self?.video else { return }
                guard let url = URL(string: urlString) else { return }
                
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self?.present(playerController, animated: true) {
                    player.play()
                }
                
            } else {
                let alertController = UIAlertController(title: nil, message: "Ошибка загрузки видео", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
//        webView.load(URLRequest(url: URL(string: url)!))
//        if webView.isLoading {
//            webView.isHidden = true
//            videoIsWatched.isHidden = false
//        } else {
//            print("stop")
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: "Назад", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationItem.backButtonTitle = "Назад"

       
    }
    
    @IBAction func watchAgain(_ sender: Any) {
//        webView.load(URLRequest(url: URL(string: url)!))
        
        let player = AVPlayer(url: URL(string: video)!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func watchVideo(_ sender: Any) {
        
    }
    

    @IBAction func goToTest(_ sender: Any) {
        let vc = UIStoryboard(name: "Test", bundle: nil).instantiateViewController(identifier: "stabilizerTest")
        navigationController?.pushViewController(vc, animated: true)
    }

}
