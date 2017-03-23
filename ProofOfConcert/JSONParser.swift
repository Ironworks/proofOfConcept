//
//  JSONParser.swift
//  ProofOfConcept
//
//  Created by Trevor Doodes on 19/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation
import MapKit

class JSONParser {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss"
        return dateFormatter
    }()
    
    func parse(json: [String: AnyObject]) {
        
        let data = json["data"] as! [String: AnyObject]
        let records = data["records"] as! [[String: AnyObject]]
        let sqlService = SQLiteService()
        sqlService.createTable()
        
        for dict in records {
            
            guard let latitude = dict["latitude"] as? CLLocationDegrees,
                let longitude = dict["longitude"] as? CLLocationDegrees else { continue }
    
            let startDate = self.dateFormatter.date(from: dict["expectedStart"] as! String)
            
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let visit = Visit(id: dict["id"] as! String,
                              clientName: dict["client"] as! String,
                              siteId: dict["siteId"] as! String,
                              clientInstructions: dict["clientInstructions"] as! String,
                              startDate: startDate!,
                              location: location)
            sqlService.save(visit: visit)
        }
        
    }
}
