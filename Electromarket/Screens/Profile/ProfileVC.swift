//
//  ProfileVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var rellayScoreLabel: UILabel!
    
    @IBOutlet weak var stabilizerScoreLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if ScoreSettings.stabilizerResults != nil {
            stabilizerScoreLabel.text = "Результат по стабилизаторам: \(ScoreSettings.stabilizerResults ?? 0)"
        } else {
            stabilizerScoreLabel.text = "Тест по стабилизаторам еще не пройден"
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "welcomeVC")
        
        navigationController?.pushViewController(vc, animated: true)
        RootViewController.rootViewController = "welcomeVC"
//        navigationController?.popToViewController(vc, animated: true)
    }
    
}
