//
//  ImageUtil.swift
//  RedditPhotoDump
//
//  Created by Wu, Daniel on 10/12/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    
    static func urlForImage(_ name: String) -> URL? {
        guard let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = cachesDirectoryURL.appendingPathComponent(name)
        return fileURL
    }
    
    static func resize(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
