//
//  FDToastCenter.m
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "FDToastCenter.h"
#import "FDToastController.h"
#import "FDToastView.h"

@implementation FDToastCenter

+ (instancetype)sharedCenter
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}

- (UIWindow *)currentWindow
{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;

    if (!currentWindow) {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                currentWindow = window;
                break;
            }
        }
    }

    return currentWindow;
}

- (void)showDefaultView
{
    [FDToastView showInWindow:[self currentWindow]];
    [FDToastView randomizeContent];
}

+ (void)showDefaultView
{
    [[self sharedCenter] showDefaultView];
}

@end
