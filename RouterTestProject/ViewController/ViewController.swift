//
//  ViewController.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2020/7/2.
//  Copyright © 2020 Rex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    var titles:[String] = ["randomUser","getIpDetail"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "API List"
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(identifier: "APIResultViewController") as? APIResultViewController {
            vc.apiType = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



