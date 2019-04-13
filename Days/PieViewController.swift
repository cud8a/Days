//
//  PieViewController.swift
//  Days
//
//  Created by Tamas Bara on 11.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

class PieViewController: UIViewController {

    var ratio: CGFloat? {
        didSet {
            pieView?.ratio = ratio
        }
    }
    
    var pieView: PieView? {
        return view as? PieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieView?.ratio = ratio
    }
}
