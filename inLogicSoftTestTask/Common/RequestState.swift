import Foundation

public enum RequestState: Equatable {
    
    case started(message: String? = nil, isCritical: Bool = false)
    case inProgress(Float)
    case finished
    case failed(Error?)
    case warning(String)
    case success(String?)
    
    public var inProgress: Bool {
        switch self {
        case .started, .inProgress:
            return true
            
        default:
            return false
        }
    }
    
    public static func == (lhs: RequestState, rhs: RequestState) -> Bool {
        switch (lhs, rhs) {
        case (.started, .started),
            (.finished, .finished):
            return true
            
        case (let .inProgress(lhsProgress), let .inProgress(rhsProgress)):
            return lhsProgress == rhsProgress
            
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError?.localizedDescription == rhsError?.localizedDescription
            
        case (let .warning(lhsWarning), let .warning(rhsWarning)):
            return lhsWarning == rhsWarning
            
        case (let .success(lhsSuccess), let .success(rhsSuccess)):
            return lhsSuccess == rhsSuccess
            
        default:
            return false
        }
    }
}
