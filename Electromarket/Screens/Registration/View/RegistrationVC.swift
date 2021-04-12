//
//  ViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import Firebase

protocol ProductViewProtocol: class {}

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
    
    private var presenter: RegistrationPresenterProtocol!
    private var ref: DatabaseReference!
        
    private var firebaseAuthManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsSettings()
        
        ref = Database.database().reference(withPath: "users")
        presenter = RegistrationPresenter(view: self)
    }
    
    @IBAction func goToLoginAcion(_ sender: Any) {
        
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            let alertController = UIAlertController(title: nil, message: "Введите почту и пароль", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        firebaseAuthManager.signIn(email: email, password: password, navigationController: navigationController!, view: self)
    }
    
    
    @IBAction func registration(_ sender: Any) {
    
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            let alertController = UIAlertController(title: nil, message: "Введите почту и пароль", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        firebaseAuthManager.createUser(email: email, password: password, view: self, navigationController: navigationController!, ref: ref)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func textFieldsSettings() {
        
        addItemCenter()
        
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
    
    func addItemCenter() {
        let image = #imageLiteral(resourceName: "Name")
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension RegistrationVC: ProductViewProtocol {
    
}
