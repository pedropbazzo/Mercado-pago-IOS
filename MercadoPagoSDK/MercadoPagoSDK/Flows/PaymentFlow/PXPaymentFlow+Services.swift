//
//  PXPaymentFlow+Services.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/07/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal extension PXPaymentFlow {
    func createPaymentWithPlugin(plugin: PXSplitPaymentProcessor?) {
        guard let plugin = plugin else {
            return
        }

        plugin.didReceive?(checkoutStore: PXCheckoutStore.sharedInstance)

        plugin.startPayment?(checkoutStore: PXCheckoutStore.sharedInstance, errorHandler: self as PXPaymentProcessorErrorHandler, successWithBasePayment: { [weak self] (basePayment) in
            self?.handlePayment(basePayment: basePayment)
        })
    }

    func createPayment() {
        guard let paymentData = model.amountHelper?.getPaymentData(), let checkoutPreference = model.checkoutPreference else {
            return
        }
        let mpPayment = MPPayment(preferenceId: checkoutPreference.id, publicKey: model.mercadoPagoServicesAdapter.mercadoPagoServices.merchantPublicKey, paymentData: paymentData, binaryMode: model.checkoutPreference?.isBinaryMode() ?? false)
        guard let paymentBody = (try? mpPayment.toJSON()) else {
            fatalError("Cannot make payment json body")
        }

        model.mercadoPagoServicesAdapter.createPayment(url: PXServicesURLConfigs.MP_API_BASE_URL, uri: PXServicesURLConfigs.MP_PAYMENTS_URI + "?api_version=" + PXServicesURLConfigs.API_VERSION, paymentDataJSON: paymentBody, query: nil, callback: { (payment) in
            self.handlePayment(payment: payment)

        }, failure: { [weak self] (error) in

            let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_PAYMENT.rawValue)

            // ESC error
            if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_WITH_ESC.rawValue) {
                self?.paymentErrorHandler?.escError()

                // Identification number error
            } else if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_IDENTIFICATION_NUMBER.rawValue) {
                self?.paymentErrorHandler?.identificationError?()

            } else {
                self?.showError(error: mpError)
            }

        })
    }

    func getInstructions() {
        guard let paymentResult = model.paymentResult else {
            fatalError("Get Instructions - Payment Result does no exist")
        }

        guard let paymentId = paymentResult.paymentId else {
            fatalError("Get Instructions - Payment Id does no exist")
        }

        guard let paymentTypeId = paymentResult.paymentData?.getPaymentMethod()?.paymentTypeId else {
            fatalError("Get Instructions - Payment Method Type Id does no exist")
        }

        model.mercadoPagoServicesAdapter.getInstructions(paymentId: paymentId, paymentTypeId: paymentTypeId, callback: { [weak self] (instructions) in
            self?.model.instructionsInfo = instructions
            self?.executeNextStep()

            }, failure: {[weak self] (error) in

                let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.GET_INSTRUCTIONS.rawValue)
                self?.showError(error: mpError)

        })
    }
}
