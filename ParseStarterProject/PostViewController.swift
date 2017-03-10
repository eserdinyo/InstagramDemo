//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Muhammet Eser on 28.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagePosting: UIImageView!
    @IBOutlet weak var imageText: UITextField!
    @IBAction func chooseBtn(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtn(_ sender: Any) {
        
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Posts")
        
        post["message"] = imageText.text
        post["userID"] = PFUser.current()?.objectId!
        
        let imageData = UIImageJPEGRepresentation(imagePosting.image!, 10)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil{
                
                self.createAlert(title: "Could not post image", message: "Please try later")
            }else{
                
                self.createAlert(title: "Image Posted", message: "Your image has been posted!")
                self.imageText.text = ""
                self.imagePosting.image = UIImage(named: "default.jpg")
                
            }

        }
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imagePosting.image = image
        }else{
            print("There is an error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
