//
//  DetailViewController.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/9/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var dataSource: DataModel?
    @IBOutlet weak var overView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var popularitySlider: UISlider!
    @IBOutlet weak var votePopularity: UISlider!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAvgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = dataSource?.image
        self.title = dataSource?.original_title?.capitalized
        self.overView.text = dataSource?.overview
        self.overView.isEditable = false
        if let popularity = dataSource?.popularity, let vote = dataSource?.vote_average {
            self.popularitySlider.value = Float(popularity)
            self.votePopularity.value = Float(vote)
            self.popularityLabel.text = String(describing: popularity)
            self.voteAvgLabel.text = String(describing: vote)
        }
    }
}
