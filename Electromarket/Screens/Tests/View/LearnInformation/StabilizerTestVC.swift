//
//  StabilizerTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit

class StabilizerTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backItem?.title = "Назад"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToTest(_ sender: Any) {
        let vc = UIStoryboard(name: "Test", bundle: nil).instantiateViewController(identifier: "stabilizerVideo")
        navigationController?.pushViewController(vc, animated: true)
    }

}
