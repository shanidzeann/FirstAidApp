//
//  ArticleViewController.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ArticleViewModel?
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        descriptionLabel.sizeToFit()
    }
    
    func getData() {
        articleTitleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.desctiption
        if let imageURL = viewModel?.imageURL, let url = URL(string: imageURL) {
            downloadTask = articleImageView.loadImage(url: url, completion: {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            })
        } else {
            activityIndicator.stopAnimating()
        }
        
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        guard let urlString = viewModel?.url else { return }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    deinit {
        //print("deinit \(self)")
        downloadTask?.cancel()
    }
    
}
