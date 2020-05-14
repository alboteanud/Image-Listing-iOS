//
//  DetailViewController.swift
//  Image listing
//
//  Created by Dan Alboteanu on 13/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var thumbImage: UIImage?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let details = imageDetails {
            if let label = detailDescriptionLabel {
                label.text = details.author
            }
            if let imageView_ = imageView {
                loadFullImageUsingUrlString(fullImageDownloadUrlString: details.download_url, imageView: imageView_)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    var imageDetails: ImageDetails? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func loadFullImageUsingUrlString(fullImageDownloadUrlString: String?, imageView: UIImageView) {
        
        guard let download_url = fullImageDownloadUrlString else {
            // show placeholder
            return
        }
        
        // try DB
        if let results = DataBaseHelper.shareInstance.fetchImage(download_url: download_url){
            if results.count > 0 {
                imageView.image = UIImage(data: results[0].data!)
                return
            }
        }
        
        // show thumbnail until network image arrives
        // check if DB thumb arrives after network
        loadThumbnailFromDB(fullImageDownloadUrlString: download_url, imageView: imageView)
        
        guard let url = URL(string: download_url) else {
            // show placeholder
            return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let imageFromNetwork = UIImage(data: data!) else {
                    return }
                
                imageView.image = imageFromNetwork
                
                // save to CoreData
                if let imageData = imageFromNetwork.jpegData(compressionQuality: 0.8) {
                    DataBaseHelper.shareInstance.saveImage(data: imageData, download_url: download_url)
                }
                
            }
            
        }).resume()
    }
    
    func loadThumbnailFromDB(fullImageDownloadUrlString: String, imageView: UIImageView) {
        
        guard let thumbDownloadUrl = APIService.shareInstance.getThumbDownloadUrl(download_url: fullImageDownloadUrlString) else {
            // show placeholde
            return }
        let imageUrlString = thumbDownloadUrl.absoluteString
        
        // try DB
        if let results = DataBaseHelper.shareInstance.fetchImage(download_url: imageUrlString){
            if results.count > 0 {
                let dbImage = UIImage(data: results[0].data!)
                if imageView.image == nil {
                    imageView.image = dbImage
                }
            } else {
                // show placeholder
            }
        }
    }
    
    
}

