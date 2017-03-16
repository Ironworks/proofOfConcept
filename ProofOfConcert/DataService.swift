//
//  DataService.swift
//  ProofOfConcert
//
//  Created by Trevor Doodes on 16/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation


class DataService {
    
    func getData() {
        
        let URLString = "http://somatest.ground-control.co.uk/SummerMaintService/?q=dataRequest&token=4C68F84A-CFE1-4245-B782-300D60438CB11&parentID=&dataType=1005&dateTime=1900-01- 01T00:00:00.000&latitude=0.0&longitude=0.0&radius=0.0&rangeStart=0&rangeEnd=50"
        let urlString = "https://somatest.ground-control.co.uk/SummerMaintService/"

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        //Implement your logic
                        print(json)
                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
}
