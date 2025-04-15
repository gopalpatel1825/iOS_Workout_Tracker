//
//  TemplateEditorHeaderCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/8/25.
//

import UIKit

class TemplateEditorHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var template: Template? { didSet {manageSaveButton()} }
    
    var templateEditor: CreateTemplateController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    func configure() {
        let name = template?.name!
        textField.text = name
    }
    
}

extension TemplateEditorHeaderCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        manageSaveButton()
    }
    
    func manageSaveButton() {
        if textField.text == "" {
            textField.placeholder = "Enter a Template Name"
            templateEditor?.saveButton.isEnabled = false
        } else {
            self.template?.name = textField.text
            templateEditor?.saveButton.isEnabled = true
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        manageSaveButton()
    }
    
}
