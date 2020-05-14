//
//  Extentions.swift
//  Image listing
//
//  Created by Dan Alboteanu on 14/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

// this class is used to create the thumbnails for the table cells
class CustomImageView: UIImageView {
    
       var thumbUrlString: String?
        
        func loadImageUsingUrlString(fullImageDownloadUrlString: String, placeHolder: UIImage) {
            
            guard let thumbDownloadUrl = APIService.shareInstance.getThumbDownloadUrl(download_url: fullImageDownloadUrlString) else {
                image = placeHolder
                return}
            thumbUrlString = thumbDownloadUrl.absoluteString
            
            if let imageFromCache = imageCache.object(forKey: thumbUrlString! as NSString) {
                image = imageFromCache    // .addFilter(filter: FilterType.Noir)
                return
            } else {
                image = placeHolder
            }
            
            // try DB
            if let results = DataBaseHelper.shareInstance.fetchImage(download_url: thumbUrlString!){
                if results.count > 0 {
                    let dbImage = UIImage(data: results[0].data!)
                    image = dbImage
                    imageCache.setObject(dbImage!, forKey: thumbUrlString! as NSString)
                    return
                }
            }
            
            URLSession.shared.dataTask(with: thumbDownloadUrl, completionHandler: { (data, respones, error) in
                
                if error != nil {
                    print(error ?? "")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    guard let imageFromNetwork = UIImage(data: data!) else { return }
                    
                    if self.thumbUrlString == thumbDownloadUrl.absoluteString {
                        // apply a filter only on newly arrived images
                        self.image = imageFromNetwork.addFilter(filter: FilterType.Mono)
                        
                        imageCache.setObject(imageFromNetwork, forKey: self.thumbUrlString! as NSString)
                        
                        // save to CoreData
                        if let imageData = imageFromNetwork.jpegData(compressionQuality: 0.8) {
                            DataBaseHelper.shareInstance.saveImage(data: imageData, download_url: thumbDownloadUrl.absoluteString)
                        }
                    }
                }
                
            }).resume()
        }
    }

enum FilterType : String {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        return UIImage(cgImage: cgImage!)
    }
}
