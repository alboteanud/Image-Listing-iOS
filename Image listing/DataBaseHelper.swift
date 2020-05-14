//
//  DataBaseHelper.swift
//  Image listing
//
//  Created by Dan Alboteanu on 14/05/2020.
//  Copyright © 2020 Dan Alboteanu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper {

      static let shareInstance = DataBaseHelper()
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data, download_url: String) {
          let imageInstance = Image(context: context)
          imageInstance.data = data
        imageInstance.download_url = download_url
          do {
              try context.save()
//                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//              print("Image is saved")
          } catch {
              print(error.localizedDescription)
          }
      }
      
    func fetchImage(download_url: String) -> [Image]? {
          var fetchingImage = [Image]()
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "download_url == %@", download_url)
          do {
              fetchingImage = try context.fetch(fetchRequest) as! [Image]
//                    (UIApplication.shared.delegate as! AppDelegate).saveContext().fetch(fetchRequest) as! [Image]
          } catch {
              print("Error while fetching the image")
              return nil
          }
          return fetchingImage
      }
}
