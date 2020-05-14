//
//  Extentions.swift
//  Image listing
//
//  Created by Dan Alboteanu on 14/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

// used to create the thumbnails for the table cells
class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String, placeHolder: UIImage) {
        imageUrlString = urlString
        
        guard var url = URL(string: urlString) else { return }
//        print ("paths", url.pathComponents)
        
        // modify url to get thumbnail photo
        if url.pathComponents.count > 2 {
            let photoId = url.pathComponents[2]
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.path = "/id/\(photoId)/60/60.jpg"
//            print(components.url!)
            // expected result: "https://i.picsum.photos/id/1006/60/60.jpg"
            url = components.url!
        }
         
        image = placeHolder
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        // try DB
//        if let arr = DataBaseHelper.shareInstance.fetchImage(){
//            if arr.count > 0 {
//                let randomInt = Int.random(in: 0..<arr.count)
//                let dbImage = UIImage(data: arr[randomInt].photo!)
//                self.image = dbImage
//                //                print("we have the photo in DB")
//
//                // todo add img to cach
//                return
//            }
//        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                self.image = placeHolder
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    
                    // save to CoreData
                    if let imageData = imageToCache.jpegData(compressionQuality: 0.8) {
//                        DataBaseHelper.shareInstance.saveImage(data: imageData)
                    }
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
    
    
}
