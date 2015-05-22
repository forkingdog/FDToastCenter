//
//  FDToastCenter.m
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "FDToastCenter.h"
#import "FDToastView.h"
#import "FDToastItem.h"

@interface FDToastCenter () <FDToastItemDelegate>

@property (nonatomic, strong) NSMutableArray *items;
- (void)notifyNextToastItem:(FDToastItem *)item;

@end

@implementation FDToastCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
    }
    return self;
}

- (void)addToastItem:(FDToastItem *)item
{
    NSParameterAssert(item);
    item.delegate = self;
    
    FDToastItem *car = self.items.firstObject;
    [self.items addObject:item];
    
    if (!car) {
        [item start];
    } else {
        
        NSArray *cdr = [self.items subarrayWithRange:(NSRange){1, self.items.count - 1}];
        NSTimeInterval duration = MAX(0.5, 2.0 / self.items.count);
        [cdr setValue:@(duration) forKey:NSStringFromSelector(@selector(duration))];
    }
}

- (void)itemDidActive:(FDToastItem *)item
{
    [self notifyNextToastItem:item];
}

- (void)itemDidComplete:(FDToastItem *)item
{
    [self.items removeObject:item];
    FDToastItem *next = self.items.firstObject;
    if (!next) {
        [self notifyNextToastItem:nil];
    } else {
        [next start];
    }
}

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

+ (void)addToastItem:(FDToastItem *)item
{
    [[self sharedCenter] addToastItem:item];
}

- (void)notifyNextToastItem:(FDToastItem *)item
{
    if (item) {
        [[FDToastView sharedView] setMessage:item.message];
        [FDToastView showInWindow:[self currentWindow]];
    } else {
        [FDToastView dismiss];
    }
}

@end
