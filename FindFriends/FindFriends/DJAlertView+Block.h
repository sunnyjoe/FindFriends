//
//  UIAlertView+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJAlertView.h"

typedef void (^VoidBlock)();

typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface DJAlertView (Block)

+ (DJAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message;

+ (DJAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle;

+ (DJAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed                   
                           onCancel:(CancelBlock) cancelled;

@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end
