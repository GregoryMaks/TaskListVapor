//
//  TaskController.swift
//  App
//
//  Created by Gregory Maksyuk on 10/11/17.
//

import Vapor
import HTTP
import Fluent


final class TaskController: ResourceRepresentable {
    
    typealias Model = TaskModel
    
    enum Error: Swift.Error {
        case error(_: String)
    }
    
    /// When users call 'GET' on '/posts'
    /// it should return an index of all available posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        let folderId = try req.parameters.next(Int.self)
        return try Model.makeQuery().filter("folderId" == folderId).all().makeJSON()
    }
    
    /// When consumers call 'POST' on '/posts' with valid JSON
    /// construct and save the post
    func store(_ req: Request) throws -> ResponseRepresentable {
        let folderId = try req.parameters.next(Int.self)
        guard try FolderModel.makeQuery().find(folderId) != nil else {
            throw Error.error("no such folder")
        }
        
        let model = try self.model(from: req)
        
        model.folderId = folderId
        model.createdAt = Date()
        
        try model.save()
        return model
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(_ req: Request, model: Model) throws -> ResponseRepresentable {
        return model
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, model: Model) throws -> ResponseRepresentable {
        try model.delete()
        return Response(status: .ok)
    }
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, post: Model) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try post.update(for: req)
        
        // Save an return the updated post.
        try post.save()
        return post
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<Model> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            destroy: delete
        )
    }
    
    // Private
    
    private func model(from request: Request) throws -> Model {
        guard let json = request.json else { throw Abort.badRequest }
        return try Model(json: json)
    }
}

extension TaskController: EmptyInitializable {}
