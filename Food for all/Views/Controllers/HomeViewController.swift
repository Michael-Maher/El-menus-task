//
//  ViewController.swift
//  El Menus Task
//
//  Created by Michael Maher on 2/4/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private lazy var tagItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(TagsTableCell.self, forCellReuseIdentifier: TagsTableCell.identifier)
        tableView.register(TagItemsTableCell.self, forCellReuseIdentifier: TagItemsTableCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.tableHeaderView = tagsCollectionView
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var navigationBar : UINavigationBar = {
        let navItem = UINavigationItem(title: "Food for all 😎")
        let navigationBar = UINavigationBar()
        navigationBar.setItems([navItem], animated: false)
        
        return navigationBar
    }()
    
    var tagsList: [Tags] = []
    
    var singleTagItems: [Items] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tagItemsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        fetchData()
    }
    
    func setupView() {
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(tagItemsTableView)
        tagItemsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func fetchData () {
        loadTagsData(page: TagsModel.page)
    }
    
    func loadTagsData(page: Int) {
        self.view.addAnimatedLoadingView(animationJSON: .foodAnimation)
        NetworkManager.getTagsList(page: page, success: { [unowned self] (tags) in
            self.tagsList = tags
            self.loadSingleTagData(tagName: tags[0].tagName ?? "")
        }) { (error) in
            print(error.localizedDescription)
            self.view.removeAnimatedLoadingView()
            
        }
    }
    
    func loadSingleTagData(tagName: String) {
        NetworkManager.getSingleTagItems(tagName: tagName, success: { (items) in
            self.singleTagItems = items
            self.view.removeAnimatedLoadingView()
        }) { (error) in
            print(error.localizedDescription)
            self.view.removeAnimatedLoadingView()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleTagItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagsTableCell.identifier, for: indexPath)
                as? TagsTableCell else {
                    return UITableViewCell()
            }
            cell.tagsList = tagsList
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagItemsTableCell.identifier, for: indexPath)
                as? TagItemsTableCell else {
                    return UITableViewCell()
            }
            cell.configureCell(withtagItem: singleTagItems[indexPath.row - 1])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TagItemsTableCell, indexPath.row != 0 else { return }
        // Animate cells
        let animation = AnimationFactory.makeSlideIn(duration: 0.3, delayFactor: 0.02)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: self.tagItemsTableView)
    }
}

extension HomeViewController: TagsCollectionViewDelegate {
    func didSelectTag(tagName: String) {
        loadSingleTagData(tagName: tagName)
    }
}

