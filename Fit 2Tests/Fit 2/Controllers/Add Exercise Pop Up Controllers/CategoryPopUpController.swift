//
//  CategoryPopUp.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/2/25.
//

import UIKit

class CategoryPopUpController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var sender: AddExercisePopUpController?
    
    // All of the possible categories to choose from
    let categories: [String] = ["Barbell", "Dumbell", "Machine", "Kettlebell", "Weighted Bodyweight", "Assisted Bodyweight",
    "Reps Only", "Cardio", "Duration", "Other"]
    
    init() {
        super.init(nibName: "CategoryPopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension CategoryPopUpController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // Each category will have a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    // When a cell is selected, set the categoryLabel of the addExercisePopup to the selected category
    // Then, hide the popup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sender?.categoryLabel.text = categories[indexPath.row]
        self.hide()
    }
}

// MARK - Popup methods

extension CategoryPopUpController {
    
    // Configures the popup and makes the background dim
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
        self.backView.alpha = 0.0
        self.contentView.alpha = 1
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
