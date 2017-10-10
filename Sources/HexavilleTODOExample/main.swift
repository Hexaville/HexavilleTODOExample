import Foundation
import HexavilleFramework
import HexavilleAuth
import DynamodbSessionStore
import SwiftAWSDynamodb
import Prorsum
import Stencil

let app = HexavilleFramework()
var auth = HexavilleAuth()

let dynamodb: Dynamodb

switch Configuration.shared.env {
case .production:
    dynamodb = Dynamodb()
    
case .development:
    dynamodb = Dynamodb(endpoint: "http://localhost:8000")
}

let store = DynamodbSessionStore(tableName: "hexaville_todo_example_session", dynamodb: dynamodb)

Connection.set(
    Connection(driver: DynamodbDriver(dynamodb: dynamodb)),
    forKey: ConnectionName.dybamodb
)

let session = SessionMiddleware(
    cookieAttribute: CookieAttribute(
        key: "hexaville.sid",
        expiration: 3600,
        httpOnly: true,
        secure: Configuration.shared.env.isProduction()
    ),
    store: store
)

app.use(session)

let githubProvider = GithubAuthorizationProvider(
    path: "/auth/github",
    consumerKey: ProcessInfo.processInfo.environment["GITHUB_APP_ID"] ?? "",
    consumerSecret: ProcessInfo.processInfo.environment["GITHUB_APP_SECRET"] ?? "",
    callbackURL: CallbackURL(baseURL: Configuration.shared.baseURLString, path: "/auth/github/callback"),
    scope: ""
) { credential, logedInUser, request, context in
    if let user: User = try Connection.get(forKey: ConnectionName.dybamodb)?.fetch(byID: logedInUser.id) {
        context.session?["currentUser"] = try user.serializeToDictionary()
    } else {
        let user = User(
            id: logedInUser.id,
            name: logedInUser.name,
            avaterUrl: logedInUser.picture!,
            email: logedInUser.email!
        )
        _ = try Connection.get(forKey: ConnectionName.dybamodb)?.create(user)
        context.session?["currentUser"] = try user.serializeToDictionary()
    }
    
    return Response(
        status: .found,
        headers: [
            "Location": "\(Configuration.shared.baseURLString)"
        ]
    )
}

auth.add(githubProvider)
app.use(HexavilleAuth.AuthenticationMiddleware())
app.use(auth)

var router = Router()

router.use(.get, middlewares: [AuthenticationMiddleware()], "/") { request, context in
    let data = try AssetLoader.shared.load(fileInAssets: "/html/index.html")
    let environment = Environment(extensions: [TemplateExtension.shared.ext])
    let rendered = try environment.renderTemplate(
        string: String(data: data, encoding: .utf8) ?? "",
        context: [
            "apiBaseURL": Configuration.shared.baseURLString,
            "userObject": try context.currentUser!.serializeToJSONString()
        ]
    )
    return Response(headers: ["Content-Type": "text/html"], body: rendered)
}

router.use(.get, "/logout") { request, context in
    context.session?.destroy()
    
    return Response(
        status: .found,
        headers: [
            "Location": "\(Configuration.shared.baseURLString)"
        ]
    )
}

var apiRouter = Router()

let authenticationMiddleware = AuthenticationMiddleware()

apiRouter.use(.get, middlewares: [authenticationMiddleware], "/api/todos", { request, context in
    let todos: [TODO] = try Connection.get(forKey: ConnectionName.dybamodb)?.fetch() ?? []
    return Response(headers: ["Content-Type": "application/json"], body: try JSONEncoder().encode(todos))
})

apiRouter.use(.post, middlewares: [authenticationMiddleware], "/api/todos", { request, context in
    var todo = TODO(
        text: try JSONDecoder().decode(TODOText.self, from: request.body.asData()),
        user: context.currentUser!
    )
    
    if let _todo = try Connection.get(forKey: ConnectionName.dybamodb)?.create(todo) {
        todo = _todo
    }
    return Response(
        status: .created,
        headers: ["Content-Type": "application/json"],
        body: try todo.serializeToJSONUTF8Data()
    )
})

apiRouter.use(.delete, middlewares: [authenticationMiddleware], "/api/todos/:id", { request, context in
    let id = request.params!["id"] as! String
    guard let todo: TODO = try Connection.get(forKey: ConnectionName.dybamodb)?.fetch(byID: id) else {
        let error = ErrorMessage(errorCode: nil, errorMessage: "Resource Not Found")
        let body = try JSONEncoder().encode(error)
        return Response(status: .notFound, body: body)
    }
    
    try Connection.get(forKey: ConnectionName.dybamodb)?.destroy(todo)
    return Response(headers: ["Content-Type": "application/json"])
})

app.use(router)
app.use(apiRouter)

app.catch { error in
    print(error) // logging
    return Response(status: .internalServerError, body: "\(error)".data)
}

try app.run()
