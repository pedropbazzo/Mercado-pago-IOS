//
//  MockConfigPaymentMethodPlugin.swift
//  MercadoPagoSDKTests
//
//  Created by Eden Torres on 12/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

@testable import MercadoPagoSDKV4

open class MockConfigPaymentMethodPlugin: UIViewController {

    var shouldSkip = false

    init(shouldSkip: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.shouldSkip = shouldSkip
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Plugin implementation delegates.
extension MockConfigPaymentMethodPlugin: PXPaymentMethodConfigProtocol {
    public func configViewController() -> UIViewController? {
        return nil
    }

    public func render(store: PXCheckoutStore, theme: PXTheme) -> UIView? {
        return self.view
    }

    public func shouldSkip(store pluginStore: PXCheckoutStore) -> Bool {
        return shouldSkip
    }
}
