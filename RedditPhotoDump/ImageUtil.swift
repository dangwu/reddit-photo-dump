//
//  UIImage+Resize.swift
//  PosthastePics
//
//  Created by Wu, Daniel on 10/12/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    
    static func urlForImage(name: String) -> NSURL? {
        guard let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsURL.URLByAppendingPathComponent(name)
        return fileURL
    }
    
    static func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}