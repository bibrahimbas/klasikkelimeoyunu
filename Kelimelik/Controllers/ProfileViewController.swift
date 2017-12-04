//
//  ProfileViewController.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 24.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changePhotoImage: UIImageView!
    
    var selectedImageTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
        setChangePhotoDefaults()
    }
    
    func setDefaults() {
        UserView.setCircularLogoImage(image: profileImage)
        if let username = User.sharedUser.username as? String {
            usernameTextField.text = username
        }
        if let email = User.sharedUser.email as? String {
            emailTextField.text = email
        }
    }
    
    func setChangePhotoDefaults() {
        profileImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePhotoImagePressed))
        profileImage.addGestureRecognizer(tapRecognizer)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func changePhotoImagePressed(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let view = sender.view {
                selectedImageTag = view.tag
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        DataService.sharedInstance.updateUserProfile(username: usernameTextField.text!, email: emailTextField.text!, photoUrl: " ", completed: { (result) in
            print("xxxxxxxx")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = image
    }
}
