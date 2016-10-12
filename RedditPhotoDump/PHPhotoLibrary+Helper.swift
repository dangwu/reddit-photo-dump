//
//  PHPhotoLibrary+Helper.swift
//  PosthastePics
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
    static func addImageAtURL(url: NSURL) {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            // Need permission first
            PHPhotoLibrary.requestAuthorization({
                status in
                if status == PHAuthorizationStatus.Authorized {
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
    private static func performMediaAssetCreationRequest(url: NSURL) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImageAtFileURL(url)
            }, completionHandler: {
                success, error in
                if success {
                    NSLog("PHPhotoLibrary - Added image to user's camera roll.")
                } else {
                    NSLog("PHPhotoLibrary - Error adding image to user's camera roll. \(error!)")
                }
        })
    }
    
}
