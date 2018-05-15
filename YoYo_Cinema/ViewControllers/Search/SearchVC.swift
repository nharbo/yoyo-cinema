//
//  SearchVC.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import UIKit
import SWRevealViewController

class SearchVC: UIViewController {
    
    //MARK: - Constants
    let controller = SearchController()
    
    //MARK: - Variables
    var movies = [Movie]()
    var showSpinner = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search movies"

        //Menu setup
        revealViewController().delegate = self
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(self.revealViewController().revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //Tableview setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Searchbar setup
        self.searchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("will disappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stopSpinnerAndReloadTableView() {
        self.showSpinner = false
        self.tableView.reloadData()
    }

}

//MARK: - SearchBar Delegates
extension SearchVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Show spinner
        self.showSpinner = true
        self.tableView.reloadData()
        //Dismiss keyboard
        self.view.endEditing(true)
        //Search for keyword
        self.controller.getMoviesFromSearch(query: searchBar.text!) { (response) in
            if response.success {
                if let movies = response.movies {
                    self.movies = movies
                    self.stopSpinnerAndReloadTableView()
                } else {
                    self.movies.removeAll()
                    self.stopSpinnerAndReloadTableView()
                    //TODO: Show message - no matches
                }
            } else {
                if let error = response.error {
                    //TODO: Show error message
                    print(error)
                }
            }
        }
    }
}

//MARK: - TableView Delegates
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSpinner {
            return 1
        } else {
            return movies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showSpinner {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpinnerTableViewCell", for: indexPath) as! SpinnerTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.movie = self.movies[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
  
}

//MARK: - SWRevealViewControllerDelegates
extension SearchVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        //Remove keyboard when menu is moving
        self.view.endEditing(true)
    }
    
}
