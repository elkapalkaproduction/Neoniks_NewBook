//
//  WYPopoverBackgroundInnerView.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPopoverBackgroundInnerView : UIView

@property (nonatomic, strong) UIColor *innerStrokeColor;

@property (nonatomic, strong) UIColor *gradientTopColor;
@property (nonatomic, strong) UIColor *gradientBottomColor;
@property (nonatomic, assign) float gradientHeight;
@property (nonatomic, assign) float gradientTopPosition;

@property (nonatomic, strong) UIColor *innerShadowColor;
@property (nonatomic, assign) CGSize innerShadowOffset;
@property (nonatomic, assign) float innerShadowBlurRadius;
@property (nonatomic, assign) float innerCornerRadius;

@property (nonatomic, assign) float navigationBarHeight;
@property (nonatomic, assign) BOOL wantsDefaultContentAppearance;
@property (nonatomic, assign) float borderWidth;

@end