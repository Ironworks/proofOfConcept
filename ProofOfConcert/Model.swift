//
//  Model.swift
//  ProofOfConcert
//
//  Created by Trevor Doodes on 16/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation
import MapKit

struct Visit {
    var id: String
    var clientName: String
    var siteId: String
    var clientInstructions: String
    var startDate: Date
    var location: CLLocationCoordinate2D
}
