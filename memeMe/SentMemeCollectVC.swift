//
//  SentMemeCollectVC.swift
//  memeMe
//
//  Created by 咩咩 on 15/9/12.
//  Copyright (c) 2015年 Wenzhe. All rights reserved.
//

import Foundation

import UIKit

class SentMemeCollectVC: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let w = (self.view.frame.size.width - (2 * space)) / 3.0
        let h = (self.view.frame.size.height - (2 * space)) / 5.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(w, h)
    }
    
    //Collection view data source////////////////////
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! MemeCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    //Collection View Delegate////////////////////////
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = memes[indexPath.row]
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func newMeMe(sender: UIBarButtonItem) {
        let memeController = self.storyboard!.instantiateViewControllerWithIdentifier("memeController") as! NewMemeViewController
        navigationController!.pushViewController(memeController, animated: true)
    }
    
}

class MemeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
}

