//
//  WebViewController.swift
//  weathere
//
//  Created by Андрей Илалов on 10.07.17.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView1: UIWebView!
    var request: NSURLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        if request != nil{
        print(request)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
