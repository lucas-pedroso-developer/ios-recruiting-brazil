//
//  ViewModelHelper.swift
//  ViewModel
//
//  Created by Lucas Daniel on 06/02/21.
//  Copyright © 2021 Lucas. All rights reserved.
//

import Foundation
import UIKit

public final class ViewModelHelper {
    static func decode<T>(modelType: T.Type, data: Data) -> T? where T : Decodable {
        do {
            return try JSONDecoder().decode(modelType, from: data)
        } catch (_) {
            return nil
        }
    }
    
    public static func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = folderURL.appendingPathComponent((url.absoluteString as NSString).lastPathComponent)
            if FileManager.default.fileExists(atPath: filePath.path) {
                if let image = UIImage(contentsOfFile: filePath.path) {
                    completion(image)
                }
                return
            } else {
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig)
                let request = URLRequest(url: url)
                let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                    if let tempLocalUrl = tempLocalUrl, error == nil {
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: filePath)
                            let destination = folderURL.appendingPathComponent((url.absoluteString as NSString).lastPathComponent)
                            if let image = UIImage(contentsOfFile: destination.path) {
                                completion(image)
                            }
                        } catch (let writeError) {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                }
                task.resume()
            }
        }        
}
