//
//  VariantsCell.swift
//  HeadyProducts
//
//  Created by apple on 7/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class VariantsCell: UITableViewCell {
    @IBOutlet weak var viewContent: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let colorPink : UIColor = UIColor( red: 45/255, green: 184/255, blue:206/255, alpha: 1.0 )
        viewContent.layer.borderColor = colorPink.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
