//
//  ReviewMockComponentHelper.swift
//  MercadoPagoSDKTests
//
//  Created by Eden Torres on 3/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
@testable import MercadoPagoSDKV4

public class ReviewMockComponentHelper: NSObject {

    static func buildReviewViewModel(checkoutPreference: PXCheckoutPreference, reviewScreenPreference: PXReviewConfirmConfiguration = PXReviewConfirmConfiguration()) -> PXReviewViewModel {
        let paymentOptionSelected = MockBuilder.buildPaymentOptionSelected("id")
        let amountHelper = PXAmountHelper(preference: checkoutPreference, paymentData: MockBuilder.buildPaymentData(), discount: nil, campaign: nil, chargeRules: [], consumedDiscount: false)
        let reviewViewModel = PXReviewViewModel(amountHelper: amountHelper, paymentOptionSelected: paymentOptionSelected, reviewConfirmConfig: reviewScreenPreference, userLogged: true)
        return reviewViewModel
    }

    static func buildResultViewModelWithPreference(items: [PXItem], reviewScreenPreference: PXReviewConfirmConfiguration = PXReviewConfirmConfiguration()) -> PXReviewViewModel {

        let preference = PXCheckoutPreference(siteId: "MLA", payerEmail: "sarasa@mercadolibre.com", items: items)

        let reviewViewModel = ReviewMockComponentHelper.buildReviewViewModel(checkoutPreference: preference, reviewScreenPreference: reviewScreenPreference)
        return reviewViewModel
    }

    static func buildItemComponentView(reviewViewModel: PXReviewViewModel) -> [PXItemContainerView] {
        var itemViews = [PXItemContainerView]()
        let itemComponents = reviewViewModel.buildItemComponents()
        for item in itemComponents {
            itemViews.append(PXItemRenderer().render(item))
        }
        return itemViews
    }
}
