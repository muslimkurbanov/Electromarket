//
//  ItemCenter.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 31.05.2021.
//

import UIKit

extension UIViewController {
    
    func addTitleViewCenter(image: UIImage) {
        let image = image
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let contentView = UIView()
        navigationItem.titleView = contentView
        navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func tabBarTitleViewCenter() {
        let image = #imageLiteral(resourceName: "Name")
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let contentView = UIView()
        tabBarController?.navigationItem.titleView = contentView
        tabBarController?.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
