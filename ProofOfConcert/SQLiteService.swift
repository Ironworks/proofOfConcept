//
//  SQLiteService.swift
//  ProofOfConcept
//
//  Created by Trevor Doodes on 20/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import Foundation
import MapKit

class SQLiteService {
    
    func connectToDatabase() {
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
    }
    
    func createTable() {
        let createSQL = "CREATE TABLE IF NOT EXISTS VISIT " +
        "(ID TEXT PRIMARY KEY," +
        "CLIENT_NAME TEXT," +
        "SITE_ID TEXT," +
        "CLIENT_INSTRUCTIONS," +
        "START_DATE TEXT," +
        "LATITUDE REAL," +
        "LONGITUDE REAL;)"
        
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }

    }
    
    func getVisits() -> [Visit] {
        let visits: [Visits] = []
        
        let query = "SELECT ROW, FIELD_DATA FROM FIELDS ORDER BY ROW"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_text(sqlite3_column_int(statement, 0))
                let clientName = sqlite3_column_text(sqlite3_column_int(statement, 1))
                let siteId = sqlite3_column_text(sqlite3_column_int(statement, 2))
                let clientInstructions = sqlite3_column_text(sqlite3_column_int(statement, 3))
                let startDate = sqlite3_column_text(sqlite3_column_int(statement, 4))
                let longitude = sqlite3_column_text(sqlite3_column_int(statement, 5))
                let latitude = sqlite3_column_text(sqlite3_column_int(statement, 6))
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let fieldValue = String.init(cString: UnsafePointer<CChar>(rowData!))
                let visit = Visit(id: id,
                                  clientName: clientName,
                                  siteId: siteId,
                                  clientInstructions: clientInstructions, startDate: startDate,
                                  location: <#T##CLLocationCoordinate2D#>)
            }
            sqlite3_finalize(statement)
        }
    }
    
    func getVisits() {
        let update = "INSERT OR REPLACE INTO VISIT (ROW, FIELD_DATA) " +
        "VALUES (?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            let text = field.text
            sqlite3_bind_int(statement, 1, Int32(i))
            sqlite3_bind_text(statement, 2, text!, -1, nil)
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(statement)

    }
    
    func save(visit: Visit) {
        let update = "INSERT OR REPLACE INTO FIELDS (ROW, FIELD_DATA) " +
        "VALUES (?, ?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            let text = field.text
            sqlite3_bind_int(statement, 1, Int32(i))
            sqlite3_bind_text(statement, 2, text!, -1, nil)
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating table")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(statement)

    }
    
    func closeDatabase() {
        sqlite3_close(database)
    }
}



