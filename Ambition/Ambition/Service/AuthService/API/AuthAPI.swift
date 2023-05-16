import Foundation
import Moya

enum AuthAPI {
    case login(email: String, password: String)
    case singup(email: String, password: String, name: String, age: Int, sex: String)
    case logout
    case deleteUser
    case getUserprofile
    case patchUserProfile
    case reissuanceRefreshToken
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.201.207.196:8888/users")!
    }

    var path: String {
        switch self {
        case .login:
            return "/token"
        case .reissuanceRefreshToken:
            return "/auth"
        case .singup, .deleteUser, .getUserprofile:
            return ""
        case .logout:
            return "/logout"
        case .patchUserProfile:
            return "/update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserprofile:
            return .get
        case .login, .singup:
            return .post
        case .reissuanceRefreshToken, .patchUserProfile:
            return .patch
        case .logout, .deleteUser:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .singup(let email, let password, let name, let age, let sex):
            return .requestParameters(parameters: [
                "email": email,
                "password": password,
                "name": name,
                "age": age,
                "sex": sex
            ], encoding: JSONEncoding.default)
        case .login(let email, let password):
            return .requestParameters(parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .patchUserProfile, .getUserprofile, .logout, .deleteUser:
            return Header.accessToken.header()
        case .reissuanceRefreshToken:
            return Header.refreshToken.header()
        default:
            return Header.tokenIsEmpty.header()
        }
    }
}
