//
//  TableViewCell.swift
//  FirstAid
//
//  Created by Anna Shanidze on 08.01.2022.
//

import UIKit

class TheoryTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    var done = false
    
    weak var viewModel: TheoryTVCellViewModelType? {
        willSet(viewModel) {
            label.text = viewModel?.title
            done = viewModel?.done ?? false
            setBackground()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        label.numberOfLines = 0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: contentView.frame.height).isActive = true
    }
    
    func setBackground() {
        backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
    }
    
    
}
