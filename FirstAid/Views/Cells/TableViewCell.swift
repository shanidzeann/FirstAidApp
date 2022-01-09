//
//  TableViewCell.swift
//  FirstAid
//
//  Created by Anna Shanidze on 08.01.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    var done = false
    
    weak var viewModel: TheoryTVCellViewModelType? {
        willSet(viewModel) {
            label.text = viewModel?.title
            done = ((viewModel?.done) != nil)
            setBackground()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
      //  contentView.clipsToBounds = true
        contentView.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setBackground() {
        
        //        if let done = viewModel.filteredLessons?[indexPath.row].isFinished {
        //            cell.backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
        //        }
        
        backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
    }
    

}
