//
//  FDToastCenter.h
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDToastCenter : NSObject

+ (void)processError:(NSError *)error;
+ (void)bindRequest:(id)request;

@end
