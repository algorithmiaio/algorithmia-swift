//
//  DataFile.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoDataFile:AlgoDataObject {
    init(client: AlgoAPIClient, dataUrl: String) {
        super.init(client: client, dataUrl: dataUrl, type: .File)
    }
    
    func exists(completion:@escaping (Bool,Error?)-> Void) {
        _ = client.send(method:.HEAD, path: getUrl()) { (resp, error) in
            if resp.statusCode == 200 {
                completion(true, error)
            }
            else {
                completion(false, error)
            }
        }
    }
    
    func getString(completion:@escaping (String?, Error?) -> Void) {
        _ = client.send(method:.GET, path: getUrl()) { (resp, error) in
            if let data = resp.rawData {
                completion(String(data: data, encoding: .utf8), error)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func getData(completion:@escaping (Data?, Error?) -> Void) {
        _ = client.send(method:.GET, path: getUrl()) { (resp, error) in
            completion(resp.rawData, error)
        }
    }
    
    func getUrl() -> String {

        return "v1/data/" + self.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
