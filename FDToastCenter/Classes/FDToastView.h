//
//  FDToastView.h
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FDToastViewIconType) {
    FDToastViewIconActivityIndicator = 0,
    FDToastViewIconSuccess,
    FDToastViewIconError
};

@interface FDToastView : UIView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) FDToastViewIconType iconType;

+ (void)showInWindow:(UIWindow *)window;
+ (void)dismiss;

// temp
+ (void)randomizeContent;

+ (instancetype)sharedView;

@end
