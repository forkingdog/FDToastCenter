//
//  FDToastView.m
//  FDToastCenter
//
//  Created by Phil on 15/5/22.
//  Copyright (c) 2015年 Forking Dog. All rights reserved.
//

#import "FDToastView.h"
@import QuartzCore;

@interface FDToastView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, copy) NSArray *constraintsToSuperview;

// temp
@property (nonatomic, strong) CAShapeLayer *iconBorderLayer;

@end

/**
 * Capabilities needed:
 *
 * 1. Screen size awareness.
 * 2. Content type switch transition.
 * 3. UIVisualEffect blur.
 * 4. Custom activity indicator.
 *
 */

@implementation FDToastView

+ (instancetype)sharedView
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[UINib nibWithNibName:@"FDToastView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    });
    return instance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupAppearance];
    [self setupMotionEffect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutBorder];
}

#pragma mark - Temp border

- (CAShapeLayer *)iconBorderLayer
{
    if (!_iconBorderLayer) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        borderLayer.fillColor = nil;
        borderLayer.lineDashPattern = @[@4, @2];
        borderLayer.lineWidth = 2.0;
        [self.iconView.layer addSublayer:borderLayer];
        _iconBorderLayer = borderLayer;
    }
    return _iconBorderLayer;
}

- (void)layoutBorder
{
    self.iconView.layer.cornerRadius = 5.0;
    self.iconBorderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.iconView.bounds cornerRadius:5.0].CGPath;
    self.iconBorderLayer.frame = self.iconView.bounds;
}

#pragma mark - Initializations

- (void)setupAppearance
{
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.clipsToBounds = YES;
}

- (void)setupMotionEffect
{
	UIInterpolatingMotionEffect *xAxis = [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis
															keyPath:@"center.x"];
	UIInterpolatingMotionEffect *yAxis = [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
															keyPath:@"center.y"];
	UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
	group.motionEffects = @[xAxis, yAxis];
	
	[self.contentView addMotionEffect:group];
}

#pragma mark - Factories

- (UIInterpolatingMotionEffect *)motionEffectWithType:(UIInterpolatingMotionEffectType)motionEffectType
											  keyPath:(NSString *)keypath
{
	UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc]
												 initWithKeyPath:keypath
												 type:motionEffectType];
	motionEffect.minimumRelativeValue = @(-10);
	motionEffect.maximumRelativeValue = @(10);
	
	return motionEffect;
}

- (NSArray *)constraintsForCenterInBothDimensionsInView:(UIView *)view
{
    return @[
             [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
             [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
             ];
}

#pragma mark - Setters

- (void)setIconType:(FDToastViewIconType)iconType
{
    _iconType = iconType;
}

- (void)setMessage:(NSString *)message
{
    _message = message;

    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [self.messageLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];

    self.messageLabel.text = message;
    self.messageLabel.hidden = message.length == 0;

    [self updateLayoutAnimateIfNeeded];
}

#pragma mark - APIs

+ (void)showInWindow:(UIWindow *)window
{
    [[self sharedView] showInWindow:window];
}

+ (void)randomizeContent
{
    NSString *fullString = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse posuere diam quis euismod dictum. Aenean ac felis neque. Donec commodo enim eu condimentum mollis. Aliquam vulputate urna vel justo venenatis, vel varius leo posuere.";
    NSString *message = [fullString substringToIndex:random() % fullString.length];
    [[self sharedView] setMessage:message];
}

#pragma mark - Appearances Helpers

- (void)showInWindow:(UIWindow *)window
{
	if (self.superview) {
		[self.superview removeConstraints:self.constraintsToSuperview];
		[self removeFromSuperview];
	}

    if (self.superview != window) {
        [window addSubview:self];
        self.center = window.center;

        self.constraintsToSuperview = [self constraintsForCenterInBothDimensionsInView:window];
        [window addConstraints:self.constraintsToSuperview];
    }
}

- (BOOL)isVisible
{
	return (self.superview != nil && self.alpha > 0);
}

- (void)updateLayoutAnimateIfNeeded
{
    if (self.isVisible) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
            [self triggerLayout];
        } completion:nil];
    } else {
        [self triggerLayout];
	}
}

- (void)triggerLayout
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
    [self layoutIfNeeded];
}

@end
