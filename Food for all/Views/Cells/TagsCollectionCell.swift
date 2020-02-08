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
        imageView.layer.cornerRadius = 15
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        imageView.layer.borderWidth = 5
        
        return imageView
    }()
    
    private var tagTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
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
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(115)
        })
        
        self.addSubview(tagTitleLabel)
        tagTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagImageView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCell(withTag: Tags, isSelected: Bool) {
        self.tagImageView.setup(withImageUrlPath: withTag.photoURL ?? "", cornerRadius: 15)
        self.tagTitleLabel.text = withTag.tagName ?? ""
        if isSelected {
            cellSelectionConfiguration()
        } else {
            cellDeSelectionConfiguration()
        }
        
    }
    
    
    func cellSelectionConfiguration() {
        UIView.animate(withDuration: 0.5) {
            self.tagImageView.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.tagTitleLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            self.tagTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        }
    }
    
    
    func cellDeSelectionConfiguration() {
        UIView.animate(withDuration: 0.2) {
            self.tagImageView.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0)
            self.tagTitleLabel.textColor = .black
            self.tagTitleLabel.font = UIFont(name:"HelveticaNeue", size: 15.0)
        }
    }
    
}
