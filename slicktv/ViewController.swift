//
//  ViewController.swift
//  slicktv
//
//  Created by Stanley Chiang on 9/29/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var textURL: UITextField!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView!.delegate = self
        loadLink("https://google.com")
//        textURL.text = "http://vodlocker.com/vzxb56qffdf4"
    }

//    link must be fully formatted with 'http://'
    func loadLink(link: String){
        var url = NSURL(string: link)
        var request = NSURLRequest(URL: url!)
        webView!.loadRequest(request)
    }
    
    @IBAction func goButtonPressed(sender: UIButton) {
        loadLink(textURL.text)
        textURL.resignFirstResponder()
    }

}

