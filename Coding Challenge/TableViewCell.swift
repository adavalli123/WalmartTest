//
//  TableViewCell.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, overView: String, image: UIImage?) {
        self.titleLabel.text = title
        self.overViewLabel.text = overView
        posterImageView.image = image
    }
}
