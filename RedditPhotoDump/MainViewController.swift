//
//  MainViewController.swift
//  PosthastePics
//
//  Created by Wu, Daniel on 10/10/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource {
    
    private var redditImageDownloader: RedditImageDownloader?
    private var downloadedFileNames = [String]()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func startButtonPressed(sender: AnyObject) {
        if redditImageDownloader?.tasks?.count ?? 0 > 0 {
            // Stop
            startButton.setTitle("Start", forState: .Normal)
            startButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            redditImageDownloader?.cancel()
        } else {
            // Start
            startButton.setTitle("Stop", forState: .Normal)
            startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            redditImageDownloader?.downloadImagesFromSubreddit("pics")
            downloadedFileNames.removeAll()
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        redditImageDownloader = RedditImageDownloader(delegate: self)
        
        collectionView.dataSource = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return downloadedFileNames.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(PhotoCollectionViewCell), forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let imageFileName = downloadedFileNames[indexPath.row]
        cell.imageFileName = imageFileName
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {            
            if let fileURL = ImageUtil.urlForImage(imageFileName),
                let imageFilePath = fileURL.path {
                if let image = UIImage(contentsOfFile: imageFilePath) {
                    let thumbnailImage = ImageUtil.resize(image, targetSize: CGSizeMake(100, 100))

                    dispatch_async(dispatch_get_main_queue()) {
                        if cell.imageFileName != nil && cell.imageFileName == imageFileName {
                            cell.photoImageView.image = thumbnailImage
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension MainViewController: RedditImageDownloaderDelegate {
    
    func imageDownloaded(fileName: String) {
        downloadedFileNames.append(fileName)
        collectionView.reloadData()
    }
    
}

