//
//  FirebaseAuthManager.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import Firebase

final class FirebaseAuthManager {
    
    func signIn(email: String, password: String, navigationController: UINavigationController, view: UIViewController) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: nil, message: "Неверный логин или пароль", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                view.present(alertController, animated: true, completion: nil)
                return
            }
            
            if user != nil {
                let vc = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateInitialViewController()
                navigationController.pushViewController(vc ?? UIViewController(), animated: true)
                RootStoryboard.rootStoryboard = "MainTabBar"
            }
        })
    }
    
    func createUser(email: String, password: String, view: UIViewController, navigationController: UINavigationController, ref: DatabaseReference) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if user != nil {
                
                let vc = UIStoryboard(name: "RegistrationScreen", bundle: nil).instantiateInitialViewController()
                navigationController.pushViewController(vc ?? UIViewController(), animated: true)
                
                RootStoryboard.rootStoryboard = "RegistrationScreen"
            } else {
                
                let alertController = UIAlertController(title: nil, message: "Неправильный формат или аккаун уже создан", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                view.present(alertController, animated: true, completion: nil)
            }

            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
   
            let userRef = ref.child((user?.user.uid)!)
            userRef.setValue(["email": user?.user.email])
        })
    }
}
