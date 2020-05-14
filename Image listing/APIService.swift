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
    
    var pageNumber = 1
    lazy var endPoint: String = {
        return "https://picsum.photos/v2/list?page=\(self.pageNumber)&limit=1"
    }()

    func getDataWith(pageNumber: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        self.pageNumber = pageNumber
        let urlString = endPoint
        
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
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





