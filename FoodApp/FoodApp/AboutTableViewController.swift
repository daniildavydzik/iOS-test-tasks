//
//  AboutTableTableViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 02.05.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit
import SafariServices
class AboutTableTableViewController: UITableViewController {
    var sectionTitles = ["Leave Feedback" , "Follow us" ]
    var sectionContent  = [["Rate us on AppStore", "Tell us your feedback"],["Twitter" , "Facebook" , "Pinterest"]]
    var links = ["https://twitter.com/appcodamobile","https://facebook.com/appcodamobile", "https://pinterest.com/appcoda/"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView =  UIView(frame: CGRect.zero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = URL(string:"http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.shared.open(url)
                }}else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self)
                print("CLAC")
            }
            
        case 1:
            if let url = URL(string: links[indexPath.row]) {
            let safariVc = SFSafariViewController(url: url)
            present(safariVc , animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
