import Foundation

@objc
public class SQFitnessError: NSObject, Error {

    @objc public let message: String
    @objc public let error: Error?

    init(with error: Error) {
        self.message = error.localizedDescription
        self.error = error
    }

    init(message: String) {
        self.message = message
        self.error = nil
    }
}
