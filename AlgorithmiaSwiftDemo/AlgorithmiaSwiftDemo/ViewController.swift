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
        // Do any additional setup after loading the view, typically from a nib.
        let client = Algorithmia.client(simpleKey: "simeH+d9MCtPoMSpXS0qjIUJuuF1")
        let algo = client.algo(algoUri: "algo://demo/Hello/0.1.1");
        
        _ = algo.pipe(input: "erik" )?.asText { output, resp, error in
            print ("---------------")
            if (error != nil) {
                print("\nError: " + (error?.localizedDescription)!)
            }
            else {
                print("\nSuccess: " + output!)
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

