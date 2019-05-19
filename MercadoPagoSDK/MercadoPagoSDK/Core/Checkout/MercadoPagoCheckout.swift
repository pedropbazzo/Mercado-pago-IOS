//
//  MercadoPagoCheckout.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/23/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

/**
 Main class of this project.
 It provides access to most of the checkout experience.
 */
@objcMembers
open class MercadoPagoCheckout: NSObject {
    internal enum InitMode {
        case normal
        case lazy
    }

    internal var initMode: InitMode = .normal
    internal var initProtocol: PXLazyInitProtocol?
    internal static var currentCheckout: MercadoPagoCheckout?
    internal var viewModel: MercadoPagoCheckoutViewModel

    // MARK: Initialization
    /**
     Mandatory init. Based on `MercadoPagoCheckoutBuilder`
     - parameter builder: MercadoPagoCheckoutBuilder object.
     */
    public init(builder: MercadoPagoCheckoutBuilder) {
        var choPref: PXCheckoutPreference

        if let preferenceId = builder.preferenceId {
            choPref = PXCheckoutPreference(preferenceId: preferenceId)
        } else if let preference = builder.checkoutPreference {
            choPref = preference
            SiteManager.shared.setSite(siteId: choPref.getSiteId())
        } else {
            fatalError("CheckoutPreference or preferenceId must be mandatory.")
        }

        viewModel = MercadoPagoCheckoutViewModel(checkoutPreference: choPref, publicKey: builder.publicKey, privateKey: builder.privateKey, advancedConfig: builder.advancedConfig)

        // Set Theme.
        if let customTheme = builder.advancedConfig?.theme {
            ThemeManager.shared.setTheme(theme: customTheme)
        } else if let defaultColor = builder.defaultUIColor {
            ThemeManager.shared.setDefaultColor(color: defaultColor)
        }

        if let paymentConfiguration = builder.paymentConfig {
            let (chargeRules, paymentPlugin, paymentMethodPlugins) = paymentConfiguration.getPaymentConfiguration()

            // Set charge rules
            viewModel.chargeRules = chargeRules

            // Payment method plugins.
            viewModel.paymentMethodPlugins = paymentMethodPlugins
            viewModel.paymentMethodPluginsToShow = paymentMethodPlugins

            // Payment plugin (paymentProcessor).
            viewModel.paymentPlugin = paymentPlugin
        }

        viewModel.updateInitFlow()
    }
}

// MARK: Publics
extension MercadoPagoCheckout {

    /**
     Start checkout experience. This method push our ViewController in your navigation stack.
     - parameter navigationController: Instance of your `UINavigationController`.
     - parameter lifeCycleProtocol: Instance of `PXLifeCycleProtocol` implementation. Provide this protocol in order to get notifications related to our checkout lifecycle. (`FinishCheckout` and `CancelCheckout`)
     */
    public func start(navigationController: UINavigationController, lifeCycleProtocol: PXLifeCycleProtocol?=nil) {
        viewModel.lifecycleProtocol = lifeCycleProtocol
        commondInit()
        ThemeManager.shared.initialize()
        viewModel.setNavigationHandler(handler: PXNavigationHandler(navigationController: navigationController))
        ThemeManager.shared.saveNavBarStyleFor(navigationController: navigationController)
        if initMode == .lazy {
            if viewModel.initFlow?.getStatus() == .finished {
                executeNextStep()
            } else {
                if viewModel.initFlow?.getStatus() == .running {
                    return
                } else {
                    // Lazy with "ready" to run.
                    viewModel.pxNavigationHandler.presentInitLoading()
                    executeNextStep()
                }
            }
        } else {
            viewModel.pxNavigationHandler.presentInitLoading()
            executeNextStep()
        }
    }

    /**
     Start checkout init services in lazy mode (without UI). Start our init methods and provide a protocol to notify when the checkout is ready to launch `PXLazyInitProtocol`
     - parameter lazyInitProtocol: Implementation of `PXLazyInitProtocol`.
     */
    public func start(lazyInitProtocol: PXLazyInitProtocol) {
        viewModel.initFlow?.restart()
        initProtocol = lazyInitProtocol
        initMode = .lazy
        commondInit()
        executeNextStep()
    }
}

// MARK: Internals
extension MercadoPagoCheckout {
    internal func setPaymentResult(paymentResult: PaymentResult) {
        self.viewModel.paymentResult = paymentResult
        self.viewModel.splitAccountMoney = self.viewModel.paymentResult?.splitAccountMoney
        if let paymentData = paymentResult.paymentData {
            self.viewModel.paymentData = paymentData
        }
    }

    internal func setPaymentData(paymentData: PXPaymentData) {
        self.viewModel.paymentData = paymentData
    }

    internal func enableBetaServices() {
        PXServicesSettings.enableBetaServices()
        PXTrackingSettings.enableBetaServices()
    }

    internal func setCheckoutPreference(checkoutPreference: PXCheckoutPreference) {
        self.viewModel.checkoutPreference = checkoutPreference
    }

    internal func executePreviousStep(animated: Bool = true) {
        viewModel.pxNavigationHandler.navigationController.popViewController(animated: animated)
    }

    internal func executeNextStep() {
        switch self.viewModel.nextStep() {
        case .START :
            self.initialize()
        case .SCREEN_PAYMENT_METHOD_SELECTION:
            self.showPaymentMethodsScreen()
        case .SCREEN_CARD_FORM:
            self.showCardForm()
        case .SCREEN_IDENTIFICATION:
            self.showIdentificationScreen()
        case .SCREEN_PAYER_INFO_FLOW:
            self.showPayerInfoFlow()
        case .SCREEN_ENTITY_TYPE:
            self.showEntityTypesScreen()
        case .SCREEN_FINANCIAL_INSTITUTIONS:
            self.showFinancialInstitutionsScreen()
        case .SERVICE_GET_ISSUERS:
            self.getIssuers()
        case .SCREEN_ISSUERS:
            self.showIssuersScreen()
        case .SERVICE_CREATE_CARD_TOKEN:
            self.getTokenizationService().createCardToken()
        case .SERVICE_GET_IDENTIFICATION_TYPES:
            self.getIdentificationTypes()
        case .SERVICE_GET_PAYER_COSTS:
            self.getPayerCostsConfiguration()
        case .SCREEN_PAYER_COST:
            self.showPayerCostScreen()
        case .SCREEN_REVIEW_AND_CONFIRM:
            self.showReviewAndConfirmScreen()
        case .SCREEN_SECURITY_CODE:
            self.showSecurityCodeScreen()
        case .SERVICE_POST_PAYMENT:
            self.createPayment()
        case .SCREEN_PAYMENT_RESULT:
            self.showPaymentResultScreen()
        case .ACTION_FINISH:
            self.finish()
        case .SCREEN_ERROR:
            self.showErrorScreen()
        case .SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG:
            self.showHookScreen(hookStep: .BEFORE_PAYMENT_METHOD_CONFIG)
        case .SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG:
            self.showHookScreen(hookStep: .AFTER_PAYMENT_METHOD_CONFIG)
        case .SCREEN_HOOK_BEFORE_PAYMENT:
            self.showHookScreen(hookStep: .BEFORE_PAYMENT)
        case .SCREEN_PAYMENT_METHOD_PLUGIN_CONFIG:
            self.showPaymentMethodPluginConfigScreen()
        case .FLOW_ONE_TAP:
            self.startOneTapFlow()
        }
    }

    internal func finish() {
        MPXTracker.sharedInstance.clean()
        viewModel.pxNavigationHandler.removeRootLoading()
        ThemeManager.shared.applyAppNavBarStyle(navigationController: viewModel.pxNavigationHandler.navigationController)
        PXCheckoutStore.sharedInstance.clean()
        // LifecycleProtocol.finishCheckout - defined
        // Exit checkout with payment. (by state machine next)
        let result = viewModel.getResult()
        if let finishCallback = viewModel.lifecycleProtocol?.finishCheckout() {
            finishCallback(result)
            return
        }
        defaultExitAction()
    }

    internal func cancelCheckout() {
        closeCheckout()
    }

    /// :nodoc:
    @objc func closeCheckout() {
        MPXTracker.sharedInstance.clean()
        PXNotificationManager.UnsuscribeTo.attemptToClose(self)
        PXCheckoutStore.sharedInstance.clean()
        ThemeManager.shared.applyAppNavBarStyle(navigationController: viewModel.pxNavigationHandler.navigationController)

        // LifecycleProtocol.finishCheckout - defined
        // Exit checkout with payment. (by closeAction)
        if viewModel.getGenericPayment() != nil {
            let result = viewModel.getResult()
            if let finishCallback = viewModel.lifecycleProtocol?.finishCheckout() {
                finishCallback(result)
            } else {
                defaultExitAction()
            }
            return
        }

        // LifecycleProtocol.cancelCheckout - defined
        // Exit checkout without payment. (by back stack action)
        if let lifecycle = viewModel.lifecycleProtocol, let cancelCustomAction = lifecycle.cancelCheckout() {
            cancelCustomAction()
            return
        }

        // Default exit. Without LifecycleProtocol returns.
        defaultExitAction()
    }
}

// MARK: Privates
extension MercadoPagoCheckout {

    private func initialize() {
        startTracking()
        MercadoPagoCheckout.currentCheckout = self

        initializeEscManager()

        if let currentCheckout = MercadoPagoCheckout.currentCheckout {
            PXNotificationManager.SuscribeTo.attemptToClose(currentCheckout, selector: #selector(closeCheckout))
        }
        viewModel.startInitFlow()
    }

    // Chnage in Q2 when esc info comes in the init flow
    private func initializeEscManager() {
        viewModel.escManager = PXESCManager(enabled: viewModel.getAdvancedConfiguration().escEnabled, sessionId: MPXTracker.sharedInstance.getSessionID())
    }

    private func commondInit() {
        viewModel.setInitFlowProtocol(flowInitProtocol: self)
        if !viewModel.shouldApplyDiscount() {
            viewModel.clearDiscount()
        }
    }

    private func removeDiscount() {
        self.viewModel.clearDiscount()
    }

    private func defaultExitAction() {
        viewModel.pxNavigationHandler.goToRootViewController()
    }
}
