//
//  TCDemoViewController.m
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "TCDemoViewController.h"
#import "FDToastCenter.h"

@interface TCDemoViewController ()

@property (nonatomic, assign) NSInteger toastCount;

@end

@implementation TCDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showRandomButtonTapped:(id)sender
{
    @synchronized(self) {
        self.toastCount ++;
        
        FDToastItem *item = [FDToastItem new];
        item.message = [NSString stringWithFormat:@"第 %@ 条通知", @(self.toastCount)];
        [FDToastCenter addToastItem:item];
    }
}

@end
