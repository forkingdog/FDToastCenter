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

@end

@implementation TCDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showRandomButtonTapped:(id)sender
{
    [FDToastCenter showDefaultView];
}

@end
