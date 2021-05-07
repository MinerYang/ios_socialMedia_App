//
//  SelectImageViewController.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/12/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "PhotoCell"
private let headerIdentifier = "PhotoHeaderCell"

class SelectImageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //  MARK: -properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: SelectPhotoHeaderCell?
    
    // MARK: -load view
    override func viewDidLoad() {
        super.viewDidLoad()
        print("into select image view controller")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.register(SelectPhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
            
        collectionView!.register(SelectPhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PhotoHeaderCell")

        // Do any additional setup after loading the view.
        configureNavigationBtn()
        
        // fetch photo
        fetchPhotos()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    func configureNavigationBtn(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain , target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    // MARK: -UICollectionViewFlowLatout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 4 parts and 3 seprate spacing
        let width  = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("images count:\(images.count)")
        return images.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPhotoCell
    
        // Configure the cell
        cell.photoImageView.image = images[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoHeaderCell", for: indexPath) as! SelectPhotoHeaderCell
        
        self.header = header
        
        // configure
//        if let selectImg = self.selectedImage{
//            header.photoImageView.image = selectImg
//        }
        // using associated asset to make the img  with proper reso lution
        if let selectedImage = self.selectedImage {

            // index selected image
            if let index = self.images.firstIndex(of: selectedImage) {

                // asset associated with selected image
                let selectedAsset = self.assets[index]

                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)

                // request image
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    header.photoImageView.image = image
                })
            }
        }

            return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        // scorll back to the top
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: -Handlers
    @objc func handleCancel(){
        //self.dismiss(animated: true, completion: nil)
        let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainST.instantiateViewController(withIdentifier: "idTabBar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleNext(){
        print("click handle next button")
        let uploadPostVC = UploadPostViewController()
        uploadPostVC.selectedImage =  header?.photoImageView.image
        print(uploadPostVC.selectedImage == nil)
        self.navigationController?.pushViewController(uploadPostVC, animated: true)
    }
    
    // fetch photos from PHAssets
    func fetchPhotos(){
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        // enumerate objects
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                print(" count is \(count)")
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true

                // request image representation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image{
                        // append image to data source
                        self.images.append(image)
                        print("images append count\(self.images.count)")

                        // append asset to data source
                        self.assets.append(asset)

                        // set selected image with first image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }

                        // reload collection view once images count has completed
                        // from 0 to zero
                        if count == allPhotos.count - 1{
                            // reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }


    }
 
    
    func getAssetFetchOptions() -> PHFetchOptions{
        let options = PHFetchOptions()
        // fetch limit
        options.fetchLimit = 45
        // sort photo by dates
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        // set sort sortDescriptors for options
        options.sortDescriptors = [sortDescriptors]
        return options
    }

}
