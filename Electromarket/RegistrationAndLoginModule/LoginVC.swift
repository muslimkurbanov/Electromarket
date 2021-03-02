//
//  LoginVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 02.03.2021.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTF.keyboardType = .emailAddress
        
        passwordTF.autocorrectionType = .no
        passwordTF.isSecureTextEntry = true
        
    }
    

    @IBAction func loginAction(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        guard let email = loginTF.text, let password = passwordTF.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "Вы успешно вошли"
            } else {
                message = "Неверный логин или пароль"
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                if message == "Вы успешно вошли" {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabBar")
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    return
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
