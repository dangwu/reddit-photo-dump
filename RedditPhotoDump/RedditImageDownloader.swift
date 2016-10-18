//
//  RedditImageDownloader.swift
//  PosthastePics
//
//  Created by Wu, Daniel on 10/12/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation
import Photos
import UIKit

protocol RedditImageDownloaderDelegate {
    func imageDownloaded(_ fileName: String)
}

class RedditImageDownloader {
    
    let imageExtensions = [".jpg", ".jpeg", ".png"]
    
    var subreddits = ["pics", "itookapicture", "earthporn", "ruralporn", "skyporn", "spaceporn", "cityporn", "architectureporn", "abandonedporn", "infrastructureporn", "cabinporn", "villageporn", "nature", "naturepics", "remoteplaces", "travel", "breathless", "amateurphotography", "wallpapers"]
    
    var randomSubreddit: String {
        let randomIndex = Int(arc4random_uniform(UInt32(subreddits.count)))
        return subreddits[randomIndex]
    }
    
    var delegate: RedditImageDownloaderDelegate?
    
    var running = false
    
    fileprivate var tasks: [URLSessionDataTask]?
    
    init(delegate: RedditImageDownloaderDelegate) {
        self.delegate = delegate
        tasks = [URLSessionDataTask]()
    }
    
    func cancel() {
        running = false
        for task in tasks ?? [] {
            task.cancel()
        }
        tasks?.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func downloadImages(fromSubreddit subreddit: String? = nil) {
        running = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let subreddit = subreddit ?? randomSubreddit
        downloadUrl("https://www.reddit.com/r/\(subreddit)/.json")
    }
    
    fileprivate func downloadUrl(_ url: String, pageAfterToken: String? = nil) {
        guard running else {
            return
        }
        
        var redditUrl = url
        if let pageAfterToken = pageAfterToken {
            redditUrl = "\(url)?after=\(pageAfterToken)"
        }
        
        guard let requestURL = URL(string: redditUrl) else {
            return
        }
        
        NSLog("Downloading JSON at url \(redditUrl)")
        let request = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            [weak self]
            data, response, error in
            do {
                guard let data = data else {
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                
                // Parse json for image urls
                let dataDict = json.object(forKey: "data") as! NSDictionary
                let childrenArr = dataDict.object(forKey: "children") as! [[String: AnyObject]]
                for postDict in childrenArr {
                    for (postKey, postValue) in postDict where postKey == "data" {
                        let postValueDict = postValue as! [String: AnyObject]
                        for (key, value) in postValueDict where key == "url" {
                            if let url = value as? String {
                                if url.lowercased().contains(".jpg") || url.lowercased().contains(".png") {
                                    self?.downloadImageAtURL(String(CACurrentMediaTime()), url: URL(string: url)!)
                                }
                            }
                        }
                    }
                }
                
                if let pageAfterToken = dataDict.object(forKey: "after") as? String {
                    // Download next page of data
                    self?.downloadUrl(url, pageAfterToken: pageAfterToken)
                }
            } catch let error as NSError {
                NSLog("Error downloading json data from reddit: \(error.debugDescription)")
            }
        }) 
        task.resume()
        tasks?.append(task)
    }
    
    fileprivate func downloadImageAtURL(_ name: String, url: URL) {
        guard running else {
            return
        }
        
        NSLog("Downloading image at url \(url)")
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            [weak self]
            data, response, error in
            
            let fileName = "\(name).jpg"
            
            guard let data = data,
                let image = UIImage(data: data),
                let fileURL = ImageUtil.urlForImage(fileName),
                let jpgImageData = UIImageJPEGRepresentation(image, 1) else {
                return
            }
            
            // Save image to disk
            try? jpgImageData.write(to: fileURL, options: [])
            
            // Add downloaded image to camera roll
            PHPhotoLibrary.addImageAtURL(fileURL)
            
            // Notify delegate of new image
            DispatchQueue.main.async {
                self?.delegate?.imageDownloaded(fileName)
            }
        }) 
        task.resume()
        tasks?.append(task)
    }
    
}
