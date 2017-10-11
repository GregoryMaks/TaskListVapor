import Vapor

extension Droplet {
    func setupRoutes() throws {
//        get("hello") { req in
//            var json = JSON()
//            try json.set("hello", "world")
//            return json
//        }
//
//        get("plaintext") { req in
//            return "Hello, world!"
//        }
//
//        // response to requests to /info domain
//        // with a description of the request
//        get("info") { req in
//            return req.description
//        }
//
//        get("description") { req in
//            return req.description
//        }
        
//        try resource("posts", PostController.self)
        
        try resource("folders", FolderController.self)
//        try resource("folder/:folderId/tasks", TaskController.self)
        
        let folder = grouped("folder", Int.parameter)
        try folder.resource("tasks", TaskController.self)
    }
}
