//
//  ImageStore.swift
//  LootLogger
//
//  Created by R.AMOGH on 21/05/24.
//

import UIKit

class ImageStore{
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image:UIImage, forKey key:String){
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for Image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5){
            // write it to full URL
            try? data.write(to: url)
        }
    }
    
    func image(forKey key: String)->UIImage?{
        if let existingImage = cache.object(forKey: key as NSString){
            return existingImage
        }
        let url = imageURL(forKey: key)
        
        guard let imageFromDisc = UIImage(contentsOfFile: url.path) else{
            return nil
        }
        
        cache.setObject(imageFromDisc, forKey: key as NSString)
        return imageFromDisc
    }
    
    func deleteImage(forKey key: NSString){
        cache.removeObject(forKey: key as NSString)
        // Does nothing if the key is not found
        
        let url = imageURL(forKey: key as String)
        do{
            try FileManager.default.removeItem(at: url)
        }catch{
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String)->URL{
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
}
