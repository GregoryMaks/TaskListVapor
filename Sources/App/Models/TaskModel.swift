//
//  TaskModel.swift
//  App
//
//  Created by Gregory Maksyuk on 10/11/17.
//

import FluentProvider


final class TaskModel: Model {
    
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    var text: String = ""
    var folderId: Int? = nil
    var createdAt: Date = .init()
    var order: Int = -1
    var isCompleted: Bool = false
    
    struct Keys {
        static let id = "id"
        static let folderId = "folderId"
        static let text = "text"
        static let createdAt = "createdAt"
        static let order = "order"
        static let isCompleted = "isCompleted"
    }
    
    init() {
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        text = try row.get(Keys.text)
        folderId = try row.get(Keys.folderId)
        createdAt = try row.get(Keys.createdAt)
        order = try row.get(Keys.order)
        isCompleted = try row.get(Keys.isCompleted)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.folderId, folderId)
        try row.set(Keys.text, text)
        try row.set(Keys.createdAt, createdAt)
        try row.set(Keys.order, order)
        try row.set(Keys.isCompleted, isCompleted)
        return row
    }
    
}

extension TaskModel: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.foreignId(for: FolderModel.self,
                              optional: false,
                              unique: false,
                              foreignIdKey: TaskModel.Keys.folderId,
                              foreignKeyName: TaskModel.Keys.folderId)
            builder.string(TaskModel.Keys.text)
            builder.date(TaskModel.Keys.createdAt)
            builder.int(TaskModel.Keys.order)
            builder.bool(TaskModel.Keys.isCompleted)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension TaskModel: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init()
        // Required
        self.folderId = try json.get(Keys.folderId)
        self.text = try json.get(Keys.text)
        self.order = try json.get(Keys.order)
        // Optional
        do {
            self.createdAt = try json.get(Keys.createdAt)
            self.isCompleted = try json.get(Keys.isCompleted)
        } catch {}
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id)
        try json.set(Keys.folderId, folderId)
        try json.set(Keys.text, text)
        try json.set(Keys.createdAt, createdAt)
        try json.set(Keys.order, order)
        try json.set(Keys.isCompleted, isCompleted)
        return json
    }
}

extension TaskModel: ResponseRepresentable {}

extension TaskModel: Updateable {
    public static var updateableKeys: [UpdateableKey<TaskModel>] {
        return [
            UpdateableKey(Keys.folderId, Int.self) { $0.folderId = $1 },
            UpdateableKey(Keys.text, String.self) { $0.text = $1 },
            UpdateableKey(Keys.order, Int.self) { $0.order = $1 },
            UpdateableKey(Keys.isCompleted, Bool.self) { $0.isCompleted = $1 }
        ]
    }
}

