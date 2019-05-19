//
//  MainExamplesViewController.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@interface MainExamplesViewController : UITableViewController <PXLazyInitProtocol, PXLifeCycleProtocol, PXTrackerListener>

@property MercadoPagoCheckoutBuilder *checkoutBuilder;

@property PXCheckoutPreference *pref;
@property PXPaymentConfiguration *paymentConfig;

+(void)setPaymentDataCallback;

@end
