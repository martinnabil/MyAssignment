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
enum SearchOptions {
    case All
    case Businesses
    case Users
}

private let movieTableViewCellID = "MovieTableViewCell"
private let defaultCellID = "Cell"
private let sectionHeaderCellID = "SectionHeaderCell"
//private let optionButtonColor: UIColor = UIColor().hexStringToUIColor(hex: "#2F87DE")
private let suggestions: [String] = ["Suggested", "H&M", "Summer clothing", "Men’s clothing", "Zara"]


class SearchViewController: BaseViewController {

    // MARK:- Variables
    @IBOutlet weak var navigationBarShadowView: ShadowView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
   
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var everythingButton: UIButton!
    @IBOutlet weak var placesButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBarHeight: NSLayoutConstraint!
    

    var keyword: String = "" {
        didSet {
            updateKeyword()
        }
    }
    
    var selectedOption: SearchOptions = .All
    var hideStack: Bool = false
    var numOfAPICalls: Int = 0
    
    lazy fileprivate var movies : [Results] = {
        return [Results]()
    }()

    
    var showSuggestions: Bool = true

    // MARK:- View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Configuration
    func configureUI() {
//        everythingButton.addCornerRadius(raduis: everythingButton.frame.height / 2, borderColor: optionButtonColor, borderWidth: 1)
//        placesButton.addCornerRadius(raduis: placesButton.frame.height / 2, borderColor: optionButtonColor, borderWidth: 1)
//        peopleButton.addCornerRadius(raduis: peopleButton.frame.height / 2, borderColor: optionButtonColor, borderWidth: 1)
        
//        navigationBarShadowView.addShadowLikeNavigationBar()
        
        loadingIndicator.type = .circleStrokeSpin
        
 
        
//        if UIDevice().userInterfaceIdiom == .phone {
//            if UIScreen.main.nativeBounds.height == 2436 { //iPhone X
//                customNavigationBarHeight.constant = iPhoneXNavigationBarHeight
//            }
//            else {
//                customNavigationBarHeight.constant = normalNavigationBarHeight
//            }
//        }
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: movieTableViewCellID, bundle: nil), forCellReuseIdentifier: movieTableViewCellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
    }
    
    // MARK:- Actions
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func optionClicked(_ sender: Any) {
        
        selectOptionButton(optionButton: sender as! UIButton)
        
        switch sender as! UIButton {
        case everythingButton:
            clearOptionButton(optionButton: placesButton)
            clearOptionButton(optionButton: peopleButton)
            selectedOption = .All
            
        case placesButton:
            clearOptionButton(optionButton: everythingButton)
            clearOptionButton(optionButton: peopleButton)
            selectedOption = .Businesses

        case peopleButton:
            clearOptionButton(optionButton: everythingButton)
            clearOptionButton(optionButton: placesButton)
            selectedOption = .Users

        default:
            print("Default")
        }
        
        if showSuggestions == false {
            fetchData()
        }
    }
    
    // MARK:- API call
    func fetchData() {
        movies = []
        searchBusinesses()
//        users = []
//
//        switch selectedOption {
//        case .Businesses:
//            searchBusinesses()
//
//        case .Users:
//            searchUsers()
//
//        default:
//            searchBusinesses()
//            searchUsers()
//        }
    }
    
    func searchBusinesses() {
 
        let parameters: APIParams = [
            "query" : keyword as AnyObject,
            "page" : "1" as AnyObject,
        ]

        startLoadingIndicatorAnimating()
        weak var weakSelf = self
        SearchManager.shared.searchBusiness(basicDictionary: keyword, page: "1", onSuccess: { (movies) in

            
            weakSelf?.movies =  movies.results!
            
//            weakSelf?..append(contentsOf: businesses.businessesArr!)
            weakSelf?.tableView.reloadData()
            weakSelf?.stopLoadingIndicatorAnimating()

        }) { (apiError) in

            weakSelf?.stopLoadingIndicatorAnimating()
//            weakSelf?.businesses = []
//            weakSelf?.tableView.reloadData()
        }
    }
    

    // MARK:- Helper
    func selectOptionButton(optionButton: UIButton) {
//        optionButton.backgroundColor = optionButtonColor
//        optionButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func clearOptionButton(optionButton: UIButton) {
//        optionButton.backgroundColor = UIColor.clear
//        optionButton.setTitleColor(optionButtonColor, for: .normal)
    }
    
    func updateKeyword() {
        if keyword.count > 0 {
            showSuggestions = false
            fetchData()
        }
        else {
            showSuggestions = true
            tableView.reloadData()
        }
    }
    
    func startLoadingIndicatorAnimating() {
        if numOfAPICalls == 0 {
            tableView.isHidden = true
            loadingLabel.isHidden = false
            loadingIndicator.startAnimating()
        }
        numOfAPICalls += 1
    }
    
    func stopLoadingIndicatorAnimating() {
        numOfAPICalls -= 1

        if numOfAPICalls == 0 {
            tableView.isHidden = false
            loadingLabel.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    
}

// MARK:- Extensions
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
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
            return suggestions.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if showSuggestions {
//            var cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID)
//            if indexPath.row == 0 {
//                cell = tableView.dequeueReusableCell(withIdentifier: sectionHeaderCellID)
//            }
//            cell?.textLabel?.text = suggestions[indexPath.row]
//            return cell!
//        }
        
        
        
//        if users.count > 0 {
//            if indexPath.row < users.count {
//                return getFollowerCell(for: indexPath)
//            }
//            else {
//                return getBusinessTableViewCell(for: indexPath, indexInArray: indexPath.row - users.count)
//            }
//        }
//        else {
//            return getBusinessTableViewCell(for: indexPath, indexInArray: indexPath.row)
//        }
        if movies.count > 0{
            return getMovieTableViewCell(for: indexPath, indexInArray: indexPath.row)
        }
        return UITableViewCell()
    }
    
     //MARK: Helper Methods
    func getMovieTableViewCell(for indexPath: IndexPath, indexInArray: Int) -> MovieTableViewCell {
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: movieTableViewCellID, for: indexPath) as! MovieTableViewCell

        cell.movie = movies[indexInArray]

        return cell
    }


    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if cell is BusinessTableViewCell {
//                navigateToBusinessProfile(businessModel: (cell as! BusinessTableViewCell).business)
//            }
//            else if cell is FollowersCell {
//                if let user: User = (cell as! FollowersCell).user {
//                    navigateToUserProfile(userId: user.userID)
//                }
//            }
//            else {
//                searchBar.text = suggestions[indexPath.row]
//                keyword = suggestions[indexPath.row]
//            }
//        }
        
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
