//
//  ViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 15.01.2021.
//

import UIKit
import Firebase


protocol ProductViewProtocol: class {
    
}

class RegistrationVC: UIViewController {
    
    private let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
    
    private var presenter: RegistrationPresenterProtocol!
    private var ref: DatabaseReference!
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsSettings()
        addItemCenter()
        
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
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: nil, message: "Неверный логин или пароль", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if user != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabBar")
                self.navigationController?.pushViewController(vc, animated: true)
                RootViewController.rootViewController = "mainTabBar"
            }
        })
    }
    
    
    @IBAction func registration(_ sender: Any) {
    
        guard let email = loginTF.text, let password = passwordTF.text, email != "", password != "" else {
            let alertController = UIAlertController(title: nil, message: "Введите почту и пароль", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if user != nil {
                let vc = self.mainStroyboard.instantiateViewController(identifier: "fullRegistration")
                self.navigationController?.pushViewController(vc, animated: true)
                RootViewController.rootViewController = "fullRegistration"
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Неправильный формат или аккаун уже создан", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }

            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self.ref.child((user?.user.uid)!)
            userRef.setValue(["email": user?.user.email])
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func textFieldsSettings() {
        
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


