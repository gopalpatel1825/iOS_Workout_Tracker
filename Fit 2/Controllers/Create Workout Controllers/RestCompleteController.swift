//
//  RestCompleteController.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/11/25.
//

import UIKit

class RestCompleteController: UIViewController {
    
    var sender: UIViewController?

    @IBOutlet var backView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        backView.addGestureRecognizer(tapGesture)
       
    }

}

extension RestCompleteController {
    
    // Makes configures the view and makes the background dim
    func configView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.contentView.alpha = 1
        self.contentView.layer.cornerRadius = 10

    }
    
    func appear(sender: UIViewController) {
        sender.presentPopup(self)
        self.sender = sender
        DispatchQueue.main.async {
            self.configView()
        }
    }
    
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion:  {_ in
            DispatchQueue.main.async {
                self.sender!.view.alpha = 1
                self.dismissPopup()
            }
            self.removeFromParent()
        
        }
    }
    
}
