//
//  ViewController.swift
//  Project1
//
//  Created by dawum nam on 4/28/21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        // Do any additional setup after loading the view.
        
        performSelector(inBackground: #selector(fetchImage), with: nil)
    }
    
    @objc func fetchImage() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.imgNum = indexPath.row
            vc.imgsTotalNum = pictures.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.gray.cgColor
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width:cell.frame.width, height: 128))
        messageLabel.text = pictures[indexPath.row]
        messageLabel.textAlignment = .center
        cell.addSubview(messageLabel)
        return cell
        
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Hey my project 1 is great!!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }


}

