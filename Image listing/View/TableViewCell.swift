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
        
        //        self.layoutMargins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        //        self.separatorInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setTableCellWith(imageDetails: ImageDetails){
        labelText.text = imageDetails.author
        let placeholderImage = UIImage(named: "placeholder")!
        
        configureImageView()
        DispatchQueue.main.async {
            if let download_url = imageDetails.download_url {
                self.myImageView.loadImageUsingUrlString(fullImageDownloadUrlString: download_url, placeHolder: placeholderImage)
            } else {
                self.myImageView.image = placeholderImage
            }
        }
        
    }
    
    func configureImageView(){
        myImageView.contentMode = .scaleAspectFill
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        myImageView.layer.masksToBounds = true
    }
    
}
