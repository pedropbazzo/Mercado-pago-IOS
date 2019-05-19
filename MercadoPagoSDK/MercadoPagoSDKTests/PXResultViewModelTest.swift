//
//  PXResultViewModelTest.swift
//  MercadoPagoSDKTests
//
//  Created by Demian Tejo on 31/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PXResultViewModelTest: BaseTest {

    func testPaymentResultStatus_isAccepted() {
        var resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.APPROVED.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isAccepted())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.IN_PROCESS.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isAccepted())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.PENDING.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isAccepted())
    }

    func testPaymentResultStatus_isWarning() {
        var resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.INVALID_ESC.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.CALL_FOR_AUTH.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.BAD_FILLED_CARD_NUMBER.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.CARD_DISABLE.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.INSUFFICIENT_AMOUNT.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.BAD_FILLED_DATE.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.BAD_FILLED_SECURITY_CODE.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.BAD_FILLED_OTHER.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isWarning())
    }

    func testPaymentResultStatus_isError() {
        var resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.HIGH_RISK.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.OTHER_REASON.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.MAX_ATTEMPTS.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.DUPLICATED_PAYMENT.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.INSUFFICIENT_DATA.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.REJECTED_BY_BANK.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
        resultViewModel = ResultMockComponentHelper.buildResultViewModel(status: PXPaymentStatus.REJECTED.rawValue, statusDetail: PXRejectedStatusDetail.REJECTED_PLUGIN_PM.rawValue)
        XCTAssertTrue(resultViewModel.paymentResult.isError())
    }

}
