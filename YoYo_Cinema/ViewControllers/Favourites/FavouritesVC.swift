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
    
    //MARK: IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your favourites"

        //Menu setup
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(self.revealViewController().revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
