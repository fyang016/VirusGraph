//
//  ResultViewController.swift
//  VirusGraph
//
//  Created by AdrenResi on 10/13/20.
//

import UIKit
import Charts
import TinyConstraints

class ResultViewController: UIViewController, ChartViewDelegate {
    
    var state: String
    
    init(state: String) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .systemBackground
        return searchBar
    }()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        chartView.xAxis.valueFormatter = ChartXAxisFormatter()
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    var yValues: [ChartDataEntry] = [
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        print(state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setData()
        apiCall()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }

    func apiCall() {
        URLSession.shared.dataTask(with: URL(string: "https://coronavirusapi.com/getTimeSeriesJson/\(state)")!) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let json = try decoder.decode([Model].self, from: data)
                print(json.count)
                for index in 0..<json.count {
                    self.yValues.append(ChartDataEntry(x: Double(json[index].secondsSinceEpoch), y: Double(json[index].deaths)))
                }
                
                DispatchQueue.main.async {
                    self.setData()
                }
                
                
            } catch {
                print("Error")
            }
        }.resume()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Number Of Cases")
        
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}
