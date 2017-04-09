//
//  ViewController.swift
//  Coding Challenge
//
//  Created by Srikanth Adavalli on 4/7/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit
protocol NotificationName {
    var name: Notification.Name { get }
}

enum Notifications: String, NotificationName {
    case myNotification
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var footerView: UIView!
    
    var query: String!
    var previousQuery:String?
    var networkRequest: NetworkRequestor = NetworkRequestor()
    var dataModel: [DataModel]?
    
    fileprivate var pageNumber: Int = 1
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        self.searchBarSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver((Any).self, name: Notifications.myNotification.name, object: nil)
    }
    
    @IBAction func tappedOnSearchButton(_ sender: AnyObject) {
        searchBar.placeholder = Constants.SEARCH_TEXT
        searchBar.isHidden = false
        navigationItem.titleView = searchBar
        
        if let title = searchBar.text  {
            if let buttonImage = searchBarButton.image {
                if (title.isEmpty || title == Constants.NIL_TEXT) && buttonImage.isEqual(Constants.SEARCH_IMAGE){
                    searchBarButton.image = nil
                    searchBarButton.title = Constants.BAR_BUTTON_TEXT_CANCEL
                }
            }
                
            else if (title.isEmpty || title == Constants.NIL_TEXT) && searchBarButton.image == nil {
                searchBarButton.title = ""
                searchBarButton.image = Constants.SEARCH_IMAGE
                searchBar.isHidden = true
            }
                
            else {
                searchBarButton.image = nil
                searchBarButton.title = Constants.BAR_BUTTON_TEXT_SUBMIT
                
                if query != previousQuery {
                    SwiftSpinner.show(Constants.SPINNER_TITLE, animated: true)
                    networkRequest.sendRequest(query: query, page: String(pageNumber)) { [weak self] (dataModel, error) in
                        DispatchQueue.global(qos: .default).async(execute: {
                            self?.dataModel = dataModel
                            self?.previousQuery = self?.query
                            DispatchQueue.main.async {
                                self?.tableView.dataSource = self
                                self?.tableView.delegate = self
                                NotificationCenter.default.addObserver(forName: Notifications.myNotification.name, object: nil, queue: nil, using: { notification in
                                    self?.tableView.reloadData()
                                })
                            }
                            
                        })
                    }
                }
            }
        }
    }
    
    private func setUpTableView() {
        self.tableView.tableFooterView = footerView
        self.tableView.register(UINib(nibName: Constants.NIB_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.IDENTIFIER_TABLE_VIEW_CELL)
    }
    
    private func configNavigationBar() {
        self.customNavController(barStyle: nil, tintColor: nil)
    }
    
    private func searchBarSetup() {
        searchBar.delegate = self
        searchBarButton.image = Constants.SEARCH_IMAGE
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataModel?.count else {
            footerView.isHidden = false
            return 0
        }
        footerView.isHidden = true
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIER_TABLE_VIEW_CELL, for: indexPath) as? TableViewCell {
            DispatchQueue.global(qos: .userInteractive).async(execute: {
                if let data = self.dataModel?[indexPath.row] {
                    if let title = data.original_title, let overView = data.overview{
                        DispatchQueue.main.async(execute: {
                            cell.configure(title: title, overView: overView, image: data.image)
                        })
                    }
                }
                
            })
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            pageNumber += 1
            
            guard let searchQuery = query else {
                return
            }
            
            networkRequest.sendRequest(query: searchQuery, page: "\(pageNumber)") { dataModel, error in
                for model in dataModel! {
                    self.dataModel?.append(model)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let rowData = dataModel?[indexPath.row] {
            
            let viewController:DetailViewController = UIStoryboard(name: "DetailVC", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
            
            viewController.dataSource = rowData
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
        query = searchText
        if (searchBar.text?.characters.count)! > 0 {
            searchBarButton.title = Constants.BAR_BUTTON_TEXT_SUBMIT
        }
        
        if searchBar.text?.characters.count == 0 {
            searchBarButton.title = Constants.BAR_BUTTON_TEXT_CANCEL
        }
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = Constants.NIL_TEXT
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = Constants.NIL_TEXT
        self.view.endEditing(true)
    }
}


