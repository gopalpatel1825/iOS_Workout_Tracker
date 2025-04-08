//
//  StartWorkoutPopup.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/22/25.
//

import UIKit

class StartWorkoutPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lastCompletedLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sender: HomeController!
    
    var template: Template!
    
    var exercises: [WorkoutExercise] {
        let exerciseArray = template.exercises!.array as! [WorkoutExercise]
        return exerciseArray
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WorkoutPopupExerciseCell", bundle: nil), forCellReuseIdentifier: "WorkoutPopupExerciseCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
                backView.addGestureRecognizer(tapGesture)
    }
    
    init() {
        super.init(nibName: "StartWorkoutPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.hide()
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func startWorkoutPressed(_ sender: UIButton) {
        print("Start workout button pressed")
        self.hide2() {
            DispatchQueue.main.async {
                self.sender.presentWorkoutEditor(template: self.template)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutPopupExerciseCell", for: indexPath) as! WorkoutPopupExerciseCell
        cell.exercise = exercises[indexPath.row]
        cell.configure()
        
        return cell
    }
    
    
    
    func appear(sender: UIViewController) {
        sender.presentPopup(self)
        self.show()
        self.sender = sender as? HomeController
        self.sender!.view.alpha = 0.5
        DispatchQueue.main.async {
            self.configView()
        }
    }
    
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.alpha = 1
        self.contentView.alpha = 1
        self.contentView.layer.cornerRadius = 10
    }
    
    private func show() {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            self.contentView.layer.cornerRadius = 20
    }
    
    @objc func hide() {
            self.sender.view.alpha = 1
            self.dismissPopup()
    }
    
    @objc func hide2(completion: @escaping () -> Void) {
        self.sender.view.alpha = 1
        self.dismissPopup() {
            self.removeFromParent()
            completion()
        }
    }
    
    func configure() {
        titleLabel.text = template.name
    }
    
}

