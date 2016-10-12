//
//  PhotoCollectionViewCell.swift
//  PosthastePics
//
//  Created by Wu, Daniel on 10/11/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var imageSize: CGSize?
    
    var imageFileName: String? {
        didSet {
            if let imageFileName = imageFileName where imageFileName != oldValue {
                loadPhoto(imageFileName)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageFileName = nil
        photoImageView.image = nil
    }
    
    private func loadPhoto(fileName: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] _ in
            
            guard let fileURL = ImageUtil.urlForImage(fileName),
                let imageFilePath = fileURL.path,
                let image = UIImage(contentsOfFile: imageFilePath) else {
                return
            }
            
            let thumbnailImage = ImageUtil.resize(image, targetSize: self?.imageSize ?? CGSizeMake(150, 150))
            
            dispatch_async(dispatch_get_main_queue()) {
                [weak self] _ in
                
                if let imageFileName = self?.imageFileName where imageFileName == fileName {
                    self?.photoImageView.image = thumbnailImage
                }
            }
        }
    }
}