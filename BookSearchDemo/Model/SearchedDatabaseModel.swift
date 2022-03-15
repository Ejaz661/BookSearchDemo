//
//  SearchedDatabaseModel.swift
//  BookSearchDemo
//
//  Created by Ejaz on 14/03/22.
//

import Foundation
import GRDB

struct GeneralModel: Codable {
    var docs = [SearchedDatabaseModel]()
    var q = ""
}

struct SearchedDatabaseModel: Codable, FetchableRecord, PersistableRecord {
    var id: Int?
    var searched: String?
    var title: String?
    var key: String?
    var first_publish_year: Int?
    var author_name: [String]?
}

