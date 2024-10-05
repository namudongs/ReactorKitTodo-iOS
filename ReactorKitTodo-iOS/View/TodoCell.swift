//
//  TodoCell.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import SnapKit

class TodoCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
