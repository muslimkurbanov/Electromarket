//
//  SelectTestCellTableViewCell.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit
import SkeletonView
import SDWebImage

final class TestListCell: UITableViewCell {

    @IBOutlet private weak var testName: UILabel!
    @IBOutlet private weak var testImage: UIImageView!
    
    func configurate(name: String, image: String) {
        
        guard let urlString = URL(string: image) else { return }
        
        testName.text = name
        
        testImage.isSkeletonable = true
        testImage.showAnimatedSkeleton()
        testImage.sd_imageTransition = .fade
        testImage.sd_setImage(with: urlString, completed: { [weak self] _,_,_,_  in
            self?.testImage.stopSkeletonAnimation()
            self?.testImage.hideSkeleton()
        })
    }
}
