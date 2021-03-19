//
//  StabilizerVideo.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import WebKit

class StabilizerVideo: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var videoIsWatched: UILabel!
    
    let url = "https://youtu.be/bwDCAFJQCuQ"


    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: url)!))
        if webView.isLoading {
            webView.isHidden = true
            videoIsWatched.isHidden = false
        } else {
            print("stop")
        }
        
    }
    
    @IBAction func watchAgain(_ sender: Any) {
        webView.load(URLRequest(url: URL(string: url)!))
    }
    @IBAction func watchVideo(_ sender: Any) {
//        let player = AVPlayer(url: URL(string: url)!)
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true) {
//            player.play()
//        }
    }
    

    @IBAction func goToTest(_ sender: Any) {
        let vc = UIStoryboard(name: "Test", bundle: nil).instantiateViewController(identifier: "stabilizerTest")
        navigationController?.pushViewController(vc, animated: true)
    }

}
