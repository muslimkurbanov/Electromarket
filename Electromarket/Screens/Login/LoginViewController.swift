//
//  ViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
    
    private var ref: DatabaseReference!
        
    private var firebaseAuthManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsSettings()
        
        ref = Database.database().reference(withPath: "users")
    }
    
    @IBAction func goToLoginAcion(_ sender: Any) {
        
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            showAlert(title: nil, message: "Введите почту и пароль")
            return
        }
        
        firebaseAuthManager.signIn(email: email, password: password, navigationController: navigationController!, view: self)
    }
    
    
    @IBAction func registration(_ sender: Any) {
    
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            showAlert(title: nil, message: "Введите почту и пароль")
            return
        }
        
        firebaseAuthManager.createUser(email: email, password: password, view: self, navigationController: navigationController!, ref: ref)
    }
    
    func textFieldsSettings() {
        
        addTitleViewCenter(image: #imageLiteral(resourceName: "Name"))
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        loginTF.keyboardType = .emailAddress
        loginTF.autocorrectionType = .no
        
        passwordTF.autocorrectionType = .no
        passwordTF.isSecureTextEntry = true

        loginTF.delegate = self
        passwordTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTF {
            textField.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            view.endEditing(true)
        }
        return true
        
    }
}
