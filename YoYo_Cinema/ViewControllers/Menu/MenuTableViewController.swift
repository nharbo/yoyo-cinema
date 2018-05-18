//
//  MenuTableViewController.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicowear. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuTableViewController: UITableViewController {

    //MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }

    //MARK: - TableView Setup
    //To make segues from the tableview, ctrl-drag from the cell to the navigationcontroller/view and choose "reveal view controller push controller"
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell", for: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
		if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSearchTableViewCell", for: indexPath) as! MenuSearchTableViewCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "MenuFavouritesTableViewCell", for: indexPath) as! MenuFavouritesTableViewCell
			return cell
		}
	}

	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
	}

}
