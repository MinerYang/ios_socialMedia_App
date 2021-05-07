//
//  LoginVC.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/6/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 5
        let attributetitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributetitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor:UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        SignUpBtn.setAttributedTitle(attributetitle, for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
