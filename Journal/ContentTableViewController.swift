//
//  ContentTableViewController.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    // MARK: Property
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    @IBAction func dismissToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

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
    
    @IBAction func saveMyPost(_ sender: Any) {
    }
    
}
