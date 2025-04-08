//
//  NewFolderPopup.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/24/25.
//

import UIKit

class NewFolderPopup: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var sender: HomeController?
    
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        backView.addGestureRecognizer(tapGesture)
        
        manageSaveButton()
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        let context = coreDataHelper.mainContext
        let folder = Folder(context: context)
        folder.name = textField.text ?? ""
        do {
            try context.save()
        } catch {
            print("Could not save new folder to main context \(error)")
        }
        self.hide2() {
            DispatchQueue.main.async {
                self.sender!.reloadFolders()
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.hide()
    }
    
    func manageSaveButton() {
        if textField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
}

extension NewFolderPopup: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        manageSaveButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        manageSaveButton()
    }
    
}

extension NewFolderPopup {
    
    // Makes configures the view and makes the background dim
    func configView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.contentView.alpha = 1
        self.contentView.layer.cornerRadius = 10

    }
    
    func appear(sender: UIViewController) {
        sender.presentPopup(self)
        self.sender = sender as? HomeController
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
    
    @objc func hide2(completion: @escaping () -> Void) {
        self.sender?.view.alpha = 1
        self.dismissPopup() {
            self.removeFromParent()
            completion()
        }
    }
    
}
