//
//  TagsCellCollectionViewCell.swift
//  El Menus Task
//
//  Created by Michael Maher on 2/4/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import UIKit
import SnapKit

class TagsCollectionCell: UICollectionViewCell {
    
    static let identifier = "TagsCollectionCell"

    private var tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        imageView.layer.borderWidth = 3
        
        return imageView
    }()
    
    private var tagTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagsCollectionCell {
    func setupCellLayout() {

        self.addSubview(tagImageView)
        tagImageView.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(tagImageView.snp.width).multipliedBy(2 / 3)
        })
        
        self.addSubview(tagTitleLabel)
        tagTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configureCell(withTag: Tags) {
        self.tagImageView.setup(withImageUrlPath: withTag.photoURL ?? "")
        self.tagTitleLabel.text = withTag.tagName ?? ""
    }
    
    
}
