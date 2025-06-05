import Vapor

try await withApp { app in
    try await configure(app)
    try app.run()
}

func withApp(_ body: (Application) async throws -> Void) async throws {
    let app = try await Application(.detect())
    defer { app.shutdown() }
    try await body(app)
}