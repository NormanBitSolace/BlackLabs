import Foundation

public enum NetworkError: Error {
    case noDataError
    case unknownError
    case messageError(String)
}
