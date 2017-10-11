//
//  FolderController.swift
//  App
//
//  Created by Gregory Maksyuk on 10/11/17.
//

import HTTP
import Vapor
import FluentProvider


final class FolderController: ResourceRepresentable {
    
    typealias Model = FolderModel
    
    /// When users call 'GET' on '/posts'
    /// it should return an index of all available posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Model.all().makeJSON()
    }
    
    /// When consumers call 'POST' on '/posts' with valid JSON
    /// construct and save the post
    func store(_ req: Request) throws -> ResponseRepresentable {
        let post = try model(from: req)
        try post.save()
        return post
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(_ req: Request, post: Model) throws -> ResponseRepresentable {
        return post
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, model: Model) throws -> ResponseRepresentable {
        try TaskModel.makeQuery().filter("folderId" == model.id).delete()
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

extension FolderController: EmptyInitializable {}
