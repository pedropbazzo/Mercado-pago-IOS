//
//  PXOneTapHeaderProtocol.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 5/11/18.
//

import Foundation

protocol PXOneTapHeaderProtocol: NSObjectProtocol {
    func didTapSummary()
    func splitPaymentSwitchChangedValue(isOn: Bool, isUserSelection: Bool)
}
