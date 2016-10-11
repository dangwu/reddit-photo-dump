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
    
    var imageFileName: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageFileName = nil
        photoImageView.image = nil
    }
}