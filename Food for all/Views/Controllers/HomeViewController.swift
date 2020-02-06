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
        navigationBar.barTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.9686697346)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]        
        navigationBar.setItems([navItem], animated: false)
        
        return navigationBar
    }()
    
    private var homeViewModel: HomeViewModel?
    
    init() {
        self.homeViewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.homeViewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func setupView() {
        //        self.view.addSubview(navigationBar)
        //        navigationBar.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        //            make.leading.trailing.equalToSuperview()
        //        }
        self.view.addSubview(tagItemsTableView)
        tagItemsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        title = "Food for all 😎"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.9686697346)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                             .font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    func fetchData() {
        homeViewModel?.initialDataLoading()
        self.homeViewModel?.delegateHomeModelToHomeController = self
    }
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewModelItems = homeViewModel?.singleTagItems
        return (viewModelItems?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagsTableCell.identifier, for: indexPath)
                as? TagsTableCell,
                let viewModel = homeViewModel else {
                    return UITableViewCell()
            }
            cell.setupViewModel(viewModel: viewModel)
            homeViewModel?.setupTagsCellDelegate(cell: cell)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagItemsTableCell.identifier, for: indexPath)
                as? TagItemsTableCell,
            let singleTagItems = homeViewModel?.singleTagItems[indexPath.row - 1] else {
                    return UITableViewCell()
            }
            cell.configureCell(withtagItem: singleTagItems)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = homeViewModel?.singleTagItems[indexPath.row - 1] else { return }
        let itemViewController = ItemViewController()
        itemViewController.tagItem = item
        self.navigationController?.pushViewController(itemViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TagItemsTableCell, indexPath.row != 0 else { return }
        // Animate cells
        let animation = AnimationFactory.makeSlideIn(duration: 0.3, delayFactor: 0.02)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: self.tagItemsTableView)
    }
}

extension HomeViewController: HomeModelToHomeControllerDelegate {
    func didFetchSingleTagData(singeTagItems: [Items]?, errorMsg: String?) {
        DispatchQueue.main.async {
            self.tagItemsTableView.reloadData()
        }
    }
    
}

