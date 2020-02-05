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
    
    var tagsList: [Tags] = [] {
        didSet {
            if !tagsList.isEmpty {
            let intexPath = IndexPath(row: 0, section: 0)
//                Rows(at: [intexPath], with: .none)

            }
        }
    }
    
    var singleTagItems: [Items] = [] {
        didSet {
            if !singleTagItems.isEmpty {
//                    let firstIntexPath = IndexPath(row: 0, section: 0)
                tagItemsTableView.reloadData()
//                reloadRows(at: tagItemsTableView.indexPathsForVisibleRows!.filter({ $0 != firstIntexPath
//                }), with: .none)

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
        loadTagsData(page:1)
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
        print("Number of Single tag list : \n\n\(singleTagItems.count + 1)")

        return singleTagItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagsTableCell.identifier)
                as? TagsTableCell else {
                    return UITableViewCell()
            }            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagItemsTableCell.identifier)
                as? TagItemsTableCell else {
                    return UITableViewCell()
            }
            cell.configureCell(withtagItem: singleTagItems[indexPath.row])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let tagsCell = cell as? TagsTableCell {
            tagsCell.tagsCollectionView.delegate = self
            tagsCell.tagsCollectionView.dataSource = self
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of list: \n\n\(tagsList.count)")
        return tagsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionCell.identifier, for: indexPath)
            as? TagsCollectionCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(withTag: tagsList[indexPath.row])
        
        return cell
    }
    
    
}

