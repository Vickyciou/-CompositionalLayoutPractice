//
//  LabelCollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by Vicky on 2025/1/9.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    static let identifier = "LabelCollectionViewCell"
        
        private let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            label.lineBreakMode = .byTruncatingTail // 超過內容時截斷
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with text: String) {
            label.text = text.count > 10 ? String(text.prefix(10)) + "..." : text
        }
}
