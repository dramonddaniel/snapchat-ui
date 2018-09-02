//
//  Service.swift
//  Snapchat
//
//  Created by Danny Dramond on 26/01/2018.
//  Copyright © 2018 Danny Dramond. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Alamofire

typealias JSON = [String: Any]

struct Service {
    
    static let sharedInstance = Service()
    
    // MARK: NODEJS SERVER.
    
    func handleFetchPosts(_ completion: @escaping ([Snap]?) -> Void) {
        Alamofire.request("https://snapchat-nodejs.herokuapp.com/posts", method: .get)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else { return completion(nil) }
                guard let rawInventory = response.result.value as? [[String: Any]?] else { return completion(nil) }
                
                let snaps = rawInventory.compactMap { data -> Snap? in
                    
                    guard let dictionary = data else { return nil }
                    let username = dictionary["username"] as? String
                    let timestamp = dictionary["timestamp"] as? NSNumber
                    let type = dictionary["type"] as? String
                    let bitmoji = dictionary["bitmoji"] as? String
                    let is_read = dictionary["is_read"] as? Bool
                    let content = dictionary["content"] as? String
                    
                    return Snap(username: username, timestamp: timestamp, type: type, bitmoji: bitmoji, isRead: is_read, content: content)
                }
                
            completion(snaps)
        }
    }
    
    func handleFetchStories(_ completion: @escaping ([Story]?) -> Void) {
        Alamofire.request("https://snapchat-nodejs.herokuapp.com/stories", method: .get)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else { return completion(nil) }
                guard let rawInventory = response.result.value as? [[String: Any]?] else { return completion(nil) }
                
                let stories = rawInventory.compactMap { data -> Story? in
                    
                    guard let dictionary = data else { return nil }
                    let username = dictionary["username"] as? String
                    let type = dictionary["type"] as? String
                    let image_name = dictionary["image_name"] as? String
                    let image_url = dictionary["image_url"] as? String
                    
                    return Story(username: username, type: type, bitmoji_image_name: image_name, image_url: image_url)
                }
                
            completion(stories)
        }
    }
    
    // MARK: NEWS API.
    
    func handleMTVNewsAPI(_ completion: @escaping ([Featured]) -> ()) {
        var newsData: [Featured] = []
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=mtv-news&apiKey=4ee702474ee449eb8a06e9d67e3434ab") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil { print("NEWS API ERROR"); return }
                do {
                    guard let json =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                        let jsonArray = json["articles"] as? [[String: Any]] else { return }
                    
                    for i in 0 ..< jsonArray.count {
                        
                        let author = jsonArray[i]["author"] as? String
                        let title = jsonArray[i]["title"] as? String
                        let description = jsonArray[i]["description"] as? String
                        let article_url = jsonArray[i]["url"] as? String
                        let urlToImage = jsonArray[i]["urlToImage"] as? String
                        let published = jsonArray[i]["publishedAt"] as? String
                        
                        let featured = Featured(author: author!, title: title!, desc: description!, url: article_url!, urlToImage: urlToImage!, published: published!)
                        
                        newsData.append(featured)
                        
                        DispatchQueue.main.async {
                            completion(newsData)
                        }
                    }
                    
                } catch {
                    print(err ?? "MTV NEWS API ERROR")
                }
            }.resume()
        }
    }
    
    func handleBBCNewsAPI(_ completion: @escaping ([Featured]) -> ()) {
        var newsData: [Featured] = []
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=b883dfe390a649c5b7f12073b17b30b0") {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil { print("NEWS API ERROR"); return }
                do {
                    guard let json =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                        let jsonArray = json["articles"] as? [[String: Any]] else { return }
                    
                    for i in 0 ..< jsonArray.count {
                        
                        let author = jsonArray[i]["author"] as? String
                        let title = jsonArray[i]["title"] as? String
                        let description = jsonArray[i]["description"] as? String
                        let article_url = jsonArray[i]["url"] as? String
                        let urlToImage = jsonArray[i]["urlToImage"] as? String
                        let published = jsonArray[i]["publishedAt"] as? String
                        
                        let featured = Featured(author: author!, title: title!, desc: description!, url: article_url!, urlToImage: urlToImage!, published: published!)
                        
                        newsData.append(featured)
                        
                        DispatchQueue.main.async {
                            completion(newsData)
                        }
                    }
                    
                } catch {
                    print(err ?? "BBC NEWS API ERROR")
                }
            }.resume()
        }
    }
    
    // MARK: FIREBASE.
    
    func handleCreateVideo(_ url: URL, _ longitude: Double, _ latitude: Double, _ view: VideoViewController) {
        let fileName = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("videos").child(fileName).putFile(from: url, metadata: nil) { (metadata, error) in
            if error != nil { return }
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                if let previewImage = self.createPreviewImageForVideoUrl(url) {
                    self.handleUploadThumbnailImage(previewImage, completion: { (image_url) in
                        self.handleUploadVideoData(videoUrl, previewImage, image_url, longitude, latitude)
                    })
                }
            }
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            if let bytes = snapshot.progress?.completedUnitCount {
                let progress = ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
                print(progress)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("Upload successful")
            view.cancel()
        }
    }
    
    func handleUploadThumbnailImage(_ image: UIImage, completion: @escaping (_ image_url: String) -> ()) {
        let imageName = NSUUID().uuidString + ".jpeg"
        let reference = Storage.storage().reference().child("video_preview_image").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.80) {
            reference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil { return }
                if let image_url = metadata?.downloadURL()?.absoluteString {
                    completion(image_url)
                }
            })
        }
    }
    
    func handleUploadVideoData(_ video_url: String, _ previewImage: UIImage, _ preview_image_url: String, _ longitude: Double, _ latitude: Double) {
        let reference = Database.database().reference().child("videos")
        let childRef = reference.childByAutoId()
        
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        let values: [String: Any] = ["timestamp": timestamp,
                                     "longitude": longitude,
                                     "latitude": latitude,
                                     "thumbnail_url": preview_image_url,
                                     "video_url": video_url]
        
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil { return }
        })
    }
    
    func createPreviewImageForVideoUrl(_ videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let previewCGImage = try assetImageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            let image = UIImage(cgImage: previewCGImage, scale: 1.0, orientation: .up)
            return image
        } catch let err { print(err) }
        
        return nil
    }
}
