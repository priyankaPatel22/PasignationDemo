//
//  ArticalTableVC.swift
//  Doc99
//
//  Created by Pritesh Pethani on 12/04/17.
//  Copyright © 2017 Pritesh Pethani. All rights reserved.
//

import UIKit

class ArticalTableVC: UITableViewCell {

    @IBOutlet var lblArticalName:UILabel!
    @IBOutlet var imageViewArtical:UIImageView!
    @IBOutlet var activityIndicatorForArticalImage:UIActivityIndicatorView!
    @IBOutlet var imageViewBookmarked:UIImageView!
    @IBOutlet var imageViewShared:UIImageView!
    @IBOutlet var btnBookMark:UIButton!
    @IBOutlet var btnShare:UIButton!
    @IBOutlet var lblCategory:UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblCategory.sizeToFit()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
