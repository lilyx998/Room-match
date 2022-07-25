//
//  ConfettiAnimation.swift
//  Roommatch
//
//  Created by Lily Yang on 7/22/22.
//

import Foundation
import UIKit

@objcMembers
public class ConfettiAnimation : NSObject {
    func playMatchAnimationForView(_ view: UIView){
        let layer = CAEmitterLayer();
        layer.emitterPosition = CGPoint(
            x: view.center.x,
            y: -100
        )
        
        let colors: [UIColor] = [
            .systemCyan, .systemMint, .systemPink, .systemYellow, .systemOrange, .systemGreen
        ]
        
        let cells: [CAEmitterCell] = colors.compactMap {
            let cell = CAEmitterCell();
            cell.scale = 0.15;
            cell.birthRate = 100;
            cell.velocity = 200;
            cell.contents = UIImage(named: "confetti")!.cgImage;
            cell.emissionRange = .pi * 3;
            cell.lifetime = 100;
            cell.color = $0.cgColor;
            return cell;
        }
        
        layer.emitterCells = cells;
        view.layer.addSublayer(layer);
        
        let seconds = 1.8;
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            layer.removeFromSuperlayer();
        }
    }

}
