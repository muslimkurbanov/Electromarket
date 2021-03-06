//
//  ProfileTableViewCell.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 31.05.2021.
//

import UIKit
import DropDown

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dropdownView: UIView!
    
    @IBOutlet weak var testNameLabel: UILabel!
    
    private let menu = DropDown()

    func subviewsSettings(dataSource: [String]) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapToItem))

        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dropdownView.addGestureRecognizer(gesture)
        
        menu.anchorView = dropdownView
        menu.bottomOffset = CGPoint(x: 0, y: (menu.anchorView?.plainView.bounds.height)!)
        menu.cornerRadius = 10
        menu.dataSource = dataSource
        menu.backgroundColor = .systemBackground
        menu.textColor = .label
        menu.textFont = UIFont(name: "DINCondensed-Bold", size: 25)!
    }
    
    @objc private func didTapToItem() {
        menu.show()
    }
}

