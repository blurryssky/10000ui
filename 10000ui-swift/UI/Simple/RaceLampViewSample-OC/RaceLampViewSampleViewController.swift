//
//  RaceLampViewSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 29/09/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class RaceLampViewSampleViewController: UIViewController {
    
    @IBOutlet weak var raceLampView: BSRaceLampView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let attrString = NSMutableAttributedString(string: "Design is not just what it looks like and feels like. Design is how it works.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black])
        let range = (attrString.string as NSString).range(of: "Design")
        if (range.location != NSNotFound) {
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
        }
        raceLampView.attributedText = attrString
        
        raceLampView.stayTimeInterval = 1
        raceLampView.velocity = 100
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        let isRunning = raceLampView.velocity == 100
//        raceLampView.velocity = isRunning ? 0 : 100
//    }
}
