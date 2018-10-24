//
//  ViewController.swift
//  CanvasLab
//
//  Created by Sanaz Khosravi on 10/21/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat! = nil
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var open = true
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
           trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    self.trayView.center = self.trayDown!
                    self.open = false
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
                    self.trayView.center = self.trayUp!
                    self.open = false
                }, completion: nil)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 260
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        commonFacePan(sender: sender, original: true)
        
    }
    
    
    func commonFacePan(sender: UIPanGestureRecognizer, original: Bool){
        let translation = sender.translation(in: view)
        if sender.state == .began {
            if original{
                let imageView = sender.view as! UIImageView
                newlyCreatedFace = UIImageView(image: imageView.image)
                view.addSubview(newlyCreatedFace)
                newlyCreatedFace.center = imageView.center
                newlyCreatedFace.center.y += trayView.frame.origin.y
                newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            }else{
                newlyCreatedFace = sender.view as! UIImageView
            }
            
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {

            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onCopyFacePanRecognizer(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGesture)
            newlyCreatedFace.isUserInteractionEnabled = true
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(sender:)))
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
        }
    }
    
    
    @objc func onCopyFacePanRecognizer(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
        }
    }
    
    @objc func onPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        sender.view!.transform = CGAffineTransform(scaleX: scale, y: scale)

    }
    
}

