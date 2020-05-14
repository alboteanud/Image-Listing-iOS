//
//  TableViewCell.swift
//  Image listing
//
//  Created by Dan Alboteanu on 14/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: CustomImageView!
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTableCellWith(imageDetails: ImageDetails){
        labelText.text = imageDetails.author
        
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let download_url = imageDetails.download_url {
            myImageView.loadImageUsingUrlString(fullImageDownloadUrlString: download_url, placeHolder: placeholderImage)
        } else {
            myImageView.image = placeholderImage
        }
        
    }

}
