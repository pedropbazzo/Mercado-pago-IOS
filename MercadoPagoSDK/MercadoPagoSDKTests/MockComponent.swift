//
//  MockComponent.swift
//  MercadoPagoSDKTests
//
//  Created by Eden Torres on 1/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
@testable import MercadoPagoSDKV4
@objc public class TestComponent: NSObject {

    public func render() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }
}
