//
//  AlgoDataDirectory.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/11/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoDirectory:AlgoDataObject {
    init(client: AlgoAPIClient, dataUrl: String) {
        super.init(client: client, dataUrl: dataUrl, type: .Directory)
    }
    
    func list(completion:@escaping ([AlgoDataObject], Error?) -> Void) {
        _ = client.send(method: .GET, path: getUrl(), data: nil) { (respData, error) in
            if (respData.statusCode == 200 && (error != nil)) {
                do {
                    let jsonData = try respData.getJSON()
                    
                }catch {
                    completion([AlgoDataObject](),error)
                }
            }
        }
    }
}
