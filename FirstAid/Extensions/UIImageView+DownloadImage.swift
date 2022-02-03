//
//  UIImageView+DownloadImage.swift
//  FirstAid
//
//  Created by Anna Shanidze on 03.02.2022.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { [weak self] url, response, error in
            if error == nil,
               let url = url,
               let localData = try? Data(contentsOf: url),
               let image = UIImage(data: localData) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
