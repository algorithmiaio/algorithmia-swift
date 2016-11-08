//
//  ViewController.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var req:AlgoRequest?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use your API key from Algorithmia account
        let client = Algorithmia.client(simpleKey: AppDelegate.ALGO_API_KEY)
        
        client.algo(algoUri: "algo://demo/Hello/0.1.1").pipe(text: "erik", completion: { resp, error in
            if (error == nil) {
                print(resp.getText())
            }
            else {
                print(error)
            }
        })
        
        let listAlgo = client.algo(algoUri: "algo://WebPredict/ListAnagrams/0.1.0")
        listAlgo.pipe(rawJson: "[\"thing\", \"night\", \"other\"]") { (resp, error) in
            if (error == nil) {
                print(resp.getJson())
            }
            else {
                print(error)
            }
        }
 
 
        
        let image = UIImage(named: "arnold.jpg")
        
        
        
        req = client.algo(algoUri: "algo://opencv/SmartThumbnail/2.1.3").pipe(data: UIImageJPEGRepresentation(image!, 0.3)) { (resp, error) in
            let resultImage = UIImage(data:resp.getData())
            self.imageView.image = resultImage
        }
        
        /*
        client.algo(algoUri: "algo://opencv/SmartThumbnail/2.1.2").pipe(text: "https://stopthehitch.files.wordpress.com/2013/06/arnold-schwarzenegger-1920x1080.jpg") { (resp, error) in
            let str = resp.getText()
            let data = Data(base64Encoded: str!)
            if data != nil {
                let resultImage = UIImage(data:data!)
                self.imageView.image = resultImage
            }
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

