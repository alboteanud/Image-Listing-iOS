//
//  APIService.swift
//  Image listing
//
//  Created by Dan Alboteanu on 13/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    static let shareInstance = APIService()
    
    func getEndpointUrl(pageNumber: Int) -> String {
        return "https://picsum.photos/v2/list?page=\(String(pageNumber))&limit=10"
    }

    func getDataWith(pageNumber: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let urlString = getEndpointUrl(pageNumber: pageNumber)
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
         guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    func getThumbDownloadUrl(download_url: String) -> URL? {
        guard let url = URL(string: download_url) else { return nil}
        //        print ("paths", url.pathComponents)
        
        if url.pathComponents.count > 2 {
            let photoId = url.pathComponents[2]
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.path = "/id/\(photoId)/50/50.jpg"
            //            print(components.url!)
            // expected result: "https://i.picsum.photos/id/1006/50/50.jpg"
            return components.url!
        }
        return nil
    }
    
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





