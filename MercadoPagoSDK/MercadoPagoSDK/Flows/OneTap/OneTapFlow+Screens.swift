//
//  OneTapFlow+Screens.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 09/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

extension OneTapFlow {
    func showReviewAndConfirmScreenForOneTap() {
        let reviewVC = PXOneTapViewController(viewModel: model.reviewConfirmViewModel(), timeOutPayButton: model.getTimeoutForOneTapReviewController(), callbackPaymentData: { [weak self] (paymentData: PXPaymentData) in
            self?.cancelFlowForNewPaymentSelection()
            return
            }, callbackConfirm: {(paymentData: PXPaymentData, splitAccountMoneyEnabled: Bool) in
                self.model.updateCheckoutModel(paymentData: paymentData, splitAccountMoneyEnabled: splitAccountMoneyEnabled)
                // Deletes default one tap option in payment method search
                self.executeNextStep()
        }, callbackUpdatePaymentOption: { [weak self] (newPaymentOption: PaymentMethodOption) in
            if let card = newPaymentOption as? PXCardSliderViewModel, let newPaymentOptionSelected = self?.getCustomerPaymentOption(forId: card.cardId ?? "") {
                // Customer card.
                self?.model.paymentOptionSelected = newPaymentOptionSelected
            } else {
                // AM
                if newPaymentOption.getId() == PXPaymentTypes.ACCOUNT_MONEY.rawValue {
                    self?.model.paymentOptionSelected = newPaymentOption
                }
            }
        }, callbackExit: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cancelFlow()
            }, finishButtonAnimation: {
                self.executeNextStep()
        })

        self.pxNavigationHandler.pushViewController(viewController: reviewVC, animated: true)
    }

    func showSecurityCodeScreen() {
        let securityCodeVc = SecurityCodeViewController(viewModel: model.savedCardSecurityCodeViewModel(), collectSecurityCodeCallback: { [weak self] (_, securityCode: String) -> Void in
            self?.getTokenizationService().createCardToken(securityCode: securityCode)
        })
        self.pxNavigationHandler.pushViewController(viewController: securityCodeVc, animated: true)
    }
}
