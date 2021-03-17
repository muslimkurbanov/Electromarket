//
//  ViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit

protocol ProductViewProtocol: class {
    
}

class RegistrationVC: UIViewController {
    
    var presenter: RegistrationPresenterProtocol!
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RegistrationPresenter(view: self)
        addItemCenter()
        
        loginTF.keyboardType = .emailAddress
        
        passwordTF.autocorrectionType = .no
        passwordTF.isSecureTextEntry = true

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func goToLoginAcion(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func registration(_ sender: Any) {
        let signUpManager = FirebaseAuthManager()
        if let email = loginTF.text, let password = passwordTF.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "Профиль успешно создан"
                } else {
                    message = "Неверный формат"
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    if message == "Профиль успешно создан" {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
}

extension RegistrationVC: ProductViewProtocol {
    
}


