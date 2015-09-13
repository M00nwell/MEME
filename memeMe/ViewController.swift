//
//  ViewController.swift
//  memeMe
//
//  Created by 咩咩 on 15/8/23.
//  Copyright (c) 2015年 Wenzhe. All rights reserved.
//

import UIKit

class NewMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    @IBOutlet weak var colorButton: UIButton!
    
    var meme: Meme!
    
    let imagePickVC = UIImagePickerController()
    
    let colors = [UIColor.whiteColor(),UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.purpleColor(),UIColor.grayColor(),UIColor.blackColor()]
    
    var colorIndex = 0
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName  : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotification()
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = UIColor.grayColor()
        imagePickVC.delegate = self
        topText.delegate = self
        bottomText.delegate = self
        redrawText()
        if let meme = meme{
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            imageView.image = meme.originalImage
            colorIndex = meme.textColorIndex
            redrawText()
        }
        else{
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            shareButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
        tabBarController?.tabBar.hidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func shareImage(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            if ok {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func pickPhoto(sender: UIBarButtonItem) {

        imagePickVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickVC, animated: true, completion: nil)
    }
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        imagePickVC.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickVC, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        imageView.image = nil
        shareButton.enabled = false
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        colorIndex = 0
        redrawText()
    }
    
    @IBAction func changeColor(sender: UIButton) {
        colorIndex++
        if(colorIndex >= colors.count){
            colorIndex = 0
        }
        redrawText()
    }
    
    func redrawText(){
        colorButton.backgroundColor = colors[colorIndex]
        memeTextAttributes[NSForegroundColorAttributeName] = colors[colorIndex]
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    ///////////////////////////////////
    
    // UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if(topText.isFirstResponder() && textField.text == "TOP")||(bottomText.isFirstResponder() && textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    ///////////////////////////////////
    
    
    // To shift view up when editing bottom textfield
    func keyboardWillShow(notification: NSNotification){
        if(bottomText.isFirstResponder()){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    ////////////////////////////////////
    
    func generateMemedImage() -> UIImage {
        
        topBar.hidden = true
        bottomBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        var meme = Meme(memedImage: generateMemedImage(), topText: topText.text, bottomText: bottomText.text, originalImage: imageView.image!, textColorIndex: colorIndex)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

}

struct Meme {
    var memedImage: UIImage
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var textColorIndex: Int
}
