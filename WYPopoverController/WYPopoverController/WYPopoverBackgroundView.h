//
//  WYPopoverBackgroundView.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverEnums.h"

@class WYPopoverBackgroundView;

@protocol WYPopoverBackgroundViewDelegate <NSObject>

@optional
- (void)popoverBackgroundViewDidTouchOutside:(WYPopoverBackgroundView *)backgroundView;

@end

@interface WYPopoverBackgroundView : UIView

- (id)initWithContentSize:(CGSize)aContentSize;

@property (nonatomic, assign) NSUInteger usesRoundedArrow                   UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger dimsBackgroundViewsTintColor       UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *tintColor                            UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *fillTopColor                         UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *fillBottomColor                      UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *glossShadowColor                     UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize glossShadowOffset                      UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger glossShadowBlurRadius              UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSUInteger borderWidth                        UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger arrowBase                          UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger arrowHeight                        UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *outerShadowColor                     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *outerStrokeColor                     UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger outerShadowBlurRadius              UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize outerShadowOffset                      UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger outerCornerRadius                  UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger minOuterCornerRadius               UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *innerShadowColor                     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *innerStrokeColor                     UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger innerShadowBlurRadius              UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize innerShadowOffset                      UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger innerCornerRadius                  UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets viewContentInsets                UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *overlayColor                         UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat preferredAlpha                                 UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) float arrowOffset;
@property (nonatomic, assign, readonly) UIEdgeInsets outerShadowInsets;
@property (nonatomic, assign) WYPopoverArrowDirection arrowDirection;
@property (nonatomic, assign, getter = isAppearing) BOOL appearing;
@property (nonatomic, assign) id <WYPopoverBackgroundViewDelegate> delegate;
@property (nonatomic, assign) BOOL wantsDefaultContentAppearance;
- (void)setViewController:(UIViewController *)viewController;
- (void)tapOut;

@end
