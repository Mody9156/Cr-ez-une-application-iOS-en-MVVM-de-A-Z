import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async in
        
        "It works!"
    }
    
    app.post("/user/auth") { Request  async throws -> TokenResponse in

            return try await UserController().login(req:Request)
 
    }

    app.post("/user/register") { Request -> EventLoopFuture<HTTPStatus> in
    
        return try UserController().register(req:Request)
    }
   
    
    app.get("/candidate") { Request -> EventLoopFuture<[Candidate]> in
        return try CandidateController().getAllCandidates(req: Request)
    }
    
    app.get("/candidate/:candidateId") { Request -> EventLoopFuture<Candidate> in
        return try CandidateController().getCandidate(req: Request)
    }
    
    app.post("/candidate") { Request -> EventLoopFuture<Candidate> in
        return try CandidateController().createCandidate(req: Request)

    }
    
    app.put("/candidate/:candidateId") { Request -> EventLoopFuture<Candidate>in
        return try CandidateController().updateCandidate(req: Request)
    }
    
    app.delete("DELETE /candidate/:candidateId") { Request -> HTTPStatus in
        
        return try await CandidateController().removeCandidate(req: Request)
    }
    
    app.put("/candidate/:candidateId/favorite") { Request -> EventLoopFuture<Candidate> in
            
            return try CandidateController().favoriteCandidate(req: Request)
    }

    
    
    
    try app.register(collection: UserController())
    try app.register(collection: CandidateController())
}
