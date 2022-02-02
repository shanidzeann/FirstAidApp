//
//  SituationTableViewCell.swift
//  FirstAid
//
//  Created by Anna Shanidze on 11.01.2022.
//

import UIKit

class SituationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var isFinished: Bool?
    var isSuccess: Bool?
    
    weak var SituationViewModel: SituationsTVCellViewModel? {
        willSet(viewModel) {
            label.text = viewModel?.title
            isFinished = viewModel?.isFinished
            isSuccess = viewModel?.isSuccess
            setAccessoryView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setAccessoryView() {
        let successImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        successImageView.image = UIImage(systemName: "face.smiling.fill")
        successImageView.tintColor = UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5)
        
        let failImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        failImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
        failImageView.tintColor = .systemRed
        
        guard let success = isSuccess, let done = isFinished else { return }
        if done && success {
            accessoryView = successImageView
        } else if done && !success {
            accessoryView = failImageView
        } else {
            accessoryView = .none
        }
    }
    
    
}

