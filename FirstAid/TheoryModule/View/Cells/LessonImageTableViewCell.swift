//
//  LessonImageTableViewCell.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.10.2021.
//

import UIKit

class LessonImageTableViewCell: UITableViewCell {
    
    weak var viewModel: LessonTVCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            lessonImageView.image = UIImage(named: viewModel.imageName)
        }
    }
    
    public var lessonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.clipsToBounds = true
        contentView.addSubview(lessonImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lessonImageView.translatesAutoresizingMaskIntoConstraints = false
        lessonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lessonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        lessonImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        lessonImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
}

