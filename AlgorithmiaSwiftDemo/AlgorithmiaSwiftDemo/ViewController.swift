//
//  ViewController.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use your API key from Algorithmia account
        let client = Algorithmia.client(simpleKey: AppDelegate.ALGO_API_KEY)
        let algo = client.algo(algoUri: "algo://demo/Hello/0.1.1");
        
        _ = algo.pipe(input: "erik", completion: { resp, error in
            if (error == nil) {
                print(resp.getText())
            }
            else {
                print(error)
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

