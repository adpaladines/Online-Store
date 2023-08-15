//
//  PaymentManager.swift
//  Payments
//
//  Created by Andres D. Paladines on 8/14/23.
//

import Foundation
import PassKit

class PaymentManager: NSObject, ObservableObject {

    typealias PaymentManagerCompletion = (PaymentStatus) -> Void

    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var summaryItems: [PKPaymentSummaryItem] = []
    var completionHandler: PaymentManagerCompletion?

    func payNowButtonTapped(summaryItems: [PKPaymentSummaryItem], completion: @escaping PaymentManagerCompletion) {
        self.completionHandler = completion
        let paymentRequest = paymentRequest(summaryItems: summaryItems)
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.masterCard,.amex,.visa,.discover]) {
            let paymentAuthorizationController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
            paymentAuthorizationController.delegate = self
            paymentAuthorizationController.present { presented in
                print("Authorization screen shown: \(presented)")
                if presented {
                    completion(.inProcess)
                }
            }
        }

    }

    private func paymentRequest(summaryItems: [PKPaymentSummaryItem]) -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.apaladines.techconsulting.the.sounds.store.app.TheSoundsStoreCoreData"
        request.supportedNetworks = [.masterCard, .visa, .amex, .discover]
        request.supportedCountries = ["US", "GB", "IN", "ER"]
        request.merchantCapabilities = .capability3DS // protocol

        request.countryCode = "US" //"GB"
        request.currencyCode = "USD" //"GBP"

        request.requiredShippingContactFields = [.name,.emailAddress,.phoneNumber,.postalAddress]
        request.paymentSummaryItems = summaryItems

        return request
    }

}


extension PaymentManager: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {

        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler?(.success)
                }else {
                    self.completionHandler?(.failure)
                }
            }
        }
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            self.paymentStatus = .failure
        }else {
            self.paymentStatus = .success
        }

        completion(paymentStatus)
    }

}
