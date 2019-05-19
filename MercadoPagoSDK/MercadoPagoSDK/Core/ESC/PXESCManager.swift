//
//  PXESCManager.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

#if PX_PRIVATE_POD
    import MLESCManager
#endif

@objcMembers
internal class PXESCManager: NSObject, MercadoPagoESC {

    private var isESCEnabled: Bool = false
    private var sessionId: String

    #if PX_PRIVATE_POD
        var mLESCManager: MLESCManager
    #endif

    init(enabled: Bool, sessionId: String) {
        self.isESCEnabled = enabled
        self.sessionId = sessionId
        #if PX_PRIVATE_POD
            mLESCManager = MLESCManager(sessionId: sessionId)
        #endif
    }

    func hasESCEnable() -> Bool {
        #if PX_PRIVATE_POD
            return isESCEnabled
         #else
            return false
         #endif
    }

    func getESC(cardId: String, firstSixDigits: String, lastFourDigits: String) -> String? {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            let esc = mLESCManager.getESC(cardId: cardId, firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            return esc
            #endif
        }
        return nil
    }

    @discardableResult
    func saveESC(cardId: String, esc: String) -> Bool {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
               return mLESCManager.saveESC(cardId: cardId, esc: esc)
            #endif
        }
        return false
    }

    @discardableResult
    func saveESC(firstSixDigits: String, lastFourDigits: String, esc: String) -> Bool {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            return mLESCManager.saveESC(esc: esc, firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            #endif
        }
        return false
    }

    func deleteESC(cardId: String) {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
                mLESCManager.deleteESC(cardId: cardId)
            #endif
        }
    }

    func deleteESC(firstSixDigits: String, lastFourDigits: String) {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            mLESCManager.deleteESC(firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            #endif
        }
    }

    func deleteAllESC() {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
                mLESCManager.deleteAllESC()
            #endif
        }
    }

    func getSavedCardIds() -> [String] {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
               mLESCManager.getSavedCardIds()
            #endif
        }
        return []
    }
}
