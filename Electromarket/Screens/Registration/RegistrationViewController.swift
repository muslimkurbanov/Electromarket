//
//  FullRegistrationViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.03.2021.
//

import UIKit
import Firebase
import SHSPhoneComponent

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: SHSPhoneTextField!
    
    private var user: UserProfile!
    private var ref: DatabaseReference!
//    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid))
        
        phoneNumberTF.formatter.setDefaultOutputPattern("+# (###) ###-##-##")

        phoneNumberTF.textDidChangeBlock = { field in
            
            guard let text = field?.text else { return }
            
            if text == "+8" {
                field?.text = "+7"
            }
            
            if text.count == 2 {
                let i = text.index(text.startIndex, offsetBy: 1)
                if ["0", "1", "2", "3", "4", "5", "6", "9"].contains(text[i]) {
                    field?.text = "+7(\(text[i])"
                }
            }
        }
        
        addTitleViewCenter(image: #imageLiteral(resourceName: "Name"))
    }

    @IBAction func registrationAction(_ sender: Any) {
        
        if (firstNameTF.text != "") && lastNameTF.text != "" && (phoneNumberTF.text != "") {
            
            guard phoneNumberTF.text?.count == 18 else {
                showAlert(title: "Введите корректный номер телефона", message: nil)
                return
            }
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
