//
//  FloatAlertView.swift

//  Created by Navpreet Kailay on 21/09/22.
//  Copyright © 2022 All rights reserved.

import UIKit

class FloatAlertView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(){
        Bundle.main.loadNibNamed("FloatAlertView", owner: self, options: nil)
    addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func removeAlert(){
        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseInOut) {
            self.frame.origin.y -= self.bounds.height
        } completion: { done in
            self.removeFromSuperview()
        }

    }
    

}
