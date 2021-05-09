//
//  ViewController.swift
//  Project1
//
//  Created by dawum nam on 4/28/21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    var picturesViewCount = [Int]()
    
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
                picturesViewCount.append(0)
            }
        }
        pictures.sort()
        
        let defaults = UserDefaults.standard
        if let savedViewData = defaults.object(forKey: "viewCount") as? [Int]{
            picturesViewCount = savedViewData
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
            vc.imgNum = indexPath.item
            vc.imgsTotalNum = pictures.count
            picturesViewCount[indexPath.item] += 1
            let defaults = UserDefaults.standard
            defaults.set(picturesViewCount, forKey: "viewCount")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.gray.cgColor
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width:cell.frame.width, height: 30))
        messageLabel.text = pictures[indexPath.row]
        messageLabel.textAlignment = .center
        
        let viewsCountLabel = UILabel(frame: CGRect(x: 0, y: 64, width:cell.frame.width, height: 30))
        let count = picturesViewCount[indexPath.item]
        viewsCountLabel.text = "Viewd \(count) times."
        viewsCountLabel.textAlignment = .center

        cell.addSubview(viewsCountLabel)
        cell.addSubview(messageLabel)
        return cell
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Hey my project 1 is great!!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for cell in self.collectionView.visibleCells {
            for subView in cell.subviews {
                if type(of: subView) == UILabel.self {
                    if let label = subView as? UILabel {
                        label.text = ""
                    }
                    
                }
            }
        }
        collectionView.reloadData()
        
    }
}

