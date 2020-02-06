//
//  ItemViewController.swift
//  Food for all
//
//  Created by Michael Maher on 2/6/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import UIKit
import SnapKit

class ItemViewController: UIViewController {

    var tagItem: Items? {
        didSet{
            title = tagItem?.name ?? "Product"
            headerImageView.setup(withImageUrlPath: tagItem?.photoUrl ?? "", cornerRadius: nil)
            descriptionLabel.text = tagItem?.description
        }
    }
    
    struct Constants {
         static fileprivate let headerHeight: CGFloat = 300
     }
    
    // A scroll view to allow the user to scroll up and down to trigger, respectively:
    // - the parallax effect.
    // - the scale effect.
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
//        scrollView.alwaysBounceVertical = true

        return scrollView
    }()

    // A header view containing the image to perform the above effects on.
    // In order to correctly apply the effects the header needs to be implemented using:
    // - a container view.
    // - a contained image view.
    private var headerContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view

    }()
    
    private var headerImageView: UIImageView = {
        let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
        
           return imageView
    }()

    // A view that takes up the rest of the screen
    // and will host any additional content we need.
    // For the sake of this sample, a UILabel would suffice.
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        let titleFont = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkGray
        return label
    }()
    
    
    // This will reference the header view container top constraint
    private var headerTopConstraint: NSLayoutConstraint!

    // This will reference the header view container height constraint
    private var headerHeightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewLayout()
    }
    
    func setupViewLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(headerContainerView)
        headerContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.width.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        headerContainerView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(headerContainerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.bottom.equalToSuperview().offset(-15)
         }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        //        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.2952964469)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black,
                                                                   .font : UIFont.boldSystemFont(ofSize: 17)]
        
    }

}

extension ItemViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            // Scrolling down: Scale
            headerContainerView.snp.updateConstraints { (make) in
                make.height.equalTo(Constants.headerHeight - scrollView.contentOffset.y)
            }
        } else {
            // Scrolling up: Parallax
            let parallaxFactor: CGFloat = 0.70
            let offsetY = scrollView.contentOffset.y * parallaxFactor
            let minOffsetY: CGFloat = 20.0
            let availableOffset = min(offsetY, minOffsetY)
            let contentRectOffsetY = availableOffset / Constants.headerHeight
            headerContainerView.snp.updateConstraints { (make) in
                make.top.equalTo(view.snp.top)
                make.height.equalTo(Constants.headerHeight - scrollView.contentOffset.y)
            }

            headerImageView.layer.contentsRect =
                CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
        }
    }
}
