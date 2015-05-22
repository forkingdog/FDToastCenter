//
//  FDToastItem.m
//  FDToastCenter
//
//  Created by Daifu Tang  on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "FDToastItem.h"

@interface FDToastItem ()

@property (nonatomic, strong) NSDate *startDate;
- (void)startWithDuration:(NSTimeInterval)duration;

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

