//
//  WelcomeVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addItemCenter()
        // Do any additional setup after loading the view.
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
