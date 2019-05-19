//
//  OneTapFlow+PaymentFlow.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 23/07/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

extension OneTapFlow {
    func startPaymentFlow() {
        guard let paymentFlow = model.paymentFlow else {
            return
        }
        model.invalidESC = false
        paymentFlow.paymentErrorHandler = self
        if isShowingLoading() {
            self.pxNavigationHandler.presentLoading()
        }
        paymentFlow.setData(amountHelper: model.amountHelper, checkoutPreference: model.checkoutPreference, resultHandler: self)
        paymentFlow.start()
    }

    func isShowingLoading() -> Bool {
        return pxNavigationHandler.isLoadingPresented() || pxNavigationHandler.isShowingDynamicViewController()
    }
}

extension OneTapFlow: PXPaymentResultHandlerProtocol {
    func finishPaymentFlow(error: MPSDKError) {
        guard let reviewScreen = pxNavigationHandler.navigationController.viewControllers.last as? PXOneTapViewController else {
            return
        }
        reviewScreen.resetButton(error: error)
    }

    func finishPaymentFlow(paymentResult: PaymentResult, instructionsInfo: PXInstructions?) {
        self.model.paymentResult = paymentResult
        self.model.instructionsInfo = instructionsInfo
        if isShowingLoading() {
            self.executeNextStep()
        } else {
            PXAnimatedButton.animateButtonWith(status: paymentResult.status, statusDetail: paymentResult.statusDetail)
        }
    }

    func finishPaymentFlow(businessResult: PXBusinessResult) {
        self.model.businessResult = businessResult
        if isShowingLoading() {
            self.executeNextStep()
        } else {
            PXAnimatedButton.animateButtonWith(status: businessResult.getBusinessStatus().getDescription())
        }
    }
}

extension OneTapFlow: PXPaymentErrorHandlerProtocol {
    func escError() {
        model.readyToPay = true
        model.invalidESC = true
        model.escManager?.deleteESC(cardId: model.paymentData.getToken()?.cardId ?? "")
        model.paymentData.cleanToken()
        executeNextStep()
    }
}
