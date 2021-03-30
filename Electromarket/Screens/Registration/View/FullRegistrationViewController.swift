//
//  FullRegistrationViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import UIKit
import Firebase

class FullRegistrationViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    private var user: UserProfile!
    private var ref: DatabaseReference!
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        
        addItemCenter()
        textFieldsSettings()
    }

    @IBAction func registrationAction(_ sender: Any) {
        
        if (firstNameTF.text != "") && lastNameTF.text != "" && (phoneNumberTF.text != "") {
            
            ref.setValue(["Имя": firstNameTF.text,
                          "Фамилия": lastNameTF.text,
                          "Номер телефона": phoneNumberTF.text
            
            ])
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabBar")
            self.navigationController?.pushViewController(vc, animated: true)
            
            RootViewController.rootViewController = "mainTabBar"
            
        } else {
            let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
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
    
    func textFieldsSettings() {
        firstNameTF.autocapitalizationType = .words
        lastNameTF.autocapitalizationType = .words
        phoneNumberTF.keyboardType = .numberPad
        firstNameTF.autocorrectionType = .no
        lastNameTF.autocorrectionType = .no
    }
}
