//
//  DBManager.swift
//  BookSearchDemo
//
//  Created by Ejaz on 14/03/22.
//

import UIKit
import GRDB

class DBManager {
    
    static var shared = DBManager()
    
    private var dbQueue: DatabaseQueue!
    
    init(){
        do {
            let databaseURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.sqlite")
            
            print("\n\nDB Path :-\n",databaseURL.path,"\n\n")
            dbQueue = try DatabaseQueue(path: databaseURL.path)
            
            var tableExist = false
            try dbQueue.read { db in
                tableExist = try db.tableExists("SearchedDatabaseModel")
            }
            if !tableExist {
                try dbQueue.write { db in
                    try db.create(table: "SearchedDatabaseModel") { t in
                        t.autoIncrementedPrimaryKey("id", onConflict: .ignore)
                        t.column("searched", .text)
                        t.column("title", .text)
                        t.column("key", .text)
                        t.column("author_name", .any)
                        t.column("first_publish_year", .text)
                    }
                }
            }
            
        } catch {
            print("Error while initializing DB:- ",error)
        }
    }
    
    /// Save data to local database
    /// - Parameters:
    ///   - data: Array of SearchedDatabaseModel
    ///   - searchStr: Search string the data is for
    func addData(array data:[SearchedDatabaseModel], for searchStr: String) {
        do {
            try dbQueue.write { db in
                try data.forEach {
                    if var obj = try SearchedDatabaseModel.fetchOne(db, sql: "SELECT * FROM SearchedDatabaseModel WHERE searched = ? AND key = ? AND title = ? AND first_publish_year = ?", arguments: [searchStr, $0.key ?? "", $0.title ?? "", $0.first_publish_year ?? ""]) {
                        obj.searched = searchStr
                        obj.author_name = $0.author_name
                        obj.key = $0.key
                        obj.title = $0.title
                        obj.first_publish_year = $0.first_publish_year
                        try obj.update(db)
                    } else {
                        var obj = $0
                        obj.searched = searchStr
                        try obj.insert(db)
                    }
                }
            }
        } catch {
            print("Error while saving data :- ", error)
        }
    }
    
    /// Get data from local database
    /// - Parameter search: data to be fetched for search string
    /// - Returns: Array of SearchedDatabaseModel
    func getData(for search: String) -> [SearchedDatabaseModel] {
        do {
            let obj = try dbQueue.read{ db in
                try SearchedDatabaseModel.fetchAll(db, sql: "SELECT * FROM SearchedDatabaseModel WHERE searched = ?", arguments: [search])
            }
            return obj
        } catch {
            print("Error while fetching data:- ",error)
        }
        return []
    }
    
}

