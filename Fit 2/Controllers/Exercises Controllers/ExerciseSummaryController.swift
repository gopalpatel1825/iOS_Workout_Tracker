//
//  ExerciseSummaryController.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/17/25.
//

import UIKit
import CoreData

class ExerciseSummaryController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    var exercise: Exercise?
    
    var steps: [Step] = []
    
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: "AppIcon")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ExerciseStepCell", bundle: nil), forCellReuseIdentifier: "ExerciseStepCell")
        
        fetchSteps()
        
    }
    
    
    @IBAction func viewPRsPressed(_ sender: UIButton) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mainStoryboard.instantiateViewController(withIdentifier: "ExerciseRecordsControllers") as! ExerciseRecordsControllers
    
        destination.exercise = self.exercise
        
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func fetchSteps() {
        print("called fetch steps")
        let stepsFetchRequest = NSFetchRequest<Step>(entityName: "Step")
        stepsFetchRequest.predicate = NSPredicate(format: "exercise == %@", self.exercise!)
        let context = coreDataHelper.mainContext
        
        do {
            steps = try context.fetch(stepsFetchRequest)
            print("\(steps.count) steps fetched")
            tableView.reloadData()
        } catch {
            print("Could not fetch steps for exercise")
        }
        
    }
    
}

extension ExerciseSummaryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseStepCell", for: indexPath) as! ExerciseStepCell
        let step = steps[indexPath.row]
        cell.step = step
        
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.stepLabel.text = step.details
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.estimatedRowHeight
    }

    
}

extension ExerciseSummaryController: UIScrollViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        tableView.removeObserver(self, forKeyPath: "contentSize")
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "contentSize") {
            if (object is UITableView) {
                
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewHeight.constant = newSize.height
                    self.contentViewHeight.constant = newSize.height + 35 + 200 + 8
                }
                    
            }
        }
        
    }
    
}
