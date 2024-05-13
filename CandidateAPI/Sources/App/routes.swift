import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    app.post("/user/auth") { recup  async throws -> TokenResponse in
        let authentification = try recup.content.decode(LoginRequest.self)
        if authentification.email == "admin@vitesse.com" && authentification.password == "test123" {
            let isAdmin = AdminMiddleware.addisAdmin()

            let token = AdminMiddleware.registerNewAuthToken()
            recup.logger.info("Successfuly loggedin and generate new auth token: \(token)")
            return TokenResponse(token: token, isAdmin: isAdmin )
        } else {
            recup.logger.info("Fail to login (bad username and/or password)")
            throw Abort(.badRequest)
        }
    }

    app.post("/user/register") { Request  -> EventLoopFuture<User> in
        let userData = try Request.content.decode(User.self)
        let newUser = User(firstName: userData.firstName, lastName: userData.lastName, email: userData.email, passwordHash: userData.passwordHash, isAdmin: userData.isAdmin)
           
           // Save the new user to the database
           return newUser.save(on: Request.db).map { newUser }
    }
   
 
    
    app.get("/candidate") { Request -> EventLoopFuture<Candidate> in
        let candidate = try Request.content.decode(Candidate.self)
        
        let candidateRequest = Candidate(firstName: candidate.firstName, lastName: candidate.lastName, email: candidate.email, phone: candidate.phone, linkedinURL: candidate.linkedinURL, note: candidate.note)
        
        return candidateRequest.save(on: Request.db).map {
            candidateRequest
        }
    }
    
    app.get("/candidate/:candidateId") { Request -> EventLoopFuture<Candidate> in
        let candidateId = try Request.content.decode(Candidate.self)
        
        let candidateRequest = Candidate(firstName: candidateId.firstName, lastName: candidateId.lastName, email: candidateId.email, phone: candidateId.phone, linkedinURL: candidateId.linkedinURL, note: candidateId.note)
        
        return candidateRequest.save(on: Request.db).map {
            candidateRequest
        }
    }
    
    app.delete("DELETE /candidate/:candidateId") { Request -> EventLoopFuture<HTTPStatus> in
        guard let delete = Request.parameters.get("candidateId"),
              let candidatUUID = UUID(delete) else {
            throw Abort(.badRequest)
        }
        
        return Candidate.find(candidatUUID, on: Request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { candidate in
                
                return candidate.delete(on: Request.db).transform(to: .noContent)
            }
    }
        app.put("/candidate/:candidateId/favorite") { Request -> EventLoopFuture<Candidate> in
            let user = try Request.auth.require(User.self)
            guard user.isAdmin else {
                throw Abort(.forbidden)
            }
            
            return Candidate.find(Request.parameters.get("candidateID"), on: Request.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { candidate in
                    candidate.isFavorite.toggle()
                    return candidate.save(on: Request.db).map { candidate }
                }
    }

    
    
    
    try app.register(collection: UserController())
    try app.register(collection: CandidateController())
}
