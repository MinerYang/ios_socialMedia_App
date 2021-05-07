//
//  Helper.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/6/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

class HighlightedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ?  UIColor(red: 166/255, green: 147/255, blue: 252/255, alpha: 0.75) : UIColor.white
            // 166 147 252
        }
    }
}

@IBDesignable class RoundButton: UIButton {

     @IBInspectable var radius : CGFloat = 10
     @IBInspectable var borderWidth : CGFloat = 4
     //@IBInspectable var backColor : UIColor = UIColor.blue

     override init(frame: CGRect) {
          super.init(frame: frame)
          setButton()
     }

     override func prepareForInterfaceBuilder() {     // To make sure IB redraws
          super.prepareForInterfaceBuilder()
          //backgroundColor = backColor // colorSunset
          self.layer.cornerRadius = radius
          self.layer.borderWidth = borderWidth
     }


     required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          setButton()
     }

     func setButton() {
          self.layer.cornerRadius = radius     // Or whatever value you like in IB
          self.layer.borderWidth = borderWidth
          //self.layer.backgroundColor = backColor.cgColor
     }

}

//func alert(vc : UIViewController, msg : String){
//    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//    vc.present(alert, animated: true,completion: nil)
//}
//extension UIViewController {
//  func alert(message: String) {
//    let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
//    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alertController.addAction(OKAction)
//    self.present(alertController, animated: true, completion: nil)
//  }
//}

extension UIViewController {

    func alert(message: String) {
     let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
//     let action = alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//       alertAction in
//        self.performSegue(withIdentifier: segueid, sender:self)
//       //callback()
//     }))
    let action = UIAlertAction(title:"OK",
                                    style:.default) { (UIAlertAction) -> Void in
        // HERE you perform the segue to your LoginVC,
        // or do whatever else you wanna do when the user clicked "Login" :)
        // for example:
        //self.performSegue(withIdentifier: "loginToTabbar", sender:self)
    }
    DispatchQueue.main.async{
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        //self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
   }

   //add additional functions here if necessary
   //like a function showing alert with cancel
}

//extension UIAlertController {
//    func show() {
//        let win = UIWindow(frame: UIScreen.main.bounds)
//        let vc = UIViewController()
//        vc.view.backgroundColor = .clear
//        win.rootViewController = vc
//        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
//        win.makeKeyAndVisible()
//        vc.present(self, animated: true, completion: nil)
//    }
//}


func presentAlertWithTitleAndMessage(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for (index, option) in options.enumerated() {
        alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
            completion(index)
        }))
    }
    topMostViewController().present(alertController, animated: true, completion: nil)
}
func topMostViewController() -> UIViewController {
    //let key = windows.filter {$0.isKeyWindow}.first
    var topViewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    while ((topViewController?.presentedViewController) != nil) {
        topViewController = topViewController?.presentedViewController
    }
    return topViewController!
}

//var imagecache = [String : UIImage]()
//extension UIImageView{
//    func loadImage(with urlString : String){
//        if let cachedImage = imagecache[urlString]{
//            self.image = cachedImage
//            return
//        }
//        
//        // image not exist
//        guard let url = URL(string: urlString) else{
//            print("image not exist")
//            return
//            
//        }
//        // fetch
//         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error{
//                print(error.localizedDescription )
//            }
//            
//            // image
//            guard let imagedata = data else{ return }
//            // set image
//            let photo = UIImage(data: imagedata)
//            imagecache[url.absoluteString] = photo
//            DispatchQueue.main.async {
//                self.image = photo
//            }
//        }
//        task.resume() 
//    }
//}

extension Database {
    
    static func fetchUser(with uid: String, completion: @escaping(User) -> ()) {
        
        USER_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchPost(with postId: String, completion: @escaping(Post) -> ()) {
        
        POSTS_REF.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }
            
            Database.fetchUser(with: ownerUid, completion: { (user) in
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                completion(post)
            })
        }
    }
}
