//
//  ViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import Firebase

final class LoginScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var loginTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    
    //Constraints
    
    @IBOutlet private weak var loginTFTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var welcomeLabelTopConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
        
    private var firebaseAuthManager = FirebaseAuthManager()
    private var ref: DatabaseReference!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        textFieldsSettings()
        constraintsSettings()
    }
    
    //MARK: - Private funcs
    
    private func textFieldsSettings() {
        
        addTitleViewCenter(image: #imageLiteral(resourceName: "Name"))
        
        navigationItem.setHidesBackButton(true, animated: true)

        loginTF.keyboardType = .emailAddress
        loginTF.autocorrectionType = .no
        
        passwordTF.autocorrectionType = .no
        passwordTF.isSecureTextEntry = true

        loginTF.delegate = self
        passwordTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func constraintsSettings() {
        
        if view.frame.height <= 667.0 {
            loginTFTopConstraint.constant = 0
            loginButtonTopConstraint.constant = 50
        }
        
        if view.frame.height <= 568.0 {
            welcomeLabelTopConstraint.constant = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction private func goToLoginAcion(_ sender: Any) {
        
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            showAlert(title: nil, message: "Введите почту и пароль")
            return
        }
        
        firebaseAuthManager.signIn(email: email, password: password, navigationController: navigationController!, view: self)
    }
    
    @IBAction private func registration(_ sender: Any) {
    
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            showAlert(title: nil, message: "Введите почту и пароль")
            return
        }
        
        firebaseAuthManager.createUser(email: email, password: password, view: self, navigationController: navigationController!, ref: ref)
    }
}

//MARK: - UITextFieldDelegate

extension LoginScreenVC: UITextFieldDelegate {
    
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
