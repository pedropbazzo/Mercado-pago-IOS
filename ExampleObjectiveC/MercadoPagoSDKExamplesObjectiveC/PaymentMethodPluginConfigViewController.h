//
//  PaymentMethodPluginConfigViewController.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Juan sebastian Sanzone on 18/12/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@interface PaymentMethodPluginConfigViewController : UIViewController <PXPaymentMethodConfigProtocol>
@end
