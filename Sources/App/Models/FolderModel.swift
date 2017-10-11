//
//  FolderModel.swift
//  App
//
//  Created by Gregory Maksyuk on 10/11/17.
//

import FluentProvider


final class FolderModel: Model {
    
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    var name: String = ""
    var order: Int = -1
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let order = "order"
    }
    
    init() {
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        name = try row.get(Keys.name)
        order = try row.get(Keys.order)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.order, order)
        return row
    }
    
}

extension FolderModel: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(FolderModel.Keys.name)
            builder.int(FolderModel.Keys.order)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension FolderModel: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init()
        self.name = try json.get(Keys.name)
        self.order = try json.get(Keys.order)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id)
        try json.set(Keys.name, name)
        try json.set(Keys.order, order)
        return json
    }
}

extension FolderModel: ResponseRepresentable {}

extension FolderModel: Updateable {
    public static var updateableKeys: [UpdateableKey<FolderModel>] {
        return [
            UpdateableKey(Keys.name, String.self) { $0.name = $1 },
            UpdateableKey(Keys.order, Int.self) { $0.order = $1 }
        ]
    }
}

