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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func goToSelectQuizVC(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectQuiz")
        navigationController?.pushViewController(vc, animated: true)
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
        
//                if #available(iOS 13.0, *) {
//                    let app = UIApplication.shared
//                    let statusBarHeight: CGFloat = app.statusBarFrame.size.height
//
//                    let statusbarView = UIView()
//                                statusbarView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                    view.addSubview(statusbarView)
//
//                    statusbarView.translatesAutoresizingMaskIntoConstraints = false
//                    statusbarView.heightAnchor
//                        .constraint(equalToConstant: statusBarHeight).isActive = true
//                    statusbarView.widthAnchor
//                        .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//                    statusbarView.topAnchor
//                        .constraint(equalTo: view.topAnchor).isActive = true
//                    statusbarView.centerXAnchor
//                        .constraint(equalTo: view.centerXAnchor).isActive = true
//
//                } else {
//                    let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//                    //            statusBar?.backgroundColor = #colorLiteral(red: 0.9220808148, green: 0.2068383396, blue: 0.628426671, alpha: 1)
//                }
    }
}

extension RegistrationVC: ProductViewProtocol {
    
}


