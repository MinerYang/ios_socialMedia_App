//
//  EditCommentViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/15/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class EditCommentViewController: UIViewController ,UITextViewDelegate{

   //var post : Post?
   var postId: String?
    var postOwner : User? {
        didSet{
            guard let url = postOwner?.profileImageUrl else {return}
            profileImageView.loadImage(with: url)
        }
    }
   
   override func viewDidLoad() {
       super.viewDidLoad()
       navigationItem.title = "Comments"
       view.backgroundColor = .white
       //
       configureViewComponents()
       // Do any additional setup after loading the view.
       commentsTextView.delegate =  self
       
       
   }
   
   // MARK: PROPERTIES
   let profileImageView: CustomImageView = {
       let iv = CustomImageView()
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       iv.backgroundColor = .lightGray
       return iv
   }()
   
   let commentsTextView : UITextView = {
       let tv = UITextView()
       tv.backgroundColor = UIColor.systemGroupedBackground
       tv.font = UIFont.systemFont(ofSize: 12)
       tv.clipsToBounds = true
       return tv
   }()
   
   let commentButton : UIButton = {
       let btn = UIButton(type: .system)
       btn.backgroundColor =  UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
       btn.setTitle("Comment", for: .normal)
       btn.setTitleColor(.white, for: .normal)
       btn.layer.cornerRadius = 5
       btn.isEnabled = false
       btn.addTarget(self, action: #selector(HandleCommentPost), for: .touchUpInside)
       return btn
   }()
   
   func configureViewComponents(){
       view.addSubview(profileImageView)
       profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
       profileImageView.layer.cornerRadius = 100 / 2
       
       view.addSubview(commentsTextView)
       commentsTextView.anchor(top: view.topAnchor, left: profileImageView.rightAnchor, bottom: nil , right: view.rightAnchor , paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
       
       view.addSubview(commentButton)
       commentButton.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24 , width: 0, height: 40)
   }
   
   // MARK: -TextView
   func textViewDidChange(_ textView: UITextView) {
       guard !textView.text.isEmpty else {
           commentButton.isEnabled = false
           commentButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
           return
       }
       commentButton.isEnabled = true
       commentButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
   }
   

   /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */
   
   // MARK: Handeller
   @objc func HandleCommentPost(){
       //print("click comment button")
       guard let postid = self.postId else{return}
       guard let commenttext = commentsTextView.text else{
           // alert
           let alert = UIAlertController(title: "Alert", message: "Please input some comments", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true)
           return
       }
       guard let uid = Auth.auth().currentUser?.uid else{return}
       let creationDate = Int(NSDate().timeIntervalSince1970 )
       
       //
       let values = ["commentText": commenttext,
                     "creationDate": creationDate,
                     "uid": uid] as [String : Any]
       COMMENT_REF.child(postid).childByAutoId().updateChildValues(values)
       //
       let alertController = UIAlertController(title: "Notice", message: "Comment Successfully", preferredStyle: .alert)
       let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
       self.present(alertController, animated: true, completion: nil)
       self.commentsTextView.text = ""
   }


}
