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
    //========================
    //MARK: Variables
    //========================
    static let identifier = "TagItemsTableCell"
    
    //========================
    //MARK: Outlets
    //========================
    private var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        view.layer.cornerRadius = 15
        view.dropShadow()
        return view
    }()
    
    private var tagItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private var tagItemDescriptionLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 4
        descLabel.lineBreakMode = .byTruncatingTail
        descLabel.textAlignment = .left
        descLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return descLabel
    }()
    
    private var tagItemInfoStackView: UIStackView = {
        let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fillProportionally
            stack.spacing = 5.0
        
        return stack
        }()
    
    //========================
    //MARK: Init methods
    //========================
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagItemsTableCell {
    //========================
    //MARK: UI configuration
    //========================
    func setupCellLayout() {
        self.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(8)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }
        
        backGroundView.addSubview(tagItemImageView)
        tagItemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(110)
            make.height.equalTo(tagItemImageView.snp.width).multipliedBy(3 / 2)
            make.leading.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(tagItemImageView.snp.centerY)
        }
        
        tagItemInfoStackView.addArrangedSubview(tagItemTitleLabel)
        tagItemInfoStackView.addArrangedSubview(tagItemDescriptionLabel) // add title and description into vertical stack

        backGroundView.addSubview(tagItemInfoStackView)
        tagItemInfoStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(tagItemImageView.snp.trailing).offset(10)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-5)
            make.centerY.equalTo(tagItemImageView.snp.centerY)
            make.top.bottom.equalTo(tagItemImageView)
        }
    } // setupCellLayout
    
    func configureCell(withTagItem: Items) {
        self.tagItemImageView.setup(withImageUrlPath: withTagItem.photoUrl ?? "", cornerRadius: 15)
        self.arrowImageView.image = UIImage(named: "arrow")
        self.tagItemTitleLabel.text = withTagItem.name
        self.tagItemDescriptionLabel.text = withTagItem.description
    } // configureCell
}
