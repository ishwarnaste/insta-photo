//
//  MediaCollectionViewCell.swift
//  cook-pad
//
//  Created by Naste, Ishwar (US - Bengaluru) on 6/15/18.
//  Copyright © 2018 Ishwar Naste. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    let fetchImage = FetchServices()
    func loadImage(murls: String) {
        let murl = URL(string: murls)
        fetchImage.getThumbnailImage(url: murl!) { (image, error) in
            if error == nil {
                self.mediaImageView.image = image
            }
        }
    }
}
