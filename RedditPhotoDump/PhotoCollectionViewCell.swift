//
//  PhotoCollectionViewCell.swift
//  RedditPhotoDump
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
            if let imageFileName = imageFileName , imageFileName != oldValue {
                loadPhoto(imageFileName)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageFileName = nil
        photoImageView.image = nil
    }
    
    fileprivate func loadPhoto(_ fileName: String) {
        DispatchQueue.global().async {
            [weak self] _ in
            
            guard let fileURL = ImageUtil.urlForImage(fileName) else {
                return
            }
            
            guard let image = UIImage(contentsOfFile: fileURL.path) else {
                return
            }
            
            let thumbnailImage = ImageUtil.resize(image, targetSize: self?.imageSize ?? CGSize(width: 150, height: 150))
            
            DispatchQueue.main.async {
                [weak self] _ in
                
                if let imageFileName = self?.imageFileName , imageFileName == fileName {
                    self?.photoImageView.image = thumbnailImage
                }
            }
        }
    }
}
