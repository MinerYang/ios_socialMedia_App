//
//  UploadPostViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/13/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController, UITextViewDelegate {
    
    // MARK: properties
    var selectedImage : UIImage?
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let desTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.clipsToBounds = true
        return tv
    }()
    
    let publishButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor =  UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.setTitle("Publish", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(HandlePublishPost ), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        configureViewComponents()
        // load image
        loadImage()
        
        // set text view delegate
        desTextView.delegate =  self
        
        //photoImageView.image = self.selectedImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configureViewComponents(){
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(desTextView)
        desTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil , right: view.rightAnchor , paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(publishButton)
        publishButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24 , width: 0, height: 40)
    }
    
    func loadImage(){
        guard self.selectedImage != nil else { return }
        photoImageView.image = selectedImage
    }
    
    // MARK: -TextView
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            publishButton.isEnabled = false
            publishButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        publishButton.isEnabled = true
        publishButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    
    // MARK: -Handler
    @objc func HandlePublishPost(){
        print("click publish")
        // parameters
        guard
            let description = desTextView.text,
            let postImg = photoImageView.image,
            let currentUid = Auth.auth().currentUser?.uid else{
                return
        }

        // image upload data
        guard let uploaddata = postImg.jpegData(compressionQuality: 0.5) else {  return }

        // creation date
        let creationDate = Int(NSDate().timeIntervalSince1970)

        // update storage
        let filename = NSUUID().uuidString
        let postRef = Storage.storage().reference().child("post_images").child(filename)
        postRef.putData(uploaddata, metadata: nil) { (metadata, error) in
            //error
            if let error = error {
                print(error.localizedDescription )
            }

            // image url
            //var imageurl = ""
            postRef.downloadURL { (url, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let abstr = url?.absoluteString else{
                    print("failed to get image url absolute string")
                    return
                }
                // post data
                let values = ["description": description,
                              "creationDate": creationDate,
                              "likes": 0,
                              "imageUrl": abstr,
                              "ownerUid": currentUid] as [String : Any]
                // post id
                let postid = POSTS_REF.childByAutoId()
                guard let postkey = postid.key else{return}
                // upload to database
                postid.updateChildValues(values) { (error, ref) in
                    //print("postid key:\(String(describing: [postid.key]))")
                     
                    // update user-post structure
                    let userPostsRef = USER_POSTS_REF.child(currentUid)
                    userPostsRef.updateChildValues([postkey: 1])
                    
                    // return to home page
                    let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc: UITabBarController = mainST.instantiateViewController(withIdentifier: "idTabBar") as! UITabBarController
                    vc.selectedIndex = 4
                    
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }

            }
            //

        }
        
    }

}
