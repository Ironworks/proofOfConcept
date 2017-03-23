//
//  SQLiteService.swift
//  ProofOfConcept
//
//  Created by Trevor Doodes on 20/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation
import MapKit

let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class SQLiteService {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss"
        return dateFormatter
    }()
    
    var database:OpaquePointer? = nil
    
    func connectToDatabase() {
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
    }
    
    func dataExists() -> Bool {
        
        var dataExists = false
        
        self.connectToDatabase()
        
        let query = "SELECT COUNT (*)  FROM VISIT"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let count = sqlite3_column_int(statement, 0);
                if count > 0 {
                    dataExists = true
                }
            }
        }
        
        sqlite3_finalize(statement)
        
        sqlite3_close(database)
        
        return dataExists
    }
    
    func createTable() {
        
        self.connectToDatabase()

        let createSQL = "CREATE TABLE IF NOT EXISTS VISIT " +
        "(VISIT_ID TEXT," +
        "CLIENT_NAME TEXT," +
        "SITE_ID TEXT," +
        "CLIENT_INSTRUCTIONS TEXT," +
        "START_DATE TEXT," +
        "LATITUDE TEXT," +
        "LONGITUDE TEXT);"
        
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            let error = String.init(cString: errMsg!)
            print("Failed to create table \(error)")
            return
        }
        
        sqlite3_close(database)

    }
    
    func getVisits() -> [Visit] {
        
        var visits: [Visit] = []
        self.connectToDatabase()
        
        let query = "SELECT VISIT_ID, CLIENT_NAME, SITE_ID, CLIENT_INSTRUCTIONS, START_DATE, LATITUDE, LONGITUDE FROM VISIT"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let idField = sqlite3_column_text(statement, 0)
                let id = String(cString: idField!)
                let clientNameField = sqlite3_column_text(statement, 1)
                let clientName = String.init(cString: clientNameField!)
                let siteIdField = sqlite3_column_text(statement, 2)
                let siteId = String.init(cString: siteIdField!)
                let clientInstructionsField = sqlite3_column_text(statement, 3)
                let clientInstructions = String.init(cString: clientInstructionsField!)
                let startDateTextField = sqlite3_column_text(statement, 4)
                let startDateText = String.init(cString: startDateTextField!)
                let startDate = self.dateFormatter.date(from: startDateText)
                let latitudeField = sqlite3_column_text(statement, 5)
                let latitude = String.init(cString: latitudeField!)
                let longitudeField = sqlite3_column_text(statement, 6)
                let longitude = String.init(cString: longitudeField!)

                let location = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                
                let visit = Visit(id: id,
                                  clientName: clientName,
                                  siteId: siteId,
                                  clientInstructions: clientInstructions,
                                  startDate: startDate!,
                                  location: location)
                visits.append(visit)
            }
            sqlite3_finalize(statement)
        }
        
        sqlite3_close(database)
        
        return visits
    }
    
    func save(visit: Visit) {
        
        self.connectToDatabase()
        
        let update = "INSERT OR REPLACE INTO VISIT (VISIT_ID, CLIENT_NAME, SITE_ID, CLIENT_INSTRUCTIONS, START_DATE, LATITUDE, LONGITUDE) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var statement:OpaquePointer? = nil
        let code =  sqlite3_prepare_v2(database, update, -1, &statement, nil)
        
        if code ==  SQLITE_OK {
            sqlite3_bind_text(statement, 1, visit.id.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 2, visit.clientName.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 3, visit.siteId.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 4, visit.clientInstructions.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            let startDateText = self.dateFormatter.string(from: visit.startDate)
            sqlite3_bind_text(statement, 5, startDateText.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            let latitude = String(visit.location.latitude)
            sqlite3_bind_text(statement, 6, latitude.cString(using: .utf8), -1, SQLITE_TRANSIENT)
            let longitude = String(visit.location.longitude)
            sqlite3_bind_text(statement, 7, longitude.cString(using: .utf8), -1, SQLITE_TRANSIENT)
    
        }
        let result = sqlite3_step(statement)
        
        if (result != SQLITE_DONE) {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(statement)
        
        sqlite3_close(database)

    }
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("data.sqlite").path
        return url!
    }

}



