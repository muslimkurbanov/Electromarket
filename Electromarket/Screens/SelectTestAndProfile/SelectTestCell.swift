//
//  SelectTestCellTableViewCell.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 11.02.2021.
//

import UIKit

class SelectTestCell: UITableViewCell {

    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}