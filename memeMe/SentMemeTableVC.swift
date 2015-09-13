//
//  SentMemeTableVC.swift
//  memeMe
//
//  Created by 咩咩 on 15/9/11.
//  Copyright (c) 2015年 Wenzhe. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    //Table View Data Source///////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    //Table View Delegate///////////////////////
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func newMeMe(sender: UIBarButtonItem) {
        let memeController = self.storyboard!.instantiateViewControllerWithIdentifier("memeController") as! NewMemeViewController
        navigationController!.pushViewController(memeController, animated: true)
    }
}

    