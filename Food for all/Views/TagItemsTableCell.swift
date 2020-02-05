//
//  TagItemsTableCell.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import UIKit
import SnapKit

class TagItemsTableCell: UITableViewCell {
    
    static let identifier = "TagItemsTableCell"
    
    private var tagItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.dropShadow()
        return imageView
    }()
    
    private var arrowImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    
    private var tagItemTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black]
//        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)        
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
//        configureFontsAndUI()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension TagItemsTableCell {
    func setupCellLayout() {
        self.dropShadow()
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        
        self.addSubview(tagItemImageView)
        tagItemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(110)
            make.height.equalTo(tagItemImageView.snp.width).multipliedBy(3 / 2)
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.trailing.equalToSuperview().offset(5)
            make.centerY.equalTo(tagItemImageView.snp.centerY)
        }
        
        self.addSubview(tagItemTitleLabel)
        tagItemTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(tagItemImageView.snp.trailing).offset(10)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-5)
            make.centerY.equalTo(tagItemImageView.snp.centerY)
        }
    }
    
    func configureCell(withtagItem: Items) {
        self.tagItemImageView.setup(withImageUrlPath: withtagItem.photoUrl ?? "")
        self.tagItemTitleLabel.text = withtagItem.name
        
    }
}
