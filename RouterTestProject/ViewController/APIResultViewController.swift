//
//  APIResultViewController.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2021/1/8.
//  Copyright © 2021 Rex. All rights reserved.
//

import UIKit

class APIResultViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    var apiType:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "API Result"
        
        if let type = apiType {
            switch type {
            case 0:
                //RandomUser 短時間拿太多次會沒資料
                APIRepository.getRandomUser(gender: "male") { (result) in
                    self.setText(text: result)
                }                
                break
                
            case 1:
                APIRepository.getIpDetail(ip: "1.1.1.1") { (result) in
                    self.setText(text: result)
                }
                break
                
            default:
                break
            }
        }
    }
    
    private func setText(text:String) {
        DispatchQueue.main.async {
            self.resultTextView.text = text
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
