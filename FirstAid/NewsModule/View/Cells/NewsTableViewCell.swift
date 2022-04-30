//
//  NewsTableViewCell.swift
//  FirstAid
//
//  Created by Anna Shanidze on 03.02.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    weak var viewModel: NewsTVCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.desctiption
            if let imageURL = viewModel.imageURL, let url = URL(string: imageURL) {
                downloadTask = newsImageView.loadImage(url: url, completion: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureNewsImageView()
    }
    
    private func configureNewsImageView() {
        newsImageView.layer.cornerRadius = newsImageView.bounds.height / 10
        newsImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

}

