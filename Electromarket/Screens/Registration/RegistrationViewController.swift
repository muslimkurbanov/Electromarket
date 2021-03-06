//
//  FullRegistrationViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    private var user: UserProfile!
    private var ref: DatabaseReference!
//    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        
        addItemCenter()
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
            showAlert(title: "Заполните все поля", message: nil)
        }
    }
}
