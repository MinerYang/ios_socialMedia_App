//
//  MainTabViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/8/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewController.index(ofAccessibilityElement: viewController)
        
        if(index == 2){
            let selectImageVc =  SelectImageViewController(collectionViewLayout: UICollectionViewFlowLayout())
            let navControlller = UINavigationController(rootViewController: selectImageVc)
            self.present(navControlller, animated: true, completion: nil )
            return false
        }
        return true
    }

}
