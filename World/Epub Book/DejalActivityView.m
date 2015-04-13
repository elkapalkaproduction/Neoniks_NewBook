//
//  DejalActivityView.m
//  Dejal Open Source
//
//  Created by David Sinclair on 2009-07-26.
//  Copyright (c) 2009-2013 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  Credit: inspired by Matt Gallagher's LoadingView blog post:
//  http://cocoawithlove.com/2009/04/showing-message-over-iphone-keyboard.html
//

#import "DejalActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface DejalActivityView ()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityLabel;

@end

@implementation DejalActivityView

static DejalActivityView *dejalActivityView = nil;

+ (DejalActivityView *)activityViewForView:(UIView *)addToView {
    return [self activityViewForView:addToView withLabel:NSLocalizedString(@"Loading...", @"Default DejalActivtyView label text")];
}


+ (DejalActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText {
    // Immediately remove any existing activity view:
    if (dejalActivityView) [self removeView];

    // Remember the new view (so this is a singleton):
    dejalActivityView = [[self alloc] initForView:addToView withLabel:labelText];

    return dejalActivityView;
}


- (DejalActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText {
    if (!(self = [super initWithFrame:CGRectZero])) return nil;

    // Configure this view (the background) and its subviews:
    [self setupBackground];
    self.borderView = [self makeBorderView];
    self.activityIndicator = [self makeActivityIndicator];
    self.activityLabel = [self makeActivityLabelWithText:labelText];

    // Assemble the subviews:
    [addToView addSubview:self];
    [self addSubview:self.borderView];
    [self.borderView addSubview:self.activityIndicator];
    [self.borderView addSubview:self.activityLabel];

    return self;
}


- (void)dealloc {
    if ([dejalActivityView isEqual:self]) dejalActivityView = nil;
}


+ (void)removeView {
    if (!dejalActivityView) return;

    [dejalActivityView removeFromSuperview];

    dejalActivityView = nil;
}


- (void)setupBackground {
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (UIView *)makeBorderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    return view;
}


- (UIActivityIndicatorView *)makeActivityIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    [indicator startAnimating];

    return indicator;
}


- (UILabel *)makeActivityLabelWithText:(NSString *)labelText {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];

    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = labelText;

    return label;
}


- (CGRect)borderFrameBasedOnTextSize:(CGSize)textSize {
    CGRect borderFrame = CGRectZero;
    borderFrame.size.width = self.activityIndicator.frame.size.width + textSize.width + 25.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + 10.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height - 20.0));
    
    return borderFrame;
}


- (CGRect)indicatorFrameBasedOnBorderFrame:(CGRect)borderFrame {
    CGRect indicatorFrame = self.activityIndicator.frame;
    indicatorFrame.origin.x = 10.0;
    indicatorFrame.origin.y = 0.5 * (borderFrame.size.height - indicatorFrame.size.height);
    
    return indicatorFrame;
}


- (CGRect)labelFrameBasedOnBorderFrame:(CGRect)borderFrame {
    CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = borderFrame.size.width - labelFrame.size.width - 10.0;
    labelFrame.origin.y = floor(0.5 * (borderFrame.size.height - labelFrame.size.height));
    
    return labelFrame;
}


- (void)layoutSubviews {
    self.frame = self.superview.bounds;

    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform)) return;

    CGSize textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    self.borderView.frame = [self borderFrameBasedOnTextSize:textSize];
    self.activityIndicator.frame = [self indicatorFrameBasedOnBorderFrame:self.borderView.frame];
    self.activityLabel.frame = [self labelFrameBasedOnBorderFrame:self.borderView.frame];
}

@end
