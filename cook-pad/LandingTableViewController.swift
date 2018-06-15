//
//  LandingTableViewController.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/15/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class LandingTableViewController: UITableViewController, MediaDelegate {

    var tagsArray = [String]()
    var mediaURL:[Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        
        //For some reason Insta has not made trending tags API as public, I have created array of tags based on the tags that I have put on my instagram posts. For person testing the application Please change below tags to most frequently used tags on instagram posts of logged in user.
        self.tagsArray = ["bike","nofilter","beer","goodtime","dinner","balcony","gym","worldcup"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = "#TAGS"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tagsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagsIdentifier", for: indexPath)
        cell.textLabel?.text = self.tagsArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.title = "Fetching Media"
        let getMedia = MediaModel()
        getMedia.getMediaByTags(tag: self.tagsArray[indexPath.row], delegate: self)
    }
    
    
    func didReceiveMediaSuccessfully(data: [Any]) {
        self.title = "#TAGS"
        if data.count > 0{
            self.mediaURL = data
            performSegue(withIdentifier: "MediaCollectionIdentifier", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "No Media", message: "No Media with selected tag, Please select different tag", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MediaCollectionIdentifier"{
            if let destination = segue.destination as? MediaCollectionViewController {
                destination.mediaArray = self.mediaURL
            }
        }
    }

    
    func didFailToGetMedia() {
        
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
