//
//  ProfileTableViewCell.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 31.05.2021.
//

import UIKit
import DropDown

final class ProfileTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var dropdownView: UIView!
    
    @IBOutlet weak var testNameLabel: UILabel!
    
    //MARK: - Properties
    
    private let menu = DropDown()

    //MARK: - Private func
    
    func configurate(dataSource: [String]) {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapToItem))

        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dropdownView.addGestureRecognizer(gesture)
        
        menu.anchorView = dropdownView
        menu.bottomOffset = CGPoint(x: 0, y: (menu.anchorView?.plainView.bounds.height) ?? 0)
        menu.viewCornerRadius = 10
        menu.dataSource = dataSource
        menu.backgroundColor = .systemBackground
        menu.textColor = .label
        menu.selectionBackgroundColor = .clear
        menu.textFont = UIFont(name: "DINCondensed-Bold", size: 25) ?? UIFont()
    }
    
    @objc private func didTapToItem() {
        menu.show()
    }
}

