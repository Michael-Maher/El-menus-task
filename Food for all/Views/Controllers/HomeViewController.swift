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
    
    //==============
    //MARK: Outlets
    //==============
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
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Tags and Items ..", attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) , NSAttributedString.Key.font: UIFont.init(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    //========================
    //MARK: Instance variables
    //========================
    private var homeViewModel: HomeViewModel?
    
    //========================
    //MARK: Init methods
    //========================
    init() {
        self.homeViewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.homeViewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    //=============================
    //MARK: View life cycle methods
    //=============================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        fetchData()
    } // viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setupMainNavigationBar() // this method to configure navigation bar in this controller
    } // viewWillAppear
    
    //===================
    //MARK: UI configuration
    //===================
    func setupView() {
        self.title = "Food for all 😎"

        self.view.addSubview(tagItemsTableView)
        tagItemsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tagItemsTableView.refreshControl = refreshControl
    } // setupView
    
    //===================
    //MARK: Loading data
    //===================
    @objc
    func fetchData() {
        refreshControl.endRefreshing() // remove refresh control if exists
        view.addAnimatedLoadingView(animationJSON: .foodAnimation)
        homeViewModel?.initialDataLoading(completion: { [unowned self] (_) in // make initial request to get tag list and first tag items. This closure to know when requests finished to remove the animated view.
            self.view.removeAnimatedLoadingView()
        })
        self.homeViewModel?.delegateHomeModelToHomeController = self // This delegate to inform home view controller that home view model has finished single tag items fetching.
    } // fetchData
}

//============================
//MARK: Table view data source
//============================
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewModelItems = homeViewModel?.singleTagItems
        return (viewModelItems?.count ?? 0) + 1 // Total table view rows count = single tag items count + 1 (for tags list cell.. first cell)
    } // number of rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // tags list cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagsTableCell.identifier, for: indexPath)
                as? TagsTableCell,
                let viewModel = homeViewModel else {
                    return UITableViewCell()
            }
            cell.setupViewModel(viewModel: viewModel) // pass our view model to cell to set corresponding delegate to it
            homeViewModel?.setupTagsCellDelegate(cell: cell) // pass cell to view model to set corresponding delegate to it
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:TagItemsTableCell.identifier, for: indexPath)
                as? TagItemsTableCell,
            let singleTagItems = homeViewModel?.singleTagItems[indexPath.row - 1] else {
                    return UITableViewCell()
            } // (indexPath - 1) as we start single tag items from index 1 as index 0 was for tags list
            cell.configureCell(withTagItem: singleTagItems)
            
            return cell
        }
        
    }
}

//============================
//MARK: Delegate Methods
//============================
extension HomeViewController: HomeModelToHomeControllerDelegate, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = homeViewModel?.singleTagItems[indexPath.row - 1] else { return }
        
        tableView.deselectRow(at: indexPath, animated: true) // remove selection mark
        let itemViewController = ItemViewController()
        itemViewController.tagItem = item // pass tag to ItemViewController.
        self.navigationController?.pushViewController(itemViewController, animated: true)
    } // didSelectRowAt
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TagItemsTableCell, indexPath.row != 0 else { return }
        // Animate cells
        let animation = AnimationFactory.makeSlideIn(duration: 0.3, delayFactor: 0.02)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: self.tagItemsTableView) // show this cell with slide in effect
    } // willDisplay
    
    
    //====================================================================================
    //MARK: Delegate Method from Tags Table cell (from 2 scenarios: 1- initial data loading OR 2- selecting any tag)
    //====================================================================================
    func didFetchSingleTagData(singeTagItems: [Items]?, errorMsg: String?) {
        if singeTagItems != nil {
            self.tagItemsTableView.reloadData()
        } else {
            GenericView.showErrorMsgForTime(errorMsg: errorMsg) // If error occurred, just show error view
        }
    }
    
}

