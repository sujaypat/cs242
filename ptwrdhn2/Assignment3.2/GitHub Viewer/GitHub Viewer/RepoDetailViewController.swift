//
//  RepoDetailViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 11/8/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import Charts

class RepoDetailViewController: UIViewController {
    
    var model: Repo!
    @IBOutlet var repoAuthor: UILabel!
    @IBOutlet var numStars: UILabel!
    @IBOutlet var chart: LineChartView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        graph()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = model.name!
        repoAuthor.text! = "Owned by: \(model.userName!)"
        numStars.text! = "\(model.numStars) stars"
    }
    
    @IBAction func goToRepoPage(sender: UIBarButtonItem) {
        let view = SFSafariViewController(url: URL(string: model.url!)!)
        self.present(view, animated: true, completion: nil)
    }
    
    func graph() {
        var dataEntries: [ChartDataEntry] = []
//        dump(model)
        for i in 0..<model.views!.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: model.views![i] as! Double)
            dataEntries.append(dataEntry)
        }

        let data = LineChartData()
        let ds = LineChartDataSet(values: dataEntries, label: "Commits")

        data.addDataSet(ds)
        chart.data = data
    }
    
}
