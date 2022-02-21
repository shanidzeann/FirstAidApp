//
//  ArticleViewController.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    
    // MARK: - UI
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = .boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.tintColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = .systemFont(ofSize: 17)
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let safariButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.title = "Перейти к статье"
        button.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties

    var viewModel: ArticleViewModel?
    var downloadTask: URLSessionDownloadTask?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        getData()
    }
    
    // MARK: - Hepler Methods
    
    func getData() {
        articleTitleLabel.text = viewModel?.title
        descriptionTextView.text = viewModel?.desctiption
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
    
    func createUI() {
        view.addSubview(articleTitleLabel)
        view.addSubview(articleImageView)
        view.addSubview(descriptionTextView)
        view.addSubview(activityIndicator)
        view.addSubview(safariButton)
        
        articleTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            make.left.right.equalToSuperview().inset(20.0)
        }
        
        articleImageView.snp.makeConstraints { make in
            make.top.equalTo(articleTitleLabel.snp.bottom).offset(10.0)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(view.snp.height).dividedBy(4)
            
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20.0)
        }
        
        safariButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(10.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(articleImageView)
        }
    }
    
    @objc func openInSafari() {
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
