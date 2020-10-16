//
//  ViewController.swift
//  VirusGraph
//
//  Created by AdrenResi on 10/13/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var data = [(String, String)]()
    var filteredData = [(String, String)]()
    var filtered = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupData()
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            if string.count == 0 {
                filterText(String(text.dropLast()))
            } else {
                filterText(text + string)
            }
            
        }
        
        return true
    }
    
    func filterText(_ query: String) {
        // print("\(query)")
        filtered = true
        filteredData.removeAll()
        for string in data {
            if string.0.lowercased().starts(with: query.lowercased()) ||
                string.1.lowercased().starts(with: query.lowercased()) {
                filteredData.append(string)
            }
        }
        table.reloadData()
        
    }
    
    private func setupData() {
        data.append(("CA", "California"))
        data.append(("TX", "Texas"))
        data.append(("FL", "Florida"))
        data.append(("NY", "New York"))
        data.append(("GA", "Georgia"))
        data.append(("IL", "Illinois"))
        data.append(("AZ", "Arizona"))
        data.append(("NC", "North Carolina"))
        data.append(("NJ", "New Jersey"))
        data.append(("TN", "Tennessee"))
        data.append(("LA", "Louisiana"))
        data.append(("PA", "Pennsylvania"))
        data.append(("OH", "Ohio"))
        data.append(("AL", "Alabama"))
        data.append(("SC", "South Carolina"))
        data.append(("VA", "Virginia"))
        data.append(("MI", "Michigan"))
        data.append(("MA", "Massachusetts"))
        data.append(("MD", "Maryland"))
        data.append(("MO", "Missouri"))
        data.append(("IN", "Indiana"))
        data.append(("WI", "Wisconsin"))
        data.append(("MN", "Minnesota"))
        data.append(("MS", "Mississippi"))
        data.append(("OK", "Oklahoma"))
        data.append(("IA", "Indiana"))
        data.append(("WA", "Washington"))
        data.append(("AR", "Arizona"))
        data.append(("NV", "Nevada"))
        data.append(("UT", "Utah"))
        data.append(("KY", "Kentucky"))
        data.append(("CO", "Colorado"))
        data.append(("KS", "Kansas"))
        data.append(("CT", "Connecticut"))
        data.append(("PR", "Puerto Rico"))
        data.append(("NE", "Nebraska"))
        data.append(("ID", "Idaho"))
        data.append(("OR", "Oregon"))
        data.append(("NM", "New Mexico"))
        data.append(("RI", "Rhode Island"))
        data.append(("SD", "South Dakota"))
        data.append(("ND", "North Dakota"))
        data.append(("DE", "Delaware"))
        data.append(("WV", "West Virginia"))
        data.append(("DC", "Washington, D.C."))
        data.append(("MT", "Montana"))
        data.append(("HI", "Hawaii"))
        data.append(("NH", "New Hampshire"))
        data.append(("AK", "Arkansas"))
        data.append(("WY", "Wyoming"))
        data.append(("ME", "Maine"))
        data.append(("VT", "Vermont"))
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredData.isEmpty {
            return filteredData.count
        }
        return filtered ? 0 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if !filteredData.isEmpty {
            cell.textLabel?.text = filteredData[indexPath.row].1
        }
        else {
            cell.textLabel?.text = data[indexPath.row].1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var link: String
        
        if !filteredData.isEmpty {
            
            link = "https://coronavirusapi.com/getTimeSeriesJson/" + filteredData[indexPath.row].0
        }
        else {
            link = "https://coronavirusapi.com/getTimeSeriesJson/" + data[indexPath.row].0
        }
        print(link)
        // callAPI(link: link)
        
        let vc = ResultViewController(state: data[indexPath.row].0)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func callAPI(link: String) {
        URLSession.shared.dataTask(with: URL(string: link)!) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let json = try decoder.decode([Model].self, from: data)
                    for index in json {
                        print(index.deaths)
                    }
                } catch {
                    print("Error")
                }
            }
        }.resume()
    }
}
