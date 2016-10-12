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
        if redditImageDownloader?.running ?? false {
            // Stop
            startButton.setTitle("Start", forState: .Normal)
            startButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            redditImageDownloader?.cancel()
        } else {
            // Start
            startButton.setTitle("Stop", forState: .Normal)
            startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            redditImageDownloader?.downloadImages()
            downloadedFileNames.removeAll()
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        redditImageDownloader = RedditImageDownloader(delegate: self)
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = GridCollectionViewFlowLayout()
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
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if let imageSize = flowLayout?.itemSize {
            cell.imageSize = imageSize
        }
        cell.imageFileName = downloadedFileNames[indexPath.row]
        
        return cell
    }
}

extension MainViewController: RedditImageDownloaderDelegate {
    
    func imageDownloaded(fileName: String) {
        downloadedFileNames.append(fileName)
        
        let newIndexPath = NSIndexPath(forRow: collectionView.numberOfItemsInSection(0), inSection: 0)
        collectionView.insertItemsAtIndexPaths([newIndexPath])
    }
    
}

