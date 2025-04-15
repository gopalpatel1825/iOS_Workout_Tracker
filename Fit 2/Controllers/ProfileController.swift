//
//  ProfileController.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/12/25.
//

import Foundation
import UIKit
import CoreData
import DGCharts


class ProfileController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var numWorkoutsChart: BarChartView!
    
    
    var weekDates: [Date] = []
    
    var workoutData: [Date : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numWorkoutsChart.delegate = self
        
        fetchWorkoutData()
        
        setApperance()
        
        numWorkoutsChart.clipsToBounds = true
    }
    
    
    
    func fetchWorkoutsBetween(startDate: Date, endDate: Date) -> Int {
        let context = CoreDataHelper.shared.mainContext
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        // Predicate for filtering between two bounds
        fetchRequest.predicate = NSPredicate(format: "startDate >= %@ AND startDate <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            let results = try context.count(for:fetchRequest)
            print("\(results) workouts between \(startDate) and \(endDate)")
            return results
        } catch {
            print("Error fetching workouts: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    
    func fetchWorkoutData() {
        let today = Date()
        //var workoutData: [Date: Int] = [:] // ✅ Store actual dates, not strings
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d" // Example: "3/7"
        
        let dates: [Date] = [
            //Calendar.current.date(byAdding: .weekOfYear, value: +1, to: Date())!,
            Date(),
            Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -4, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -5, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -6, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -7, to: Date())!,
            Calendar.current.date(byAdding: .weekOfYear, value: -8, to: Date())!,
        ]
        
        for (i, week) in dates.enumerated() {
            if (i < dates.count - 2) {
                let numWorkouts = fetchWorkoutsBetween(startDate: dates[i + 1], endDate: dates[i])
                workoutData[week] = numWorkouts
            }
        }
        
        updateChart(with: workoutData)
    }
    
    
    
    
    func updateChart(with workoutData: [Date: Int]) {
        var entries: [BarChartDataEntry] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"

        // ✅ Sort weeks correctly by date
        let sortedWeeks = workoutData.keys.sorted()
        var xLabels: [String] = []

        var maxWorkoutCount = 0 // ✅ Track highest workout count

        for (index, date) in sortedWeeks.enumerated() {
            let count = workoutData[date] ?? 0
            entries.append(BarChartDataEntry(x: Double(index), y: Double(count)))
            xLabels.append("Week of \(formatter.string(from: date))")
            maxWorkoutCount = max(maxWorkoutCount, count) // ✅ Find highest count
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Workouts Per Week")
        dataSet.colors = [NSUIColor.systemPurple]

        // ✅ Round Bar Corners
        dataSet.barBorderWidth = 0
        dataSet.barBorderColor = .clear
        dataSet.highlightColor = NSUIColor.white
        dataSet.valueColors = [NSUIColor.clear] // Hide values on top of bars

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.7

        numWorkoutsChart.data = data

        // ✅ X-Axis: Remove grid lines, keep labels
        let xAxis = numWorkoutsChart.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
        xAxis.granularity = 1
        xAxis.labelRotationAngle = -45
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false // ✅ Remove vertical grid lines

        // ✅ Y-Axis: Keep only horizontal grid lines at 1-unit increments
        let leftAxis = numWorkoutsChart.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = Double(maxWorkoutCount + 1) // ✅ Set max dynamically
        leftAxis.granularity = 1 // ✅ Force grid lines at whole numbers
        //leftAxis.drawLabelsEnabled = false // ✅ Hide y-axis numbers
        leftAxis.drawGridLinesEnabled = true // ✅ Keep horizontal grid lines

        numWorkoutsChart.rightAxis.enabled = false // ✅ Remove right y-axis

        // ✅ UI Enhancements
        numWorkoutsChart.extraBottomOffset = 10
        numWorkoutsChart.legend.enabled = false // Hide legend if not needed

        numWorkoutsChart.animate(yAxisDuration: 0.5)
        numWorkoutsChart.notifyDataSetChanged()
    }

    private func setApperance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBar
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

    
