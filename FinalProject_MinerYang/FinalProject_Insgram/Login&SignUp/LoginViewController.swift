//
//  LoginViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/6/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var PswTXT: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        LoginBtn.isEnabled = false
        LoginBtn.layer.cornerRadius = 5
        setSignUpButton()
        self.emailTXT.delegate = self
        self.PswTXT.delegate = self
        
        emailTXT.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        PswTXT .addTarget(self, action: #selector(formValidation), for: .editingChanged)
       
    }
    
    func setSignUpButton(){
        let attributetitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributetitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor:UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        SignUpBtn.setAttributedTitle(attributetitle, for: .normal)

    }
    
    @objc func formValidation(){
        guard emailTXT.hasText, PswTXT.hasText else{
            LoginBtn.isEnabled = false
            LoginBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        //
        LoginBtn.isEnabled = true
        LoginBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    
    
    @IBAction func handleLoginBtn(_ sender: UIButton) {
        print("click login button")
        Auth.auth().signIn(withEmail: emailTXT.text!, password: PswTXT.text!) { (user, error) in
                   // handle error
                   if let error = error {
                        print("unable to Login with error:\(error.localizedDescription)")
                    self.alert(message: error.localizedDescription)
                        return
                    }
            
            print("Successfully Login!")
            let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
            let VC = mainST.instantiateViewController(withIdentifier: "idTabBar")
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)

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

    @IBAction func handleSignUp(_ sender: UIButton) {
        print("click sign up button")
        SignUpBtn.isHighlighted = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("press done")
        textField.resignFirstResponder()
        //onCommit(textField.text ?? "")
        return true
    }
}
