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

//    private var tagsCollectionView = UICollectionView()
//    private var tagItemsTableView = UITableView()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width * 0.25
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: 50)

        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = UIScreen.main.bounds.width * 0.1
        layout.minimumInteritemSpacing = UIScreen.main.bounds.width * 0.1 // or any value you want

        let collectionView = UICollectionView()
        collectionView.backgroundColor = .red
        collectionView.isPagingEnabled = true
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        return collectionView
    }()
    
    private lazy var tagItemsTableView: UITableView = {
//           let width = UIScreen.main.bounds.width * 0.25
//           let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//           layout.itemSize = CGSize(width: width, height: 150)
//
//           layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//           layout.scrollDirection = .horizontal
//           layout.minimumLineSpacing = UIScreen.main.bounds.width * 0.1
//           layout.minimumInteritemSpacing = UIScreen.main.bounds.width * 0.1 // or any value you want

           let tableView = UITableView()
           tableView.backgroundColor = .yellow
           tableView.delegate = self
           tableView.dataSource = self
           tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tagsCollectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
           }
        tableView.register(Tags, forCellReuseIdentifier: <#T##String#>)
           return tableView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    func setupUI () {
//        setupTagsCollectionView()
//        setupTagItemsTableView()
//        colle
        self.view.addSubview(tagsCollectionView)
        self.view.addSubview(tagItemsTableView)
    }
//
//    func setupTagsCollectionView() {
//        let tagsCollectioLayout = UICollectionViewFlowLayout()
//        tagsCollectioLayout.
//        tagsCollectionView.
//    }
//
//    func setupTagItemsTableView () {
//
//    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>)
        return UITableViewCell()
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

