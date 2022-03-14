//
//  TableViewCell.swift
//  FirstAid
//
//  Created by Anna Shanidze on 08.01.2022.
//

import UIKit
import SnapKit

class TheoryTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    var done = false
    
    weak var viewModel: TheoryTVCellViewModel? {
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
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackground() {
        backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
    }
    
    private func createUI() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    
}
