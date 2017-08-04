//
//  ContentTableViewController.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import Photos

class ContentTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    // MARK: Property
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var localImageId: String!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        
        contentTextView.tintColor = UIColor.black
        
        titleTextField.tintColor = UIColor.black

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

//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        PHPhotoLibrary.shared().performChanges({
            
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            
            let assetPlaceholder = result.placeholderForCreatedAsset

            self.localImageId = assetPlaceholder?.localIdentifier
        
        }) { (isSuccess: Bool, error: Error?) in
            
            if isSuccess {
                
                let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to album.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
                
                let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [self.localImageId], options: nil)
                
                let asset = assetResult[0]
                
                let options = PHContentEditingInputRequestOptions()
                
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                    
                    return true
                }

                asset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput: PHContentEditingInput?, _: [AnyHashable : Any]) in
                    
                    print("imageURL：", contentEditingInput!.fullSizeImageURL!)})
                
                
                
                
                // get image
                
                //获取保存的原图
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit,
                                                      options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                        print("获取原图成功：\(image)")
                })
                //获取保存的缩略图
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: CGSize(width:100, height:100), contentMode: .aspectFit,
                                                      options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                        print("获取缩略图成功：\(image)")
                })
                
            } else {
                
                let alert = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
            }
        }
        
    }
    
}
