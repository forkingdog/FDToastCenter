//
//  FDToastController.m
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "FDToastController.h"
#import "FDToastController+View.h"
#import "FDToastView.h"

@protocol FDToastItemDelegate <NSObject>

@optional
- (void)itemDidActive:(FDToastItem *)item;
- (void)itemDidComplete:(FDToastItem *)item;

@end

@interface FDToastItem ()

@property (nonatomic, weak) id <FDToastItemDelegate> delegate;
@property (nonatomic, strong) NSDate *startDate;
- (void)start;
- (void)startWithDuration:(NSTimeInterval)duration;
- (void)finish;

@end

@implementation FDToastItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 2.0;
        _type = FDToastItemMessage;
        _message = @"unknown tosat message.";
    }
    return self;
}

- (void)startWithDuration:(NSTimeInterval)duration
{
    if (self.state == FDToastItemStateIdle) {
        self.state = FDToastItemStateActive;
        self.startDate = [NSDate date];
        if ([self.delegate respondsToSelector:@selector(itemDidActive:)]) {
            [self.delegate itemDidActive:self];
        }
        [self performSelector:@selector(finish) withObject:nil afterDelay:duration];
    }
}

- (void)start
{
    switch (self.type) {
        case FDToastItemMessage:
            [self startWithDuration:self.duration];
            break;
            
        default:
            break;
    }
}

- (void)finish
{
    if ([self.delegate respondsToSelector:@selector(itemDidComplete:)]) {
        [self.delegate itemDidComplete:self];
    }
    
    self.delegate = nil;
}

@end

@interface FDToastController () <FDToastItemDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation FDToastController

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
        NSTimeInterval duration = MAX(0.5, 2.0 / cdr.count);
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
    [(FDToastItem *)self.items.firstObject start];
}
@end
