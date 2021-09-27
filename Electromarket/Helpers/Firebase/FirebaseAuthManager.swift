//
//  FirebaseAuthManager.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthManager {
    
    private var database = Firestore.firestore()
    
    func signIn(email: String, password: String, navigationController: UINavigationController, view: LoginScreenVC) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                
                let alertController = UIAlertController(title: nil, message: "Неверный логин или пароль", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                view.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            let vc = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateInitialViewController()
            navigationController.pushViewController(vc ?? UIViewController(), animated: true)
            RootStoryboard.rootStoryboard = "MainTabBar"
        })
    }
    
    func createUser(email: String, password: String, view: UIViewController, navigationController: UINavigationController) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in

            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                
                let alertController = UIAlertController(title: nil, message: "Неверный формат или аккаун уже создан", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                view.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            let vc = UIStoryboard(name: "RegistrationScreen", bundle: nil).instantiateInitialViewController()
            navigationController.pushViewController(vc ?? UIViewController(), animated: true)
            
            RootStoryboard.rootStoryboard = "RegistrationScreen"
            
            let userRef = self?.database.collection("users")
                .document(user?.user.uid ?? "")
            userRef?.setData(["email": user?.user.email ?? ""])
        })
    }
}
