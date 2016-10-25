//
//  PHPhotoLibrary+Helper.swift
//  RedditPhotoDump
//
//  Created by Wu, Daniel on 10/11/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation
import Photos

extension PHPhotoLibrary {
    
    /**
     Add image at the given local path to the user's shared photos library.
     Checks for permission first, and asks for permission if necessary.
     
     -Parameters:
     -url: url to media file
     -video: is the asset a video?
     */
    static func addImageAtURL(_ url: URL) {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            // Need permission first
            PHPhotoLibrary.requestAuthorization({
                status in
                if status == PHAuthorizationStatus.authorized {
                    performMediaAssetCreationRequest(url)
                } else {
                    NSLog("PHPhotoLibrary - Failed to get authorization to add media to photo library")
                }
            })
        } else {
            // Already have permission
            performMediaAssetCreationRequest(url)
        }
    }
    
    /**
     Perform PHPhotoLibrary changes to add photo or video files to the shared photo library.
     The files are deleted after being successfully added.
     
     -Parameters:
     -url: url to media file
     -video: is the asset a video?
     */
    fileprivate static func performMediaAssetCreationRequest(_ url: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            }, completionHandler: {
                success, error in
                if !success {
                    NSLog("PHPhotoLibrary - Error adding image to user's camera roll. \(error!)")
                }
        })
    }
    
}
