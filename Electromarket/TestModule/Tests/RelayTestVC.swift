//
//  RelayTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 09.02.2021.
//

import UIKit

class RelayTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func gotToTest(_ sender: Any) {
        let vc = UIStoryboard(name: "Test", bundle: nil).instantiateViewController(identifier: "relayTest")
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
