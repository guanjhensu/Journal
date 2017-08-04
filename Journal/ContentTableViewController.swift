//
//  ContentTableViewController.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import CoreData


class ContentTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    // MARK: Property

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var postID: NSManagedObjectID? = nil
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        
        contentTextView.tintColor = UIColor.black
        
        titleTextField.tintColor = UIColor.black
        
        editPost()

    }
    
    // MARK: Edit
    
    func editPost() {
    
        if postID == nil { return }
        
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                print("couldn't find appDelegate")
                return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        var error: NSError?
        
        do {
            let object = try context.existingObject(with: postID!)
            
            print(object)
            

        
        } catch {
        
        }

    
    }
    
    // MARK: Cell height

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // MARK: UITextViewDelegate

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }

    // MARK: Dismiss to main page

    @IBAction func dismissToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Photo

    @IBAction func pickImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCamera() }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openGallary() }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        
        self.present(alert, animated: true, completion: nil)
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.black
    }
    
    
    func openCamera() {
        
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alert  = UIAlertController(title: "Warning", message: "We don't have camera.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            myImageView.image = image
            
            myImageView.contentMode = .scaleAspectFill
            
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            myImageView.image = image
            
            myImageView.contentMode = .scaleAspectFill
            
        } else {
            
            print("Something went wrong with photo you choose")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Save
    
    @IBAction func saveMyPost(_ sender: Any) {
    
        let image = myImageView.image!
        
        // save to CoreData
        
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                print("couldn't find appDelegate")
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newPost = PostContent(context: context)
        
        newPost.postImage = UIImageJPEGRepresentation(image, 1.0) as NSData?
        
        newPost.postTitle = self.titleTextField.text
        
        newPost.postWord = self.contentTextView.text
        
        appDelegate.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
