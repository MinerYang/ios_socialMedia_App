//
//  SignUpViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/6/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageSelected  = false
    @IBOutlet weak var PlusPhotoBtn: UIButton!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var fullnameTXT: UITextField!
    @IBOutlet weak var usernameTXT: UITextField!
    @IBOutlet weak var pswTXT: UITextField!
    
    
    @IBOutlet weak var SignupBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SignupBtn.isEnabled = false
        SignupBtn.layer.cornerRadius = 5
        
//        PlusPhotoBtn.layer.masksToBounds = true
//        PlusPhotoBtn.layer.borderWidth = 2
//        PlusPhotoBtn.layer.cornerRadius = PlusPhotoBtn.bounds.size.height/2.0

        emailTXT.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        pswTXT.addTarget(self, action: #selector(formValidation), for: .editingChanged)
    }
    @objc func formValidation(){
        guard
            emailTXT.hasText,
            pswTXT.hasText,
            fullnameTXT.hasText,
            usernameTXT.hasText,
            imageSelected == true
        else {
                //print("email field is empty, password field is empty")
                SignupBtn.isEnabled = false
                SignupBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        SignupBtn.isEnabled = true
        SignupBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
    // ADD IMAGE BUTTON
    @IBAction func handlePlusPhotoBtn(_ sender: UIButton) {
        //print("handle selecting photos")
        // configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // select image
        guard let selectImage = info[.editedImage] as? UIImage else{
            imageSelected = false
            return
        }
        // set imageSelected true
        imageSelected = true
        
        // resize image , configue btn with select image
        let sizedImage = resizeImage(image: selectImage, newWidth: PlusPhotoBtn.frame.width)
        PlusPhotoBtn.layer.cornerRadius = PlusPhotoBtn.frame.width / 2
        
        PlusPhotoBtn.layer.masksToBounds = true
        PlusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        PlusPhotoBtn.layer.borderWidth = 2
        PlusPhotoBtn.setImage(sizedImage?.withRenderingMode(.alwaysOriginal), for: .normal )
        self.dismiss(animated: true , completion: nil)
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

      let scale = newWidth / image.size.width
      let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage
    }
    
    // SIGN UP BUTTON
    @IBAction func handleSignUp(_ sender: UIButton) {
        print("sign up page, click sign up")
        guard let email = emailTXT.text else{return}
        guard let password = pswTXT.text else{return}
        guard let fullname = fullnameTXT.text else{return}
        guard let username = usernameTXT.text else {return}
        print("email:\(email), password:\(password)")
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            //handle error
            if let error = error {
                //self.alert(message: error.localizedDescription)
                print("Failed to create user with error\(error.localizedDescription)")
                return
            }
            //
            guard let profileImg = self.PlusPhotoBtn.imageView?.image else{
                //self.alert(message: "imageview set failed")
                print("imageview set failed")
                return
            }
            // upload image
            guard let uploadata = profileImg.jpegData(compressionQuality: 0.6) else {
                //self.alert(message: "upload image data failed")
                print("upload image data failed ")
                return
            }
            // place image in firebase database
            let filename = NSUUID().uuidString
            //print("image filename :\(filename)")
            let riversRef = Storage.storage().reference().child("profile_image").child(filename)
            //print("riverRef:\(riversRef)")
            riversRef.putData(uploadata, metadata: nil, completion: { (metadata, error ) in
                print("into put data")
                //handle error
                if let error = error{
                    //self.alert(message: error.localizedDescription)
                    print("failed to upload image to firebase storage", error.localizedDescription )
                }
              
               //
               riversRef.downloadURL(completion: { (url, error) in
                    print("into download url")
                    guard let profileImgUrl =  url?.absoluteString else{
                        //self.alert(message: String(describing: error?.localizedDescription))
                        print("url error: \(String(describing: error?.localizedDescription))")
                        return
                        
                    }
                    //imageurl = profileImgUrl
                    //print("profileImgUrl:\(profileImgUrl)")

                    guard let uid = user?.user.uid else { return }
                    let dic : [String : Any] = ["name": fullname,
                           "username": username,
                           "profileImgUrl": profileImgUrl]

                    let value = [uid : dic]

                    // SAVE INFO TO DATABASE
                    Database.database().reference().child("users").updateChildValues(value) { (error, ref) in
                        //self.alert(message: "Successfully create user and save info!")
                        print("Successfully create user and save info!")
                        let alert = UIAlertController(title: "Notice", message: "Successfully SignUp", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                    
                    
                })
                
            })
        
            
            
        //
        print("successfully create new user with firebase")
             
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
