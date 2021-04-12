//
//  FirebaseAuthManager.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import Firebase

class FirebaseAuthManager {
    
    func signIn(email: String, password: String, navigationController: UINavigationController, view: UIViewController) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: nil, message: "Неверный логин или пароль", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                view.present(alertController, animated: true, completion: nil)
                return
            }
            
            if user != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainTabBar")
                navigationController.pushViewController(vc, animated: true)
                RootViewController.rootViewController = "mainTabBar"
            }
        })
    }
    
    func createUser(email: String, password: String, view: UIViewController, navigationController: UINavigationController, ref: DatabaseReference) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if user != nil {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "fullRegistration")
                navigationController.pushViewController(vc, animated: true)
                RootViewController.rootViewController = "fullRegistration"
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
    
    
    
    
    
    
    
//    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
//            if let user = authResult?.user {
//                completionBlock(true)
//            } else {
//                completionBlock(false)
//            }
//        }
//    }
//
//    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
//            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
//                completionBlock(false)
//            } else {
//                completionBlock(true)
//            }
//        }
//    }
}
