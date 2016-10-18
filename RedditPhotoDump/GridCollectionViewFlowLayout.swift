//
//  GridCollectionViewFlowLayout.swift
//  RedditPhotoDump
//
//  Created by Wu, Daniel on 10/12/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import UIKit

class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// Number of items that should be displayed in a single row. itemSize will be calculated using this value. Layout should be invalidated after changing this value.
    var itemsPerRow = 3
    
    override func prepare() {
        sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        let collectionViewWidth = collectionView!.bounds.size.width
        let collectionViewWidthAvailable = collectionViewWidth - sectionInset.left - sectionInset.right - (CGFloat(itemsPerRow) - 1) * minimumInteritemSpacing
        let itemWidth = floor(collectionViewWidthAvailable / CGFloat(itemsPerRow))
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
}
