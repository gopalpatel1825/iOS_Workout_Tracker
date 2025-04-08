//
//  ExercisesRootController.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/17/25.
//

import UIKit

class ExercisesRootController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    var exercise: Exercise?
    
    
    
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
    }
    
    func configure() {
        
        titleLabel.text = exercise?.name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        configure()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseSummaryController") as! ExerciseSummaryController
        firstChildTabVC.exercise = self.exercise
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ExercisesHistoryController") as! ExercisesHistoryController
        secondChildTabVC.exercise = self.exercise
        return secondChildTabVC
    }()
    
    lazy var thirdChildTabVC : UIViewController? = {
        let thirdChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ExercisesChartsController") as! ExercisesChartsController
        thirdChildTabVC.exercise = self.exercise
        return thirdChildTabVC
    }()
    
    
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
            
            self.currentViewController!.view.removeFromSuperview()
            self.currentViewController!.removeFromParent()
            
            displayCurrentTab(sender.selectedSegmentIndex)
        
    }
    
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
            
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
            
        case TabIndex.thirdChildTab.rawValue :
            vc = thirdChildTabVC
            
        default:
            return nil
        }
        
        return vc
    }
    
    
    func displayCurrentTab(_ tabIndex: Int){
        
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    
    
    
}

