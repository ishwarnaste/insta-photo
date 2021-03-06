//
//  MediaCollectionViewController.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/15/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit
import SKPhotoBrowser


private let reuseIdentifier = "Cell"

class MediaCollectionViewController: UICollectionViewController {
    
    var mediaArray:[Any] = []
    var mediaURLs:[SKPhoto] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for medi in self.mediaArray{
            let graph =  (medi as! NSDictionary).value(forKeyPath: "images.standard_resolution") as! NSDictionary
            let mediaUrl = graph["url"] as! String
            let photo = SKPhoto.photoWithImageURL(mediaUrl)
            photo.shouldCachePhotoURLImage = true
            self.mediaURLs.append(photo)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.mediaArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaIdentifier", for: indexPath) as! MediaCollectionViewCell
        let graph =  (self.mediaArray[indexPath.row] as! NSDictionary).value(forKeyPath: "images.thumbnail") as! NSDictionary
        let mediaUrl = graph["url"] as! String
        cell.loadImage(murls: mediaUrl)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: self.mediaURLs)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
