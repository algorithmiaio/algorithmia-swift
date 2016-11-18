//
//  ViewController.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let client = Algorithmia.client(simpleKey: "%PLACE_YOUR_API_KEY%")
    let imagePicker = UIImagePickerController()
    var image:UIImage?
    let sourcePath = "data://.my/test/photo.jpg"
    let resultPath = "data://.my/test/result.jpg"
    @IBOutlet weak var srcImageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCamera(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onLibrary(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            srcImageView.image = pickedImage
            startProcess()
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func startProcess() {
        uploadImage()
    }
    
    func uploadImage() {
        // Upload file using Data API
        let file = client.file(sourcePath)
        file.put(data: UIImageJPEGRepresentation(image!, 0.7)!) { error in
            if let error = error {
                print(error)
                return
            }
            self.processImage(file: file)
        }
    }
    
    func processImage(file:AlgoDataFile) {
        let param:[String:Any] = [
            "images": [
                file.fullPath()
            ],
            "savePaths": [
                resultPath
            ],
            "filterName": "space_pizza"
        ]
        
        // Process with DeepFilter algorithm
        self.client.algo(algoUri: "algo://deeplearning/DeepFilter").pipe(json: param, completion: { (response, error) in
            if let error = error {
                print(error)
                return
            }
            self.downloadOutput(file: self.client.file(self.resultPath))
        })
    }
    
    func downloadOutput(file:AlgoDataFile) {
        // Download output file
        file.getData { (data, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.resultImageView.image = UIImage(data: data!)
            }
        }
        
    }
    
    
    

}

