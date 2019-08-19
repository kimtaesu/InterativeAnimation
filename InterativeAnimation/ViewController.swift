//
//  ViewController.swift
//  InterativeAnimation
//
//  Created by tskim on 19/08/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nonInteractive: UIView!
    @IBOutlet weak var interactive: UIView!
    lazy var interactiveAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    override func viewDidLoad() {
        super.viewDidLoad()
        nonInteractive.backgroundColor = UIColor.blue
        nonInteractive.isUserInteractionEnabled = true
        nonInteractive.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nonInteractiveTap)))
        
        interactive.backgroundColor = UIColor.yellow
        interactive.isUserInteractionEnabled = true
        interactive.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    
    @objc
    func nonInteractiveTap() {
        UIView.animate(withDuration: 1, animations: {
            self.nonInteractive.transform = CGAffineTransform(translationX: self.view.frame.maxX - 200, y: 0)
        })
    }
    
    @objc
    func interactiveTap() {
        
    }
    @objc
    func pan(_ g:UIScreenEdgePanGestureRecognizer) {
        switch g.state {
        case .began:
            if interactiveAnimator.isRunning {
                interactiveAnimator.stopAnimation(true)
            }
            
            interactiveAnimator.addAnimations {
                self.interactive.transform = CGAffineTransform(translationX: self.view.frame.maxX - 200, y: 0)
            }
            interactiveAnimator.pauseAnimation()
        case .changed:
            let v = g.view!
            let delta = g.translation(in:v)
            let percent = abs(delta.x/v.bounds.size.width)
            print("percent: \(percent)")
            interactiveAnimator.fractionComplete = percent
        case .ended:
            interactiveAnimator.pauseAnimation()
            
            if interactiveAnimator.fractionComplete < 0.5 {
                interactiveAnimator.isReversed = true
            }
            interactiveAnimator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve:.linear), durationFactor: 0.2)
            
        case .cancelled:
            interactiveAnimator.pauseAnimation()
            interactiveAnimator.stopAnimation(false)
            interactiveAnimator.finishAnimation(at: .start)
        default: break
        }
    }
}

