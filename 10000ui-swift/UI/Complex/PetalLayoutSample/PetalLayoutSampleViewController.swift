//
//  PetalLayoutSampleViewController.swift
//  10000ui-swift
//
//  Created by blurryssky on 2018/1/24.
//  Copyright © 2018年 blurryssky. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "PetalLayoutSampleCollectionCell"

class PetalLayoutSampleViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var deleteBarButtonItems: [UIBarButtonItem]!
    @IBOutlet var barButtonItems: [UIBarButtonItem]!
    
    fileprivate var items = 0 {
        didSet {
            let canDelete = isEnable && items != 0
            deleteBarButtonItems.forEach({ $0.isEnabled = canDelete })
        }
    }
    fileprivate var layout: PetalLayout!
    
    fileprivate var isEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        items = 0
        layout = collectionView.collectionViewLayout as? PetalLayout
        layout.isAutoFocusEnabled = true
//        layout.isClockwise = false
    }
}

fileprivate extension PetalLayoutSampleViewController {
    
    func enableBarButtonItems() {
        isEnable = true
        barButtonItems.forEach({ $0.isEnabled = true })
    }
    
    func disableBarButtonItems() {
        isEnable = false
        barButtonItems.forEach({ $0.isEnabled = false })
    }
    
    @IBAction func handleAddBarButtonItem(_ sender: UIBarButtonItem) {
        
        items += 1
        let indexPath = IndexPath(item: items - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    @IBAction func handleRedAddBarButtonItem(_ sender: UIBarButtonItem) {
        
        let randomIncreasement = Int(arc4random()%6)
        items += randomIncreasement
        
        var indexPaths: [IndexPath] = []
        for _ in 0..<randomIncreasement {
            let item = Int(arc4random())%items
            let indexPath = IndexPath(item: item, section: 0)
            indexPaths.append(indexPath)
        }
        collectionView.insertItems(at: indexPaths)
    }
    
    @IBAction func handleBlackAddBarButtonItem(_ sender: UIBarButtonItem) {
        
        disableBarButtonItems()
        
        let increasement = 6
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue(label: "com.blurryssky.blackadd")
        queue.async {
            for index in 0..<increasement {
                DispatchQueue.main.async {
                    self.items += 1
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: [indexPath])
                    }, completion: { (_) in
                        semaphore.signal()
                    })
                }
                semaphore.wait()
            }
            DispatchQueue.main.async {
                self.enableBarButtonItems()
            }
        }
    }
    
    @IBAction func handleTrashBarButtonItem(_ sender: UIBarButtonItem) {
        items -= 1
        let indexPath = IndexPath(item: items, section: 0)
        collectionView.deleteItems(at: [indexPath])
    }
    
    @IBAction func handleRedTrashBarButtonItem(_ sender: UIBarButtonItem) {
        
        let randomDecreasement = min(max(1, Int(arc4random()%6)), items)
        items -= randomDecreasement
        
        var indexPaths: [IndexPath] = []
        for index in items..<(items + randomDecreasement) {
            let indexPath = IndexPath(item: index, section: 0)
            indexPaths.append(indexPath)
        }
        collectionView.deleteItems(at: indexPaths.reversed())
    }
    
    @IBAction func handleBlackTrashBarButtonItem(_ sender: UIBarButtonItem) {

        disableBarButtonItems()
        
        let beforeItems = items
        let decreasement = 6
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue(label: "com.blurryssky.blacktrash")
        queue.async {
            for index in 0..<min(beforeItems, decreasement) {
                DispatchQueue.main.async {
                    self.items -= 1
                    let indexPath = IndexPath(item: beforeItems - index - 1, section: 0)
                    self.collectionView.performBatchUpdates({
                        self.collectionView.deleteItems(at: [indexPath])
                    }, completion: { (_) in
                        semaphore.signal()
                    })
                }
                semaphore.wait()
            }
            
            DispatchQueue.main.async {
                self.enableBarButtonItems()
            }
        }
    }
}

extension PetalLayoutSampleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension PetalLayoutSampleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PetalLayoutSampleCollectionCell
        cell.layer.cornerRadius = layout.itemSize.width/2
        return cell
    }
}
