//
//  Extensions.swift
//  BookSearchDemo
//
//  Created by Ejaz on 14/03/22.
//

import UIKit

extension Int {
    var str: String { "\(self)" }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 12)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restoreEmptyMessage() {
        self.backgroundView = nil
    }
    
}

func ShowHUD() {
    let actInd = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let activity = UIActivityIndicatorView()
    actInd.addSubview(activity)
    actInd.tag = 134523452345
    actInd.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    activity.style = .medium
    if let Window = UIApplication.shared.keyWindow {
        Window.addSubview(actInd)
        DispatchQueue.main.async {
            actInd.frame = UIScreen.main.bounds
        }
        actInd.sizeToFit()
        Window.bringSubviewToFront(actInd)
        actInd.center = Window.center
        activity.center = actInd.center
    }
    activity.startAnimating()
}

func HideHUD() {
    if let Window = UIApplication.shared.keyWindow {
        for actView in Window.subviews where actView.tag == 134523452345 {
            actView.removeFromSuperview()
        }
    }
}

