import Vapor

struct AdminMiddleware: Middleware {
    
    static private var authTokens: [String] = []
    static func registerNewAuthToken() -> String {
        let token = UUID()
        authTokens.append(token.uuidString)
        return token.uuidString
    }
    
    static private var isAdmin : Bool = false
    static func addisAdmin () -> Bool {
        let isvalid = true
        isAdmin = isvalid
        return isvalid
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Ensure user is logged in and is an admin
        guard let user = request.auth.get(User.self), user.isAdmin else {
            return request.eventLoop.makeFailedFuture(Abort(.forbidden, reason: "Access restricted to administrators."))
        }
        return next.respond(to: request)
    }
}
