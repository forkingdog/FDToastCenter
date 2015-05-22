//
//  FDToastItem.h
//  FDToastCenter
//
//  Created by Daifu Tang  on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSInteger, FDToastItemType) {
    FDToastItemRequest = 0,
    FDToastItemMessage
};

typedef NS_ENUM(NSInteger, FDToastItemState) {
    FDToastItemStateIdle = 0,
    FDToastItemStateActive,
    FDToastItemStateComplete
};

@protocol FDToastItemDelegate;

@interface FDToastItem : NSObject

@property (nonatomic, assign) FDToastItemType type;
@property (nonatomic, assign) FDToastItemState state;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) id <FDToastItemDelegate> delegate;
- (void)start;
- (void)finish;

@end


@protocol FDToastItemDelegate <NSObject>

@optional
- (void)itemDidActive:(FDToastItem *)item;
- (void)itemDidComplete:(FDToastItem *)item;

@end
