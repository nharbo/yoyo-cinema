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
    private var movies = [Movie]()
    private var showSpinner = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search movies"

        //Menu setup
        let revealController = self.revealViewController()
        revealController?.tapGestureRecognizer()
        revealViewController().delegate = self
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(self.revealViewController().revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //Tableview setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Searchbar setup
        self.searchBar.delegate = self
        
        //Observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: Constants.SEARCH_VC_RELOAD_TABLEVIEW_NOTIFICATION, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Get latest search results, if any
        if let latestSearchResult = controller.getLastSearchResults() {
            self.movies = latestSearchResult
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Segue handeling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetails"{
            if let indexPath = sender as? IndexPath {
                let vc = segue.destination as! MovieDetailsVC
                vc.movie = self.movies[indexPath.row]
            }
        }
    }
    
    //MARK: - Helper Methods
    func stopSpinnerAndReloadTableView() {
        self.showSpinner = false
        self.tableView.reloadData()
    }
    
    //MARK: - Observer handeling
    @objc func reloadTableView(notification: NSNotification) {
        self.tableView.reloadData()
    }

}

//MARK: - SearchBar Delegates
extension SearchVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showSpinner = true
        self.tableView.reloadData() //Reload to show spinner
        self.view.endEditing(true) //Dismiss keyboard while searching

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
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            let movie = self.movies[indexPath.row]
            //Check if movie is a favourite
            if self.controller.isMovieAFavourite(movie: movie) {
                cell.isFavourite = true
            } else {
                cell.isFavourite = false
            }
            cell.movie = movie
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 1.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "searchToDetails", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell {
            cell.resetCell()
        }
    }
  
}

//MARK: - SWRevealViewControllerDelegates
extension SearchVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        //Remove keyboard when menu is moving
        self.view.endEditing(true)
    }
    
}









