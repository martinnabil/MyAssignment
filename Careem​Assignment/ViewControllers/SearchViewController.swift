//
//  SearchViewController.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import UIKit
import ShadowView
import NVActivityIndicatorView
import DZNEmptyDataSet
import SwiftGifOrigin
import UIScrollView_InfiniteScroll


private let movieTableViewCellID = "MovieTableViewCell"
private let defaultCellID = "Cell"
private let sectionHeaderCellID = "SectionHeaderCell"

let defaults = UserDefaults.standard


class SearchViewController: BaseViewController {
    
    // MARK:- Variables
    @IBOutlet weak var navigationBarShadowView: ShadowView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBarHeight: NSLayoutConstraint!
    
    var keyword: String = "" {
        didSet {
            updateKeyword()
        }
    }
    
    var numOfAPICalls: Int = 0
    var page: Int = 1
    var maxPages = 0
    lazy fileprivate var movies : [Results] = {
        return [Results]()
    }()
    
    var suggestions: [String] = []
    var suggestionsToView: [String] = ["Suggestions"]
    var showSuggestions: Bool = true
    var dataSource: [Results] = []
    
    // MARK:- View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureLastTenSuggestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Configuration
    func configureUI() {
        self.navigationController?.title = ""
        self.navigationController?.navigationBar.topItem?.title = "Careem Assignment"
        self.navigationController?.navigationBar.backgroundColor = UIColor.gray
        loadingIndicator.type = .circleStrokeSpin
        loadingLabel.text = "Please type a name of a movie and press search."
        loadingLabel.isHidden = false
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: movieTableViewCellID, bundle: nil), forCellReuseIdentifier: movieTableViewCellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        tableView.contentInset = adjustForTabbarInsets
        tableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    func configureLastTenSuggestions(){
        suggestions = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        suggestionsToView.removeAll()
        suggestionsToView.append("Suggested")
        for item in suggestions.reversed() {
            if suggestionsToView.count < 11 {
                suggestionsToView.append(item)
            }
        }
    }
    
    // MARK:- Helpers
    
    func adjustInfiniteScrollStatus(newArray: [Results]) {
        if  self.page >= self.maxPages {
            tableView.removeInfiniteScroll()
        }
    }
    func adjustInfiniteScroll() {
        weak var weakSelf = self
        tableView.addInfiniteScroll { (tableView) -> Void in
            weakSelf?.page += 1
            weakSelf?.searchBusinesses(complete: { (feedArr) in
                if let arr: [Results] = feedArr, arr.count > 0 {
                    // create new index paths
                    let storyCount: Int = (weakSelf?.dataSource.count)!
                    let (start, end) = (storyCount, arr.count + storyCount)
                    let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                    // update data source
                    weakSelf?.dataSource.append(contentsOf: arr)
                    // update table view
                    weakSelf?.tableView.beginUpdates()
                    weakSelf?.tableView.insertRows(at: indexPaths, with: .automatic)
                    weakSelf?.tableView.endUpdates()
                    weakSelf?.adjustInfiniteScrollStatus(newArray: feedArr ?? [])
                }
                tableView.finishInfiniteScroll()
            })
        }
    }
    
    func updateKeyword() {
        if keyword.count > 0 {
            showSuggestions = false
            adjustInfiniteScroll()

            fetchData()
        }
        else {
            showSuggestions = true
            tableView.finishInfiniteScroll()
            tableView.removeInfiniteScroll()
            tableView.reloadData()
        }
    }
    
    func startLoadingIndicatorAnimating() {
        if numOfAPICalls == 0 {
            loadingLabel.text = "One moment, getting rersults for you"
            loadingLabel.isHidden = false
            loadingIndicator.startAnimating()
        }
        numOfAPICalls += 1
    }
    
    func stopLoadingIndicatorAnimating() {
        numOfAPICalls -= 1
        if numOfAPICalls == 0 {
            loadingLabel.text = "Your search results for \(keyword)"
            loadingIndicator.stopAnimating()
        }
    }
    
    
    // MARK:- API call
    func fetchData() {
        weak var weakSelf = self
        adjustInfiniteScroll()
        self.searchBusinesses(complete: { (feedArr) in
            weakSelf?.dataSource = feedArr ?? []
            weakSelf?.tableView.reloadData()
            weakSelf?.adjustInfiniteScrollStatus(newArray: feedArr ?? [])
        })
    }
    
    func searchBusinesses(complete: @escaping ([Results]?)->Void) {
        startLoadingIndicatorAnimating()
        weak var weakSelf = self
        SearchManager.shared.searchBusiness(basicDictionary: keyword, page: "\(page)", onSuccess: { (movies) in
            
            if movies.total_results != 0 && !self.suggestionsToView.contains(self.keyword){
                self.suggestions.append(self.keyword)
                defaults.set(self.suggestions, forKey: "SavedStringArray")
                self.configureLastTenSuggestions()
            }
            weakSelf?.maxPages = movies.total_pages!
            if  self.page <= movies.total_pages! {
                weakSelf?.movies =  movies.results!
                weakSelf?.stopLoadingIndicatorAnimating()
                complete(movies.results!)
            }
        }) { (apiError) in
            
            weakSelf?.stopLoadingIndicatorAnimating()
            
        }
    }
}

// MARK:- Extensions
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        page = 1
        loadingLabel.text = "Please type a name of a movie and press search."
        searchBar.resignFirstResponder()
        keyword = searchBar.text!
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchBar.resignFirstResponder()
            keyword = searchBar.text!
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text!
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        page = 1
        loadingLabel.text = "Please type a name of a movie and press search."
        searchBar.resignFirstResponder()
        keyword = searchBar.text!
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSuggestions {
            return  suggestionsToView.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if showSuggestions {
            var cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID)
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: sectionHeaderCellID)
            }
            cell?.textLabel?.text = suggestionsToView[indexPath.row]
            return cell!
        }
        if movies.count > 0{
            return getMovieTableViewCell(for: indexPath, indexInArray: indexPath.row)
        }
        return UITableViewCell()
    }
    
    //MARK: Helper Methods
    func getMovieTableViewCell(for indexPath: IndexPath, indexInArray: Int) -> MovieTableViewCell {
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: movieTableViewCellID, for: indexPath) as! MovieTableViewCell
        cell.movie = dataSource[indexInArray]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
            
        } else {
            if let _ = tableView.cellForRow(at: indexPath) {
                searchBar.text = suggestionsToView[indexPath.row]
                keyword = suggestionsToView[indexPath.row]
            }
        }
    }
}

extension SearchViewController: DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "icon_Empty")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "Nothing matched your search,\nplease try different search terms?"
        let myAttribute = [
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.font: FontsManager.shared.OpenSansRegularWithSize(14)
        ]
        let titleAttributedString = NSAttributedString(string: title, attributes: myAttribute)
        
        return titleAttributedString
    }
    
}
