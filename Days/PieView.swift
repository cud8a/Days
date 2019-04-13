//
//  PieView.swift
//  Days
//
//  Created by Tamas Bara on 11.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

class PieView: UIView {

    let colorBack = UIColor(named: "green")?.withAlphaComponent(0.7)
    let color = UIColor.white.withAlphaComponent(0.9)
    
    var ratio: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ratio = ratio else {return}
        
        colorBack?.setStroke()
        let lineWidth = CGFloat(22)
        let radius = rect.width/2 - 20
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
        
        color.setStroke()
        let endAngle = ratio * 2 * CGFloat.pi - CGFloat.pi/2
        let path2 = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: -CGFloat.pi/2, endAngle: endAngle, clockwise: true)
        path2.lineWidth = lineWidth
        path2.stroke()
    }
}
