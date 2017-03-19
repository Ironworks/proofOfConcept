//
//  DataService.swift
//  ProofOfConcert
//
//  Created by Trevor Doodes on 16/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation


class DataService {
    
    func getData(completionHandler: @escaping ([Visit]) -> ()) {
                
        var urLComponents = URLComponents()
        urLComponents.scheme = "http"
        urLComponents.host = "somatest.ground-control.co.uk"
        urLComponents.path = "/SummerMaintService/"
        
        let dataRequest = URLQueryItem(name: "q", value: "dataRequest")
        let token = URLQueryItem(name: "token", value: "4C68F84A-CFE1-4245-B782-300D60438CB11")
        let parentId = URLQueryItem(name: "parentID", value: "")
        let dataType = URLQueryItem(name: "dataType", value: "1005")
        let dateTime = URLQueryItem(name: "dateTime", value: "1900-01- 01T00:00:00.000")
        let latitude = URLQueryItem(name: "latitude", value: "0.0")
        let longitude = URLQueryItem(name: "longitude", value: "0.0")
        let radius = URLQueryItem(name: "radius", value: "0")
        let rangeStart = URLQueryItem(name: "rangeStart", value: "0")
        let rangeEnd = URLQueryItem(name: "rangeEnd", value: "50")
        urLComponents.queryItems = [dataRequest, token, parentId, dataType, dateTime, latitude, longitude, radius, rangeStart, rangeEnd]

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urLComponents.url!, completionHandler: { (data, response, error) in
            
            
            if let response = response {
                print("Response: \(response)")
            }
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    {
                        
                        let parser = JSONParser()
                        let results = parser.parse(json: json)
                        completionHandler(results)
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
}
