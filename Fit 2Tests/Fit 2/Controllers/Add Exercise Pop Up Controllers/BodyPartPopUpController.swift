//
//  bodyPartPopUp.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/2/25.
//

import UIKit

class BodyPartPopUpController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    var sender: AddExercisePopUpController?
    
    // All of the possible body parts to choose
    let bodyParts: [String] = ["Core", "Arms", "Back", "Chest", "Legs", "Shoulders", "Other", "Olympic", "Full Body",
    "Cardio"]
    
    init() {
        super.init(nibName: "BodyPartPopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideAll))
                backView.addGestureRecognizer(tapGesture)
        
    }
    

    @IBAction func backPressed(_ sender: UIButton) {
        self.hide()
    }
    
}

    // MARK - Tableview Methods

extension BodyPartPopUpController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyParts.count
    }
    
    // One tableview cell for each body part
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bodyParts[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    // When a cell is selected, set the bodyPartLabel of the addExercisePopup to the selected body part
    // Then hide the popup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sender?.bodyPartLabel.text = bodyParts[indexPath.row]
        self.hide()
    }
}

// MARK - Popup methods

extension BodyPartPopUpController {
    
    // Configure the view and make the background dim
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController) {
        self.sender = sender as? AddExercisePopUpController
        self.sender!.present(self, animated: false)
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.backView.alpha = 0.0
            self.contentView.alpha = 1
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion:  {_ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    @objc func hideAll() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion:  {_ in
            self.sender!.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
}
