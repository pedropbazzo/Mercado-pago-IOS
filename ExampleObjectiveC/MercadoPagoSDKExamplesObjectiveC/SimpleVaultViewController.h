//
//  SimpleVaultViewController.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 4/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@interface SimpleVaultViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property PXCard *customerCard;
@property bool allowInstallmentsSelection;

@end
