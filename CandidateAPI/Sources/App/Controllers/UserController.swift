import Vapor
import Fluent

struct RegisterRequest: Content {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct LoginRequest: Content {
    let email: String
    let password: String
}

struct TokenResponse: Content {
    let token: String
    let isAdmin: Bool
}

final class UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        
        usersRoute.post("register", use: register)
            .description("Register a new user")
        
        usersRoute.post("auth", use: login)
            .description("Authenticate a user and return a JWT token")
    }

    func register(req: Request) throws -> EventLoopFuture<HTTPStatus> {
            let registerRequest = try req.content.decode(RegisterRequest.self)
            
            // Check if the email is already used
            return User.query(on: req.db)
                .filter(\.$email == registerRequest.email)
                .first()
                .flatMap { existingUser in
                    guard existingUser == nil else {
                        return req.eventLoop.makeFailedFuture(Abort(.conflict, reason: "Email already in use."))
                    }

                    // Hash the password
                    do {
                        let passwordHash = try req.password.hash(registerRequest.password)
                        let user = User(firstName: registerRequest.firstName,
                                        lastName: registerRequest.lastName,
                                        email: registerRequest.email,
                                        passwordHash: passwordHash,
                                        isAdmin: false)
                        return user.save(on: req.db).map { .created }
                    } catch {
                        return req.eventLoop.makeFailedFuture(error)
                    }
                }
        }


    func login(req: Request) async throws -> TokenResponse {
           let loginRequest = try req.content.decode(LoginRequest.self)

           // Vérifier que l'email et le mot de passe ne sont pas vides
           guard !loginRequest.email.isEmpty else {
               throw Abort(.badRequest, reason: "Email cannot be empty.")
           }

           guard !loginRequest.password.isEmpty else {
               throw Abort(.badRequest, reason: "Password cannot be empty.")
           }

           // Rechercher l'utilisateur par email
           guard let user = try await User.query(on: req.db)
                   .filter(\.$email == loginRequest.email)
                   .first()
           else {
               throw Abort(.unauthorized, reason: "User not found.")
           }
           
           // Vérifier le mot de passe
           guard try req.password.verify(loginRequest.password, created: user.passwordHash) else {
               throw Abort(.unauthorized, reason: "Invalid email or password.")
           }
           
           // Créer le payload pour le token JWT
           let payload = UserPayload(email: user.email, isAdmin: user.isAdmin)
           
           // Générer le token JWT
           let token = try req.jwt.sign(payload)
           
           return TokenResponse(token: token, isAdmin: user.isAdmin)
       }
}
