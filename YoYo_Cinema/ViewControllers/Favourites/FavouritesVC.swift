//
//  FavouritesVC.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import UIKit
import SWRevealViewController

class FavouritesVC: UIViewController {
    
    //MARK: - Constants
    let controller = FavouritesController()
    
    //MARK: - Variables
    private var favouriteMovies = [Movie]()
    
    //MARK: - IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tableview setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "Your favourites"

        //Menu setup
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(self.revealViewController().revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.getFavourites { (favourites) in
            self.favouriteMovies = favourites
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Segue handeling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouritesToDetails"{
            let vc = segue.destination as! MovieDetailsVC
            vc.movie = self.favouriteMovies[sender as! Int]
        }
    }

}


//MARK: - TableView Delegates
extension FavouritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteMovieTableViewCell", for: indexPath) as! FavouriteMovieTableViewCell
        cell.movie = self.favouriteMovies[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "favouritesToDetails", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteMovieTableViewCell", for: indexPath) as? FavouriteMovieTableViewCell {
            cell.resetCell()
        }
    }
    
}

extension FavouritesVC: FavouriteMovieTableViewCellDelegate {
    func removeFromFavourites(movie: Movie) {
        controller.removeFavourite(movie: movie) { (done) in
            if done {
                controller.getFavourites(callback: { (movies) in
                    self.favouriteMovies = movies
                    self.tableView.reloadData()
                    NotificationCenter.default.post(name: Constants.SEARCH_VC_RELOAD_TABLEVIEW_NOTIFICATION, object: nil) //Notifying SearchVC
                })
            }
        }
    }
    
    
}
