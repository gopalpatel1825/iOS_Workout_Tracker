//
//  TabBarController.swift
//  Fit 2
//
//  Created by Gopal Patel on 1/31/25.
//

import UIKit
import CoreData

class TabBarController: UITabBarController  {
    
    let coreDataHelper = CoreDataHelper.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:tabBarController!.tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.yellow
        tabBarController!.tabBar.addSubview(lineView)
    }
    
    
}


