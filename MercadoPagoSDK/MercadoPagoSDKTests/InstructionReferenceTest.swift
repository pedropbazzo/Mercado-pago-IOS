//
//  InstructionReferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class InstructionReferenceTest: BaseTest {

    func testGetFullReferenceValue() {
        let instructionReference = PXInstructionReference(label: nil, fieldValue: ["1", "2", "3"], separator: "", comment: nil)
        var result = instructionReference.getFullReferenceValue()
        XCTAssertEqual(result, "123")

        instructionReference.separator = "-"
        result = instructionReference.getFullReferenceValue()
        XCTAssertEqual(result, "1-2-3")

    }
}
