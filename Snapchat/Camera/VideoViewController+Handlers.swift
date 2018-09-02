//
//  VideoViewController+Handlers.swift
//  Snapchat
//
//  Created by Danny Dramond on 28/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit
import AVFoundation

extension VideoViewController {
    
    func compressVideo(_ inputURL: URL, _ outputURL: URL, _ completion: @escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        
        let low_quality = AVAssetExportPresetLowQuality
        let medium_quality = AVAssetExportPresetMediumQuality
        let highest_quality = AVAssetExportPresetHighestQuality
        
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: highest_quality) else {
            completion(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            completion(exportSession)
        }
    }
    
    @objc func handleVideoUpload() {
        let outputUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
        self.compressVideo(videoURL, outputUrl) { (exportSession) in
            guard let session = exportSession,
            let latitude = self.currentUserCoordinate?.coordinate.latitude,
            let longitude = self.currentUserCoordinate?.coordinate.longitude else { return }

            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                Service.sharedInstance.handleCreateVideo(outputUrl, longitude, latitude, self)
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
}
