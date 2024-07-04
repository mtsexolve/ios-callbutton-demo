import Foundation

extension RegistrationState {
    var stringValue: String {
        return ["not registered",
                "registering",
                "registered",
                "offline",
                "no connection",
                "error"][rawValue]
    }
}

extension RegistrationError {
    var stringValue: String {
        return ["bad credentials",
                "authorization error",
                "connection error",
                "other error"][rawValue]
    }
}

extension CallError {
    var stringValue: String {
        return ["account not activated",
                "bad call uri",
                "not found",
                "forbidden",
                "address incomplete",
                "authorization error",
                "connection error",
                "location no access",
                "location no provider",
                "location timeout",
                "other error"][rawValue]
    }
}
