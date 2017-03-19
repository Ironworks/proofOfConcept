//
//  JSONParser.swift
//  ProofOfConcept
//
//  Created by Trevor Doodes on 19/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation

class JSONParser {
    
    func parse(json: [String: AnyObject]) -> [Visit] {
        
        var visits: [Visit] = []
        let data = json["data"] as! [String: AnyObject]
        let records = data["records"] as! [[String: AnyObject]]
        
        for dict in records {
            
            let visit = Visit(id: dict["id"] as! String,
                              clientName: dict["client"] as! String,
                              siteId: dict["siteId"] as! String,
                              clientInstructions: dict["clientInstructions"] as! String,
                              startDate: dict["expectedStart"] as! String)
            visits.append(visit)
        }
        
        return visits
    }
}
