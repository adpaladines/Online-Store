//
//  PaymentError.swift
//  TheSoundsStoreCoreData
//
//  Created by Consultant on 8/14/23.
//

import Foundation
import PassKit

enum PaymentStatus: Error {
    case success
    case failure
    case inProcess
    case none
}

extension PaymentStatus: LocalizedError, Equatable {

    mutating func getStatus(from paymentStatus: PKPaymentAuthorizationStatus) {
        switch paymentStatus {
        case .success:
            self = .success
        default:
            self = .failure
        }
    }

    var errorDescription: String? {
        let myError: String
        switch self {
        case .success:
            myError = NSLocalizedString("Payment Successfully!", comment: "success")
        case .failure:
            myError = NSLocalizedString("Payment failed.", comment: "failure")
        case .inProcess:
            myError = NSLocalizedString("Payment in progress.", comment: "inProcess")
        case .none:
            myError = NSLocalizedString("No action executed.", comment: "none")
        }
        return myError
    }

}
