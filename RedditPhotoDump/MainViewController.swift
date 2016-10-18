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
    
    fileprivate var redditImageDownloader: RedditImageDownloader?
    fileprivate var downloadedFileNames = [String]()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func startButtonPressed(_ sender: AnyObject) {
        if redditImageDownloader?.running ?? false {
            // Stop
            startButton.setTitle("Start", for: UIControlState())
            startButton.setTitleColor(UIColor.blue, for: UIControlState())
            redditImageDownloader?.cancel()
            downloadedFileNames.removeAll()
            collectionView.reloadData()
        } else {
            // Start
            startButton.setTitle("Stop", for: UIControlState())
            startButton.setTitleColor(UIColor.red, for: UIControlState())
            downloadedFileNames.removeAll()
            collectionView.reloadData()
            redditImageDownloader?.downloadImages()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return downloadedFileNames.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if let imageSize = flowLayout?.itemSize {
            cell.imageSize = imageSize
        }
        cell.imageFileName = downloadedFileNames[(indexPath as NSIndexPath).row]
        
        return cell
    }
}

extension MainViewController: RedditImageDownloaderDelegate {
    
    func imageDownloaded(_ fileName: String) {
        downloadedFileNames.append(fileName)
        
        let newIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0)
        collectionView.insertItems(at: [newIndexPath])
    }
    
}

