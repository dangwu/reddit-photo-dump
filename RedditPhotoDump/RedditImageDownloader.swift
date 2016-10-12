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
    func imageDownloaded(fileName: String)
}

class RedditImageDownloader {
    
    var subreddits = ["pics", "itookapicture", "earthporn", "ruralporn", "skyporn", "spaceporn", "cityporn", "architectureporn", "abandonedporn", "infrastructureporn", "cabinporn", "villageporn", "nature", "naturepics", "remoteplaces", "travel", "breathless", "amateurphotography", "wallpapers"]
    
    var randomSubreddit: String {
        let randomIndex = Int(arc4random_uniform(UInt32(subreddits.count)))
        return subreddits[randomIndex]
    }
    
    var delegate: RedditImageDownloaderDelegate?
    
    var running = false
    
    private var tasks: [NSURLSessionDataTask]?
    
    init(delegate: RedditImageDownloaderDelegate) {
        self.delegate = delegate
        tasks = [NSURLSessionDataTask]()
    }
    
    func cancel() {
        running = false
        for task in tasks ?? [] {
            task.cancel()
        }
        tasks?.removeAll()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func downloadImages(fromSubreddit subreddit: String? = nil) {
        running = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let subreddit = subreddit ?? randomSubreddit
        downloadUrl("https://www.reddit.com/r/\(subreddit)/.json")
    }
    
    private func downloadUrl(url: String, pageAfterToken: String? = nil) {
        guard running else {
            return
        }
        
        var redditUrl = url
        if let pageAfterToken = pageAfterToken {
            redditUrl = "\(url)?after=\(pageAfterToken)"
        }
        
        guard let requestURL = NSURL(string: redditUrl) else {
            return
        }
        
        NSLog("Downloading JSON at url \(redditUrl)")
        let request = NSMutableURLRequest(URL: requestURL)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            [weak self]
            data, response, error in
            do {
                guard let data = data else {
                    return
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    return
                }
                
                // Parse json for image urls
                let dataDict = json.objectForKey("data") as! NSDictionary
                let childrenArr = dataDict.objectForKey("children") as! [[String: AnyObject]]
                for postDict in childrenArr {
                    for (postKey, postValue) in postDict where postKey == "data" {
                        let postValueDict = postValue as! [String: AnyObject]
                        for (key, value) in postValueDict where key == "url" {
                            if let url = value as? String {
                                if url.lowercaseString.containsString(".jpg") || url.lowercaseString.containsString(".png") {
                                    self?.downloadImageAtURL(String(CACurrentMediaTime()), url: NSURL(string: url)!)
                                }
                            }
                        }
                    }
                }
                
                if let pageAfterToken = dataDict.objectForKey("after") as? String {
                    // Download next page of data
                    self?.downloadUrl(url, pageAfterToken: pageAfterToken)
                }
            } catch let error as NSError {
                NSLog("Error downloading json data from reddit: \(error.debugDescription)")
            }
        }
        task.resume()
        tasks?.append(task)
    }
    
    private func downloadImageAtURL(name: String, url: NSURL) {
        guard running else {
            return
        }
        
        NSLog("Downloading image at url \(url)")
        let request = NSMutableURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            [weak self]
            data, response, error in
            
            let fileName = "\(name).jpg"
            
            guard let data = data,
                image = UIImage(data: data),
                fileURL = ImageUtil.urlForImage(fileName),
                jpgImageData = UIImageJPEGRepresentation(image, 1) else {
                return
            }
            
            // Save image to disk
            jpgImageData.writeToURL(fileURL, atomically: false)
            
            // Add downloaded image to camera roll
            PHPhotoLibrary.addImageAtURL(fileURL)
            
            // Notify delegate of new image
            dispatch_async(dispatch_get_main_queue()) {
                self?.delegate?.imageDownloaded(fileName)
            }
        }
        task.resume()
        tasks?.append(task)
    }
    
}