//
//  DetailViewController.swift
//  memeMe
//
//  Created by 咩咩 on 15/9/12.
//  Copyright (c) 2015年 Wenzhe. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var memeIndex: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        let memeController = storyboard!.instantiateViewControllerWithIdentifier("memeController") as! NewMemeViewController
        memeController.meme = meme
        navigationController!.pushViewController(memeController, animated: true)
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(memeIndex)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}