/*
 Version 0.3.6
 
 WYPopoverController is available under the MIT license.
 
 Copyright © 2013 Nicolas CHENG
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "WYPopoverController.h"
#import "WYPopoverBackgroundView.h"
#import "WYPopoverTheme.h"
#import "WYKeyboardListener.h"
#import "UINavigationController+WYPopover.h"
#import "WYPopoverOverlayView.h"
#import "WYPopoverArea.h"
#import "UIImage+WYPopover.h"

@interface WYPopoverController () <WYPopoverOverlayViewDelegate, WYPopoverBackgroundViewDelegate> {
    UIViewController *_viewController;
    CGRect _rect;
    UIView *_inView;
    WYPopoverOverlayView *_overlayView;
    WYPopoverBackgroundView *_backgroundView;
    WYPopoverArrowDirection _permittedArrowDirections;
    BOOL _animated;
    BOOL _isListeningNotifications;
    BOOL _isObserverAdded;
    BOOL _isInterfaceOrientationChanging;
    BOOL _ignoreOrientation;
    __weak UIBarButtonItem *_barButtonItem;
    
    WYPopoverAnimationOptions options;
    
    BOOL themeUpdatesEnabled;
    BOOL themeIsUpdating;
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aAptions
                    completion:(void (^)(void))aCompletion
                  callDelegate:(BOOL)aCallDelegate;

- (WYPopoverArrowDirection)arrowDirectionForRect:(CGRect)aRect
                                          inView:(UIView *)aView
                                     contentSize:(CGSize)aContentSize
                                     arrowHeight:(float)aArrowHeight
                        permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections;

- (CGSize)sizeForRect:(CGRect)aRect
               inView:(UIView *)aView
          arrowHeight:(float)aArrowHeight
       arrowDirection:(WYPopoverArrowDirection)aArrowDirection;

- (void)registerTheme;
- (void)unregisterTheme;
- (void)updateThemeUI;

- (CGSize)topViewControllerContentSize;

@end

@implementation WYPopoverController

static WYPopoverTheme *defaultTheme_ = nil;

@synthesize popoverContentSize = popoverContentSize_;

+ (void)setDefaultTheme:(WYPopoverTheme *)aTheme {
    defaultTheme_ = aTheme;
    
    @autoreleasepool {
        WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
        appearance.usesRoundedArrow = aTheme.usesRoundedArrow;
        appearance.dimsBackgroundViewsTintColor = aTheme.dimsBackgroundViewsTintColor;
        appearance.tintColor = aTheme.tintColor;
        appearance.outerStrokeColor = aTheme.outerStrokeColor;
        appearance.innerStrokeColor = aTheme.innerStrokeColor;
        appearance.fillTopColor = aTheme.fillTopColor;
        appearance.fillBottomColor = aTheme.fillBottomColor;
        appearance.glossShadowColor = aTheme.glossShadowColor;
        appearance.glossShadowOffset = aTheme.glossShadowOffset;
        appearance.glossShadowBlurRadius = aTheme.glossShadowBlurRadius;
        appearance.borderWidth = aTheme.borderWidth;
        appearance.arrowBase = aTheme.arrowBase;
        appearance.arrowHeight = aTheme.arrowHeight;
        appearance.outerShadowColor = aTheme.outerShadowColor;
        appearance.outerShadowBlurRadius = aTheme.outerShadowBlurRadius;
        appearance.outerShadowOffset = aTheme.outerShadowOffset;
        appearance.outerCornerRadius = aTheme.outerCornerRadius;
        appearance.minOuterCornerRadius = aTheme.minOuterCornerRadius;
        appearance.innerShadowColor = aTheme.innerShadowColor;
        appearance.innerShadowBlurRadius = aTheme.innerShadowBlurRadius;
        appearance.innerShadowOffset = aTheme.innerShadowOffset;
        appearance.innerCornerRadius = aTheme.innerCornerRadius;
        appearance.viewContentInsets = aTheme.viewContentInsets;
        appearance.overlayColor = aTheme.overlayColor;
        appearance.preferredAlpha = aTheme.preferredAlpha;
    }
}


+ (WYPopoverTheme *)defaultTheme {
    return defaultTheme_;
}


+ (void)load {
    [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
}


- (id)init {
    self = [super init];
    
    if (self) {
        // ignore orientation in iOS8
        _ignoreOrientation = (compileUsingIOS8SDK() && [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]);
        _popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        _animationDuration = WY_POPOVER_DEFAULT_ANIMATION_DURATION;
        
        themeUpdatesEnabled = NO;
        
        [self setTheme:[WYPopoverController defaultTheme]];
        
        themeIsUpdating = YES;
        
        WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
        _theme.usesRoundedArrow = appearance.usesRoundedArrow;
        _theme.dimsBackgroundViewsTintColor = appearance.dimsBackgroundViewsTintColor;
        _theme.tintColor = appearance.tintColor;
        _theme.outerStrokeColor = appearance.outerStrokeColor;
        _theme.innerStrokeColor = appearance.innerStrokeColor;
        _theme.fillTopColor = appearance.fillTopColor;
        _theme.fillBottomColor = appearance.fillBottomColor;
        _theme.glossShadowColor = appearance.glossShadowColor;
        _theme.glossShadowOffset = appearance.glossShadowOffset;
        _theme.glossShadowBlurRadius = appearance.glossShadowBlurRadius;
        _theme.borderWidth = appearance.borderWidth;
        _theme.arrowBase = appearance.arrowBase;
        _theme.arrowHeight = appearance.arrowHeight;
        _theme.outerShadowColor = appearance.outerShadowColor;
        _theme.outerShadowBlurRadius = appearance.outerShadowBlurRadius;
        _theme.outerShadowOffset = appearance.outerShadowOffset;
        _theme.outerCornerRadius = appearance.outerCornerRadius;
        _theme.minOuterCornerRadius = appearance.minOuterCornerRadius;
        _theme.innerShadowColor = appearance.innerShadowColor;
        _theme.innerShadowBlurRadius = appearance.innerShadowBlurRadius;
        _theme.innerShadowOffset = appearance.innerShadowOffset;
        _theme.innerCornerRadius = appearance.innerCornerRadius;
        _theme.viewContentInsets = appearance.viewContentInsets;
        _theme.overlayColor = appearance.overlayColor;
        _theme.preferredAlpha = appearance.preferredAlpha;
        
        themeIsUpdating = NO;
        themeUpdatesEnabled = YES;
        
        popoverContentSize_ = CGSizeZero;
    }
    
    return self;
}


- (id)initWithContentViewController:(UIViewController *)aViewController {
    self = [self init];
    
    if (self) {
        _viewController = aViewController;
    }
    
    return self;
}


- (void)setTheme:(WYPopoverTheme *)value {
    [self unregisterTheme];
    _theme = value;
    [self registerTheme];
    [self updateThemeUI];
    
    themeIsUpdating = NO;
}


- (void)registerTheme {
    if (_theme == nil) return;
    
    NSArray *keypaths = [_theme observableKeypaths];
    for (NSString *keypath in keypaths) {
        [_theme addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:NULL];
    }
}


- (void)unregisterTheme {
    if (_theme == nil) return;
    
    @try {
        NSArray *keypaths = [_theme observableKeypaths];
        for (NSString *keypath in keypaths) {
            [_theme removeObserver:self forKeyPath:keypath];
        }
    } @catch (NSException *__unused exception) {
    }
}


- (void)updateThemeUI {
    if (_theme == nil || themeUpdatesEnabled == NO || themeIsUpdating == YES) return;
    
    if (_backgroundView != nil) {
        _backgroundView.usesRoundedArrow = _theme.usesRoundedArrow;
        _backgroundView.dimsBackgroundViewsTintColor = _theme.dimsBackgroundViewsTintColor;
        _backgroundView.tintColor = _theme.tintColor;
        _backgroundView.outerStrokeColor = _theme.outerStrokeColor;
        _backgroundView.innerStrokeColor = _theme.innerStrokeColor;
        _backgroundView.fillTopColor = _theme.fillTopColor;
        _backgroundView.fillBottomColor = _theme.fillBottomColor;
        _backgroundView.glossShadowColor = _theme.glossShadowColor;
        _backgroundView.glossShadowOffset = _theme.glossShadowOffset;
        _backgroundView.glossShadowBlurRadius = _theme.glossShadowBlurRadius;
        _backgroundView.borderWidth = _theme.borderWidth;
        _backgroundView.arrowBase = _theme.arrowBase;
        _backgroundView.arrowHeight = _theme.arrowHeight;
        _backgroundView.outerShadowColor = _theme.outerShadowColor;
        _backgroundView.outerShadowBlurRadius = _theme.outerShadowBlurRadius;
        _backgroundView.outerShadowOffset = _theme.outerShadowOffset;
        _backgroundView.outerCornerRadius = _theme.outerCornerRadius;
        _backgroundView.minOuterCornerRadius = _theme.minOuterCornerRadius;
        _backgroundView.innerShadowColor = _theme.innerShadowColor;
        _backgroundView.innerShadowBlurRadius = _theme.innerShadowBlurRadius;
        _backgroundView.innerShadowOffset = _theme.innerShadowOffset;
        _backgroundView.innerCornerRadius = _theme.innerCornerRadius;
        _backgroundView.viewContentInsets = _theme.viewContentInsets;
        _backgroundView.preferredAlpha = _theme.preferredAlpha;
        [_backgroundView setNeedsDisplay];
    }
    
    if (_overlayView != nil) {
        _overlayView.backgroundColor = _theme.overlayColor;
    }
    
    [self positionPopover:NO];
    
    [self setPopoverNavigationBarBackgroundImage];
}


- (void)beginThemeUpdates {
    themeIsUpdating = YES;
}


- (void)endThemeUpdates {
    themeIsUpdating = NO;
    [self updateThemeUI];
}


- (BOOL)isPopoverVisible {
    BOOL result = (_overlayView != nil);
    
    return result;
}


- (UIViewController *)contentViewController {
    return _viewController;
}


- (CGSize)topViewControllerContentSize {
    CGSize result = CGSizeZero;
    
    UIViewController *topViewController = _viewController;
    
    if ([_viewController isKindOfClass:[UINavigationController class]] == YES) {
        UINavigationController *navigationController = (UINavigationController *)_viewController;
        topViewController = [navigationController topViewController];
    }
    
    if ([topViewController respondsToSelector:@selector(preferredContentSize)]) {
        result = topViewController.preferredContentSize;
    }
    
    if (CGSizeEqualToSize(result, CGSizeZero)) {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
        result = topViewController.contentSizeForViewInPopover;
#pragma clang diagnostic pop
    }
    
    if (CGSizeEqualToSize(result, CGSizeZero)) {
        CGSize windowSize = [[UIApplication sharedApplication] keyWindow].bounds.size;
        
        UIDeviceOrientation orientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
        
        result = CGSizeMake(320, UIDeviceOrientationIsLandscape(orientation) ? windowSize.width : windowSize.height);
    }
    
    return result;
}


- (CGSize)popoverContentSize {
    CGSize result = popoverContentSize_;
    if (CGSizeEqualToSize(result, CGSizeZero)) {
        result = [self topViewControllerContentSize];
    }
    
    return result;
}


- (void)setPopoverContentSize:(CGSize)size {
    popoverContentSize_ = size;
    [self positionPopover:YES];
}


- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated {
    popoverContentSize_ = size;
    [self positionPopover:animated];
}


- (void)performWithoutAnimation:(void (^)(void))aBlock {
    if (aBlock) {
        self.implicitAnimationsDisabled = YES;
        aBlock();
        self.implicitAnimationsDisabled = NO;
    }
}


- (void)presentPopoverFromRect:(CGRect)aRect
                        inView:(UIView *)aView
      permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                      animated:(BOOL)aAnimated {
    [self presentPopoverFromRect:aRect
                          inView:aView
        permittedArrowDirections:aArrowDirections
                        animated:aAnimated
                      completion:nil];
}


- (void)presentPopoverFromRect:(CGRect)aRect
                        inView:(UIView *)aView
      permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                      animated:(BOOL)aAnimated
                    completion:(void (^)(void))completion {
    [self presentPopoverFromRect:aRect
                          inView:aView
        permittedArrowDirections:aArrowDirections
                        animated:aAnimated
                         options:WYPopoverAnimationOptionFade
                      completion:completion];
}


- (void)presentPopoverFromRect:(CGRect)aRect
                        inView:(UIView *)aView
      permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                      animated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aOptions {
    [self presentPopoverFromRect:aRect
                          inView:aView
        permittedArrowDirections:aArrowDirections
                        animated:aAnimated
                         options:aOptions
                      completion:nil];
}


- (void)presentPopoverFromRect:(CGRect)aRect
                        inView:(UIView *)aView
      permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                      animated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aOptions
                    completion:(void (^)(void))completion {
    NSAssert((aArrowDirections != WYPopoverArrowDirectionUnknown), @"WYPopoverArrowDirection must not be UNKNOWN");
    
    _rect = aRect;
    _inView = aView;
    _permittedArrowDirections = aArrowDirections;
    _animated = aAnimated;
    options = aOptions;
    
    if (!_inView) {
        _inView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        if (CGRectIsEmpty(_rect)) {
            _rect = CGRectMake((int)_inView.bounds.size.width / 2 - 5, (int)_inView.bounds.size.height / 2 - 5, 10, 10);
        }
    }
    
    CGSize contentViewSize = self.popoverContentSize;
    
    if (_overlayView == nil) {
        _overlayView = [[WYPopoverOverlayView alloc] initWithFrame:_inView.window.bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.autoresizesSubviews = NO;
        _overlayView.delegate = self;
        _overlayView.passthroughViews = _passthroughViews;
        
        _backgroundView = [[WYPopoverBackgroundView alloc] initWithContentSize:contentViewSize];
        _backgroundView.appearing = YES;
        
        _backgroundView.delegate = self;
        _backgroundView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_backgroundView action:@selector(tapOut)];
        tap.cancelsTouchesInView = NO;
        [_overlayView addGestureRecognizer:tap];
        
        if (self.dismissOnTap) {
            tap = [[UITapGestureRecognizer alloc] initWithTarget:_backgroundView action:@selector(tapOut)];
            tap.cancelsTouchesInView = NO;
            [_backgroundView addGestureRecognizer:tap];
        }
        
        [_inView.window addSubview:_backgroundView];
        [_inView.window insertSubview:_overlayView belowSubview:_backgroundView];
    }
    
    [self updateThemeUI];
    
    __weak __typeof__(self) weakSelf = self;
    
    void (^completionBlock)(BOOL) = ^(BOOL animated) {
        __typeof__(self) strongSelf = weakSelf;
        
        if (strongSelf) {
            if (_isObserverAdded == NO) {
                _isObserverAdded = YES;
                
                if ([strongSelf->_viewController respondsToSelector:@selector(preferredContentSize)]) {
                    [strongSelf->_viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(preferredContentSize)) options:0 context:nil];
                } else {
                    [strongSelf->_viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeForViewInPopover)) options:0 context:nil];
                }
            }
            strongSelf->_backgroundView.appearing = NO;
        }
        
        if (completion) {
            completion();
        } else if (strongSelf && strongSelf->_delegate && [strongSelf->_delegate respondsToSelector:@selector(popoverControllerDidPresentPopover:)]) {
            [strongSelf->_delegate popoverControllerDidPresentPopover:strongSelf];
        }
    };
    
    void (^adjustTintDimmed)() = ^() {
        if (_backgroundView.dimsBackgroundViewsTintColor && [_inView.window respondsToSelector:@selector(setTintAdjustmentMode:)]) {
            for (UIView *subview in _inView.window.subviews) {
                if (subview != _backgroundView) {
                    [subview setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                }
            }
        }
    };
    
    _backgroundView.hidden = NO;
    
    if (_animated) {
        if ((options & WYPopoverAnimationOptionFade) == WYPopoverAnimationOptionFade) {
            _overlayView.alpha = 0;
            _backgroundView.alpha = 0;
        }
        
        CGAffineTransform endTransform = _backgroundView.transform;
        
        if ((options & WYPopoverAnimationOptionScale) == WYPopoverAnimationOptionScale) {
            CGAffineTransform startTransform = [self transformForArrowDirection:_backgroundView.arrowDirection];
            _backgroundView.transform = startTransform;
        }
        
        [UIView animateWithDuration:_animationDuration animations:^{
            __typeof__(self) strongSelf = weakSelf;
            
            if (strongSelf) {
                strongSelf->_overlayView.alpha = 1;
                strongSelf->_backgroundView.alpha = strongSelf->_backgroundView.preferredAlpha;
                strongSelf->_backgroundView.transform = endTransform;
            }
            adjustTintDimmed();
        } completion:^(BOOL finished) {
            completionBlock(YES);
        }];
    } else {
        adjustTintDimmed();
        completionBlock(NO);
    }
    
    if (_isListeningNotifications == NO) {
        _isListeningNotifications = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeStatusBarOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeDeviceOrientation:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
}


- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)aItem
               permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                               animated:(BOOL)aAnimated {
    [self presentPopoverFromBarButtonItem:aItem
                 permittedArrowDirections:aArrowDirections
                                 animated:aAnimated
                               completion:nil];
}


- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)aItem
               permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                               animated:(BOOL)aAnimated
                             completion:(void (^)(void))completion {
    [self presentPopoverFromBarButtonItem:aItem
                 permittedArrowDirections:aArrowDirections
                                 animated:aAnimated
                                  options:WYPopoverAnimationOptionFade
                               completion:completion];
}


- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)aItem
               permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                               animated:(BOOL)aAnimated
                                options:(WYPopoverAnimationOptions)aOptions {
    [self presentPopoverFromBarButtonItem:aItem
                 permittedArrowDirections:aArrowDirections
                                 animated:aAnimated
                                  options:aOptions
                               completion:nil];
}


- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)aItem
               permittedArrowDirections:(WYPopoverArrowDirection)aArrowDirections
                               animated:(BOOL)aAnimated
                                options:(WYPopoverAnimationOptions)aOptions
                             completion:(void (^)(void))completion {
    _barButtonItem = aItem;
    UIView *itemView = [_barButtonItem valueForKey:@"view"];
    aArrowDirections = WYPopoverArrowDirectionDown | WYPopoverArrowDirectionUp;
    [self presentPopoverFromRect:itemView.bounds
                          inView:itemView
        permittedArrowDirections:aArrowDirections
                        animated:aAnimated
                         options:aOptions
                      completion:completion];
}


- (void)presentPopoverAsDialogAnimated:(BOOL)aAnimated {
    [self presentPopoverAsDialogAnimated:aAnimated
                              completion:nil];
}


- (void)presentPopoverAsDialogAnimated:(BOOL)aAnimated
                            completion:(void (^)(void))completion {
    [self presentPopoverAsDialogAnimated:aAnimated
                                 options:WYPopoverAnimationOptionFade
                              completion:completion];
}


- (void)presentPopoverAsDialogAnimated:(BOOL)aAnimated
                               options:(WYPopoverAnimationOptions)aOptions {
    [self presentPopoverAsDialogAnimated:aAnimated
                                 options:aOptions
                              completion:nil];
}


- (void)presentPopoverAsDialogAnimated:(BOOL)aAnimated
                               options:(WYPopoverAnimationOptions)aOptions
                            completion:(void (^)(void))completion {
    [self presentPopoverFromRect:CGRectZero
                          inView:nil
        permittedArrowDirections:WYPopoverArrowDirectionNone
                        animated:aAnimated
                         options:aOptions
                      completion:completion];
}


- (CGAffineTransform)transformForArrowDirection:(WYPopoverArrowDirection)arrowDirection {
    CGAffineTransform transform = _backgroundView.transform;
    
    UIDeviceOrientation orientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    CGSize containerViewSize = _backgroundView.frame.size;
    
    if (_backgroundView.arrowHeight > 0) {
        if (UIDeviceOrientationIsLandscape(orientation)) {
            containerViewSize.width = _backgroundView.frame.size.height;
            containerViewSize.height = _backgroundView.frame.size.width;
        }
        
        //WY_LOG(@"containerView.arrowOffset = %f", containerView.arrowOffset);
        //WY_LOG(@"containerViewSize = %@", NSStringFromCGSize(containerViewSize));
        //WY_LOG(@"orientation = %@", WYStringFromOrientation(orientation));
        
        if (arrowDirection == WYPopoverArrowDirectionDown) {
            transform = CGAffineTransformTranslate(transform, _backgroundView.arrowOffset, containerViewSize.height / 2);
        }
        
        if (arrowDirection == WYPopoverArrowDirectionUp) {
            transform = CGAffineTransformTranslate(transform, _backgroundView.arrowOffset, -containerViewSize.height / 2);
        }
        
        if (arrowDirection == WYPopoverArrowDirectionRight) {
            transform = CGAffineTransformTranslate(transform, containerViewSize.width / 2, _backgroundView.arrowOffset);
        }
        
        if (arrowDirection == WYPopoverArrowDirectionLeft) {
            transform = CGAffineTransformTranslate(transform, -containerViewSize.width / 2, _backgroundView.arrowOffset);
        }
    }
    
    transform = CGAffineTransformScale(transform, 0.01, 0.01);
    
    return transform;
}


- (void)setPopoverNavigationBarBackgroundImage {
    if ([_viewController isKindOfClass:[UINavigationController class]] == YES) {
        UINavigationController *navigationController = (UINavigationController *)_viewController;
        navigationController.wy_embedInPopover = YES;
        
        if ([navigationController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            UIViewController *topViewController = [navigationController topViewController];
            [topViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        if (_wantsDefaultContentAppearance == NO) {
            [navigationController.navigationBar setBackgroundImage:[UIImage wy_imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
        }
    }
    
    _viewController.view.clipsToBounds = YES;
    
    if (_backgroundView.borderWidth == 0) {
        _viewController.view.layer.cornerRadius = _backgroundView.outerCornerRadius;
    }
}


- (void)positionPopover:(BOOL)aAnimated {
    CGRect savedContainerFrame = _backgroundView.frame;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize contentViewSize = self.popoverContentSize;
    CGSize minContainerSize = WY_POPOVER_MIN_SIZE;
    
    CGRect viewFrame;
    CGRect containerFrame = CGRectZero;
    float minX, maxX, minY, maxY, offset = 0;
    CGSize containerViewSize = CGSizeZero;
    
    float overlayWidth;
    float overlayHeight;
    
    float keyboardHeight;
    
    if (_ignoreOrientation) {
        overlayWidth = _overlayView.window.frame.size.width;
        overlayHeight = _overlayView.window.frame.size.height;
        
        CGRect convertedFrame = [_overlayView.window convertRect:WYKeyboardListener.rect toView:_overlayView];
        keyboardHeight = convertedFrame.size.height;
    } else {
        overlayWidth = UIInterfaceOrientationIsPortrait(orientation) ? _overlayView.bounds.size.width : _overlayView.bounds.size.height;
        overlayHeight = UIInterfaceOrientationIsPortrait(orientation) ? _overlayView.bounds.size.height : _overlayView.bounds.size.width;
        
        keyboardHeight = UIInterfaceOrientationIsPortrait(orientation) ? WYKeyboardListener.rect.size.height : WYKeyboardListener.rect.size.width;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(popoverControllerShouldIgnoreKeyboardBounds:)]) {
        BOOL shouldIgnore = [_delegate popoverControllerShouldIgnoreKeyboardBounds:self];
        
        if (shouldIgnore) {
            keyboardHeight = 0;
        }
    }
    
    WYPopoverArrowDirection arrowDirection = _permittedArrowDirections;
    
    _overlayView.bounds = _inView.window.bounds;
    _backgroundView.transform = CGAffineTransformIdentity;
    
    viewFrame = [_inView convertRect:_rect toView:nil];
    
    viewFrame = WYRectInWindowBounds(viewFrame, orientation);
    
    minX = _popoverLayoutMargins.left;
    maxX = overlayWidth - _popoverLayoutMargins.right;
    minY = WYStatusBarHeight() + _popoverLayoutMargins.top;
    maxY = overlayHeight - _popoverLayoutMargins.bottom - keyboardHeight;
    
    // Which direction ?
    //
    arrowDirection = [self arrowDirectionForRect:_rect
                                          inView:_inView
                                     contentSize:contentViewSize
                                     arrowHeight:_backgroundView.arrowHeight
                        permittedArrowDirections:arrowDirection];
    
    // Position of the popover
    //
    
    minX -= _backgroundView.outerShadowInsets.left;
    maxX += _backgroundView.outerShadowInsets.right;
    minY -= _backgroundView.outerShadowInsets.top;
    maxY += _backgroundView.outerShadowInsets.bottom;
    
    if (arrowDirection == WYPopoverArrowDirectionDown) {
        _backgroundView.arrowDirection = WYPopoverArrowDirectionDown;
        containerViewSize = [_backgroundView sizeThatFits:contentViewSize];
        
        containerFrame = CGRectZero;
        containerFrame.size = containerViewSize;
        containerFrame.size.width = MIN(maxX - minX, containerFrame.size.width);
        containerFrame.size.height = MIN(maxY - minY, containerFrame.size.height);
        
        _backgroundView.frame = CGRectIntegral(containerFrame);
        
        _backgroundView.center = CGPointMake(viewFrame.origin.x + viewFrame.size.width / 2, viewFrame.origin.y + viewFrame.size.height / 2);
        
        containerFrame = _backgroundView.frame;
        
        offset = 0;
        
        if (containerFrame.origin.x < minX) {
            offset = minX - containerFrame.origin.x;
            containerFrame.origin.x = minX;
            offset = -offset;
        } else if (containerFrame.origin.x + containerFrame.size.width > maxX) {
            offset = (_backgroundView.frame.origin.x + _backgroundView.frame.size.width) - maxX;
            containerFrame.origin.x -= offset;
        }
        
        _backgroundView.arrowOffset = offset;
        offset = _backgroundView.frame.size.height / 2 + viewFrame.size.height / 2 - _backgroundView.outerShadowInsets.bottom;
        
        containerFrame.origin.y -= offset;
        
        if (containerFrame.origin.y < minY) {
            offset = minY - containerFrame.origin.y;
            containerFrame.size.height -= offset;
            
            if (containerFrame.size.height < minContainerSize.height) {
                // popover is overflowing
                offset -= (minContainerSize.height - containerFrame.size.height);
                containerFrame.size.height = minContainerSize.height;
            }
            
            containerFrame.origin.y += offset;
        }
    }
    
    if (arrowDirection == WYPopoverArrowDirectionUp) {
        _backgroundView.arrowDirection = WYPopoverArrowDirectionUp;
        containerViewSize = [_backgroundView sizeThatFits:contentViewSize];
        
        containerFrame = CGRectZero;
        containerFrame.size = containerViewSize;
        containerFrame.size.width = MIN(maxX - minX, containerFrame.size.width);
        containerFrame.size.height = MIN(maxY - minY, containerFrame.size.height);
        
        _backgroundView.frame = containerFrame;
        
        _backgroundView.center = CGPointMake(viewFrame.origin.x + viewFrame.size.width / 2, viewFrame.origin.y + viewFrame.size.height / 2);
        
        containerFrame = _backgroundView.frame;
        
        offset = 0;
        
        if (containerFrame.origin.x < minX) {
            offset = minX - containerFrame.origin.x;
            containerFrame.origin.x = minX;
            offset = -offset;
        } else if (containerFrame.origin.x + containerFrame.size.width > maxX) {
            offset = (_backgroundView.frame.origin.x + _backgroundView.frame.size.width) - maxX;
            containerFrame.origin.x -= offset;
        }
        
        _backgroundView.arrowOffset = offset;
        offset = _backgroundView.frame.size.height / 2 + viewFrame.size.height / 2 - _backgroundView.outerShadowInsets.top;
        
        containerFrame.origin.y += offset;
        
        if (containerFrame.origin.y + containerFrame.size.height > maxY) {
            offset = (containerFrame.origin.y + containerFrame.size.height) - maxY;
            containerFrame.size.height -= offset;
            
            if (containerFrame.size.height < minContainerSize.height) {
                // popover is overflowing
                containerFrame.size.height = minContainerSize.height;
            }
        }
    }
    
    if (arrowDirection == WYPopoverArrowDirectionRight) {
        _backgroundView.arrowDirection = WYPopoverArrowDirectionRight;
        containerViewSize = [_backgroundView sizeThatFits:contentViewSize];
        
        containerFrame = CGRectZero;
        containerFrame.size = containerViewSize;
        containerFrame.size.width = MIN(maxX - minX, containerFrame.size.width);
        containerFrame.size.height = MIN(maxY - minY, containerFrame.size.height);
        
        _backgroundView.frame = CGRectIntegral(containerFrame);
        
        _backgroundView.center = CGPointMake(viewFrame.origin.x + viewFrame.size.width / 2, viewFrame.origin.y + viewFrame.size.height / 2);
        
        containerFrame = _backgroundView.frame;
        
        offset = _backgroundView.frame.size.width / 2 + viewFrame.size.width / 2 - _backgroundView.outerShadowInsets.right;
        
        containerFrame.origin.x -= offset;
        
        if (containerFrame.origin.x < minX) {
            offset = minX - containerFrame.origin.x;
            containerFrame.size.width -= offset;
            
            if (containerFrame.size.width < minContainerSize.width) {
                // popover is overflowing
                offset -= (minContainerSize.width - containerFrame.size.width);
                containerFrame.size.width = minContainerSize.width;
            }
            
            containerFrame.origin.x += offset;
        }
        
        offset = 0;
        
        if (containerFrame.origin.y < minY) {
            offset = minY - containerFrame.origin.y;
            containerFrame.origin.y = minY;
            offset = -offset;
        } else if (containerFrame.origin.y + containerFrame.size.height > maxY) {
            offset = (_backgroundView.frame.origin.y + _backgroundView.frame.size.height) - maxY;
            containerFrame.origin.y -= offset;
        }
        
        _backgroundView.arrowOffset = offset;
    }
    
    if (arrowDirection == WYPopoverArrowDirectionLeft) {
        _backgroundView.arrowDirection = WYPopoverArrowDirectionLeft;
        containerViewSize = [_backgroundView sizeThatFits:contentViewSize];
        
        containerFrame = CGRectZero;
        containerFrame.size = containerViewSize;
        containerFrame.size.width = MIN(maxX - minX, containerFrame.size.width);
        containerFrame.size.height = MIN(maxY - minY, containerFrame.size.height);
        _backgroundView.frame = containerFrame;
        
        _backgroundView.center = CGPointMake(viewFrame.origin.x + viewFrame.size.width / 2, viewFrame.origin.y + viewFrame.size.height / 2);
        
        containerFrame = CGRectIntegral(_backgroundView.frame);
        
        offset = _backgroundView.frame.size.width / 2 + viewFrame.size.width / 2 - _backgroundView.outerShadowInsets.left;
        
        containerFrame.origin.x += offset;
        
        if (containerFrame.origin.x + containerFrame.size.width > maxX) {
            offset = (containerFrame.origin.x + containerFrame.size.width) - maxX;
            containerFrame.size.width -= offset;
            
            if (containerFrame.size.width < minContainerSize.width) {
                // popover is overflowing
                containerFrame.size.width = minContainerSize.width;
            }
        }
        
        offset = 0;
        
        if (containerFrame.origin.y < minY) {
            offset = minY - containerFrame.origin.y;
            containerFrame.origin.y = minY;
            offset = -offset;
        } else if (containerFrame.origin.y + containerFrame.size.height > maxY) {
            offset = (_backgroundView.frame.origin.y + _backgroundView.frame.size.height) - maxY;
            containerFrame.origin.y -= offset;
        }
        
        _backgroundView.arrowOffset = offset;
    }
    
    if (arrowDirection == WYPopoverArrowDirectionNone) {
        _backgroundView.arrowDirection = WYPopoverArrowDirectionNone;
        containerViewSize = [_backgroundView sizeThatFits:contentViewSize];
        
        containerFrame = CGRectZero;
        containerFrame.size = containerViewSize;
        containerFrame.size.width = MIN(maxX - minX, containerFrame.size.width);
        containerFrame.size.height = MIN(maxY - minY, containerFrame.size.height);
        _backgroundView.frame = CGRectIntegral(containerFrame);
        
        _backgroundView.center = CGPointMake(minX + (maxX - minX) / 2, minY + (maxY - minY) / 2);
        
        containerFrame = _backgroundView.frame;
        
        _backgroundView.arrowOffset = offset;
    }
    
    containerFrame = CGRectIntegral(containerFrame);
    
    _backgroundView.frame = containerFrame;
    
    _backgroundView.wantsDefaultContentAppearance = _wantsDefaultContentAppearance;
    
    [_backgroundView setViewController:_viewController];
    
    // keyboard support
    if (keyboardHeight > 0) {
        float keyboardY = UIInterfaceOrientationIsPortrait(orientation) ? WYKeyboardListener.rect.origin.y : WYKeyboardListener.rect.origin.x;
        
        float yOffset = containerFrame.origin.y + containerFrame.size.height - keyboardY;
        
        if (yOffset > 0) {
            if (containerFrame.origin.y - yOffset < minY) {
                yOffset -= minY - (containerFrame.origin.y - yOffset);
            }
            
            if ([_delegate respondsToSelector:@selector(popoverController:willTranslatePopoverWithYOffset:)]) {
                [_delegate popoverController:self willTranslatePopoverWithYOffset:&yOffset];
            }
            
            containerFrame.origin.y -= yOffset;
        }
    }
    
    CGPoint containerOrigin = containerFrame.origin;
    
    _backgroundView.transform = CGAffineTransformMakeRotation(WYInterfaceOrientationAngleOfOrientation(orientation));
    
    containerFrame = _backgroundView.frame;
    
    containerFrame.origin = WYPointRelativeToOrientation(containerOrigin, containerFrame.size, orientation);
    
    if (aAnimated == YES && !self.implicitAnimationsDisabled) {
        _backgroundView.frame = savedContainerFrame;
        __weak __typeof__(self) weakSelf = self;
        
        [UIView animateWithDuration:0.10f animations:^{
            __typeof__(self) strongSelf = weakSelf;
            strongSelf->_backgroundView.frame = containerFrame;
        }];
    } else {
        _backgroundView.frame = containerFrame;
    }
    
    [_backgroundView setNeedsDisplay];
    
    //  WY_LOG(@"popoverContainerView.frame = %@", NSStringFromCGRect(_backgroundView.frame));
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated {
    [self dismissPopoverAnimated:aAnimated
                         options:options
                      completion:nil];
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated
                    completion:(void (^)(void))completion {
    [self dismissPopoverAnimated:aAnimated
                         options:options
                      completion:completion];
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aOptions {
    [self dismissPopoverAnimated:aAnimated
                         options:aOptions
                      completion:nil];
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aOptions
                    completion:(void (^)(void))completion {
    [self dismissPopoverAnimated:aAnimated
                         options:aOptions
                      completion:completion
                    callDelegate:NO];
}


- (void)dismissPopoverAnimated:(BOOL)aAnimated
                       options:(WYPopoverAnimationOptions)aOptions
                    completion:(void (^)(void))completion
                  callDelegate:(BOOL)callDelegate {
    float duration = self.animationDuration;
    WYPopoverAnimationOptions style = aOptions;
    
    __weak __typeof__(self) weakSelf = self;
    
    void (^adjustTintAutomatic)() = ^() {
        if ([_inView.window respondsToSelector:@selector(setTintAdjustmentMode:)]) {
            for (UIView *subview in _inView.window.subviews) {
                if (subview != _backgroundView) {
                    [subview setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
                }
            }
        }
    };
    
    void (^completionBlock)() = ^() {
        __typeof__(self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf->_backgroundView removeFromSuperview];
            
            strongSelf->_backgroundView = nil;
            
            [strongSelf->_overlayView removeFromSuperview];
            strongSelf->_overlayView = nil;
            
            // inView is captured strongly in presentPopoverInRect:... method, so it needs to be released in dismiss method to avoid potential retain cycles
            strongSelf->_inView = nil;
        }
        
        if (completion) {
            completion();
        } else if (callDelegate && strongSelf && strongSelf->_delegate && [strongSelf->_delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)]) {
            [strongSelf->_delegate popoverControllerDidDismissPopover:strongSelf];
        }
        
        if (self.dismissCompletionBlock) {
            self.dismissCompletionBlock(strongSelf);
        }
    };
    
    if (_isListeningNotifications == YES) {
        _isListeningNotifications = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidChangeStatusBarOrientationNotification
                                                      object:nil];
        
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIDeviceOrientationDidChangeNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
    
    @try {
        if (_isObserverAdded == YES) {
            _isObserverAdded = NO;
            
            if ([_viewController respondsToSelector:@selector(preferredContentSize)]) {
                [_viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(preferredContentSize))];
            } else {
                [_viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeForViewInPopover))];
            }
        }
    } @catch (NSException *__unused exception) {
    }
    
    if (aAnimated && !self.implicitAnimationsDisabled) {
        [UIView animateWithDuration:duration animations:^{
            __typeof__(self) strongSelf = weakSelf;
            if (strongSelf) {
                if ((style & WYPopoverAnimationOptionFade) == WYPopoverAnimationOptionFade) {
                    strongSelf->_backgroundView.alpha = 0;
                }
                
                if ((style & WYPopoverAnimationOptionScale) == WYPopoverAnimationOptionScale) {
                    CGAffineTransform endTransform = [self transformForArrowDirection:strongSelf->_backgroundView.arrowDirection];
                    strongSelf->_backgroundView.transform = endTransform;
                }
                strongSelf->_overlayView.alpha = 0;
            }
            adjustTintAutomatic();
        } completion:^(BOOL finished) {
            completionBlock();
        }];
    } else {
        adjustTintAutomatic();
        completionBlock();
    }
}


#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _viewController) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(preferredContentSize))]
            || [keyPath isEqualToString:NSStringFromSelector(@selector(contentSizeForViewInPopover))]) {
            CGSize contentSize = [self topViewControllerContentSize];
            [self setPopoverContentSize:contentSize];
        }
    } else if (object == _theme) {
        [self updateThemeUI];
    }
}


#pragma mark WYPopoverOverlayViewDelegate

- (void)popoverOverlayViewDidTouch:(WYPopoverOverlayView *)aOverlayView {
    BOOL shouldDismiss = !_viewController.modalInPopover;
    
    if (shouldDismiss && _delegate && [_delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)]) {
        shouldDismiss = [_delegate popoverControllerShouldDismissPopover:self];
    }
    
    if (shouldDismiss) {
        [self dismissPopoverAnimated:_animated options:options completion:nil callDelegate:YES];
    }
}


#pragma mark WYPopoverBackgroundViewDelegate

- (void)popoverBackgroundViewDidTouchOutside:(WYPopoverBackgroundView *)aBackgroundView {
    [self popoverOverlayViewDidTouch:nil];
}


#pragma mark Private

- (WYPopoverArrowDirection)arrowDirectionForRect:(CGRect)aRect
                                          inView:(UIView *)aView
                                     contentSize:(CGSize)contentSize
                                     arrowHeight:(float)arrowHeight
                        permittedArrowDirections:(WYPopoverArrowDirection)arrowDirections {
    WYPopoverArrowDirection arrowDirection = WYPopoverArrowDirectionUnknown;
    
    NSMutableArray *areas = [NSMutableArray arrayWithCapacity:0];
    WYPopoverArea *area;
    
    if ((arrowDirections & WYPopoverArrowDirectionDown) == WYPopoverArrowDirectionDown) {
        area = [[WYPopoverArea alloc] init];
        area.areaSize = [self sizeForRect:aRect inView:aView arrowHeight:arrowHeight arrowDirection:WYPopoverArrowDirectionDown];
        area.arrowDirection = WYPopoverArrowDirectionDown;
        [areas addObject:area];
    }
    
    if ((arrowDirections & WYPopoverArrowDirectionUp) == WYPopoverArrowDirectionUp) {
        area = [[WYPopoverArea alloc] init];
        area.areaSize = [self sizeForRect:aRect inView:aView arrowHeight:arrowHeight arrowDirection:WYPopoverArrowDirectionUp];
        area.arrowDirection = WYPopoverArrowDirectionUp;
        [areas addObject:area];
    }
    
    if ((arrowDirections & WYPopoverArrowDirectionLeft) == WYPopoverArrowDirectionLeft) {
        area = [[WYPopoverArea alloc] init];
        area.areaSize = [self sizeForRect:aRect inView:aView arrowHeight:arrowHeight arrowDirection:WYPopoverArrowDirectionLeft];
        area.arrowDirection = WYPopoverArrowDirectionLeft;
        [areas addObject:area];
    }
    
    if ((arrowDirections & WYPopoverArrowDirectionRight) == WYPopoverArrowDirectionRight) {
        area = [[WYPopoverArea alloc] init];
        area.areaSize = [self sizeForRect:aRect inView:aView arrowHeight:arrowHeight arrowDirection:WYPopoverArrowDirectionRight];
        area.arrowDirection = WYPopoverArrowDirectionRight;
        [areas addObject:area];
    }
    
    if ((arrowDirections & WYPopoverArrowDirectionNone) == WYPopoverArrowDirectionNone) {
        area = [[WYPopoverArea alloc] init];
        area.areaSize = [self sizeForRect:aRect inView:aView arrowHeight:arrowHeight arrowDirection:WYPopoverArrowDirectionNone];
        area.arrowDirection = WYPopoverArrowDirectionNone;
        [areas addObject:area];
    }
    
    if ([areas count] > 1) {
        NSIndexSet *indexes = [areas indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
            WYPopoverArea *popoverArea = (WYPopoverArea *)obj;
            
            BOOL result = (popoverArea.areaSize.width > 0 && popoverArea.areaSize.height > 0);
            
            return result;
        }];
        
        areas = [NSMutableArray arrayWithArray:[areas objectsAtIndexes:indexes]];
    }
    
    [areas sortUsingComparator:^NSComparisonResult (id obj1, id obj2) {
        WYPopoverArea *area1 = (WYPopoverArea *)obj1;
        WYPopoverArea *area2 = (WYPopoverArea *)obj2;
        
        float val1 = area1.value;
        float val2 = area2.value;
        
        NSComparisonResult result = NSOrderedSame;
        
        if (val1 > val2) {
            result = NSOrderedAscending;
        } else if (val1 < val2) {
            result = NSOrderedDescending;
        }
        
        return result;
    }];
    
    for (NSUInteger i = 0; i < [areas count]; i++) {
        WYPopoverArea *popoverArea = (WYPopoverArea *)[areas objectAtIndex:i];
        
        if (popoverArea.areaSize.width >= contentSize.width) {
            arrowDirection = popoverArea.arrowDirection;
            break;
        }
    }
    
    if (arrowDirection == WYPopoverArrowDirectionUnknown) {
        if ([areas count] > 0) {
            arrowDirection = ((WYPopoverArea *)[areas objectAtIndex:0]).arrowDirection;
        } else {
            if ((arrowDirections & WYPopoverArrowDirectionDown) == WYPopoverArrowDirectionDown) {
                arrowDirection = WYPopoverArrowDirectionDown;
            } else if ((arrowDirections & WYPopoverArrowDirectionUp) == WYPopoverArrowDirectionUp) {
                arrowDirection = WYPopoverArrowDirectionUp;
            } else if ((arrowDirections & WYPopoverArrowDirectionLeft) == WYPopoverArrowDirectionLeft) {
                arrowDirection = WYPopoverArrowDirectionLeft;
            } else {
                arrowDirection = WYPopoverArrowDirectionRight;
            }
        }
    }
    
    return arrowDirection;
}


- (CGSize)sizeForRect:(CGRect)aRect
               inView:(UIView *)aView
          arrowHeight:(float)arrowHeight
       arrowDirection:(WYPopoverArrowDirection)arrowDirection {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect viewFrame = [aView convertRect:aRect toView:nil];
    viewFrame = WYRectInWindowBounds(viewFrame, orientation);
    
    float minX, maxX, minY, maxY = 0;
    
    float keyboardHeight = UIInterfaceOrientationIsPortrait(orientation) ? WYKeyboardListener.rect.size.height : WYKeyboardListener.rect.size.width;
    
    if (_delegate && [_delegate respondsToSelector:@selector(popoverControllerShouldIgnoreKeyboardBounds:)]) {
        BOOL shouldIgnore = [_delegate popoverControllerShouldIgnoreKeyboardBounds:self];
        
        if (shouldIgnore) {
            keyboardHeight = 0;
        }
    }
    
    float overlayWidth = UIInterfaceOrientationIsPortrait(orientation) ? _overlayView.bounds.size.width : _overlayView.bounds.size.height;
    
    float overlayHeight = UIInterfaceOrientationIsPortrait(orientation) ? _overlayView.bounds.size.height : _overlayView.bounds.size.width;
    
    minX = _popoverLayoutMargins.left;
    maxX = overlayWidth - _popoverLayoutMargins.right;
    minY = WYStatusBarHeight() + _popoverLayoutMargins.top;
    maxY = overlayHeight - _popoverLayoutMargins.bottom - keyboardHeight;
    
    CGSize result = CGSizeZero;
    
    if (arrowDirection == WYPopoverArrowDirectionLeft) {
        result.width = maxX - (viewFrame.origin.x + viewFrame.size.width);
        result.width -= arrowHeight;
        result.height = maxY - minY;
    } else if (arrowDirection == WYPopoverArrowDirectionRight) {
        result.width = viewFrame.origin.x - minX;
        result.width -= arrowHeight;
        result.height = maxY - minY;
    } else if (arrowDirection == WYPopoverArrowDirectionDown) {
        result.width = maxX - minX;
        result.height = viewFrame.origin.y - minY;
        result.height -= arrowHeight;
    } else if (arrowDirection == WYPopoverArrowDirectionUp) {
        result.width = maxX - minX;
        result.height = maxY - (viewFrame.origin.y + viewFrame.size.height);
        result.height -= arrowHeight;
    } else if (arrowDirection == WYPopoverArrowDirectionNone) {
        result.width = maxX - minX;
        result.height = maxY - minY;
    }
    
    return result;
}


#pragma mark Inline functions

static BOOL compileUsingIOS8SDK() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    return YES;
#endif
    
    return NO;
}


__unused static NSString *WYStringFromOrientation(NSInteger orientation) {
    NSString *result = @"Unknown";
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait: {
            result = @"Portrait";
            break;
        }
            
        case UIInterfaceOrientationPortraitUpsideDown: {
            result = @"Portrait UpsideDown";
            break;
        }
            
        case UIInterfaceOrientationLandscapeLeft: {
            result = @"Landscape Left";
            break;
        }
            
        case UIInterfaceOrientationLandscapeRight: {
            result = @"Landscape Right";
            break;
        }
            
        default: {
            break;
        }
    }
    
    return result;
}


static float WYStatusBarHeight() {
    if (compileUsingIOS8SDK() && [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        
        return statusBarFrame.size.height;
    } else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        float statusBarHeight = 0;
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        statusBarHeight = statusBarFrame.size.height;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            statusBarHeight = statusBarFrame.size.width;
        }
        
        return statusBarHeight;
    }
}


static float WYInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation) {
    float angle;
    // no transformation needed in iOS 8
    if (compileUsingIOS8SDK() && [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        angle = 0.0;
    } else {
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown: {
                angle = M_PI;
                break;
            }
                
            case UIInterfaceOrientationLandscapeLeft: {
                angle = -M_PI_2;
                break;
            }
                
            case UIInterfaceOrientationLandscapeRight: {
                angle = M_PI_2;
                break;
            }
                
            default: {
                angle = 0.0;
                break;
            }
        }
    }
    
    return angle;
}


static CGRect WYRectInWindowBounds(CGRect rect, UIInterfaceOrientation orientation) {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    float windowWidth = keyWindow.bounds.size.width;
    float windowHeight = keyWindow.bounds.size.height;
    
    CGRect result = rect;
    if (!(compileUsingIOS8SDK() && [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)])) {
        if (orientation == UIInterfaceOrientationLandscapeRight) {
            result.origin.x = rect.origin.y;
            result.origin.y = windowWidth - rect.origin.x - rect.size.width;
            result.size.width = rect.size.height;
            result.size.height = rect.size.width;
        }
        
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            result.origin.x = windowHeight - rect.origin.y - rect.size.height;
            result.origin.y = rect.origin.x;
            result.size.width = rect.size.height;
            result.size.height = rect.size.width;
        }
        
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            result.origin.x = windowWidth - rect.origin.x - rect.size.width;
            result.origin.y = windowHeight - rect.origin.y - rect.size.height;
        }
    }
    
    return result;
}


static CGPoint WYPointRelativeToOrientation(CGPoint origin, CGSize size, UIInterfaceOrientation orientation) {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    float windowWidth = keyWindow.bounds.size.width;
    float windowHeight = keyWindow.bounds.size.height;
    
    CGPoint result = origin;
    if (!(compileUsingIOS8SDK() && [[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)])) {
        if (orientation == UIInterfaceOrientationLandscapeRight) {
            result.x = windowWidth - origin.y - size.width;
            result.y = origin.x;
        }
        
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            result.x = origin.y;
            result.y = windowHeight - origin.x - size.height;
        }
        
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            result.x = windowWidth - origin.x - size.width;
            result.y = windowHeight - origin.y - size.height;
        }
    }
    
    return result;
}


#pragma mark Selectors

- (void)didChangeStatusBarOrientation:(NSNotification *)notification {
    _isInterfaceOrientationChanging = YES;
}


- (void)didChangeDeviceOrientation:(NSNotification *)notification {
    if (_isInterfaceOrientationChanging == NO) return;
    
    _isInterfaceOrientationChanging = NO;
    
    if ([_viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)_viewController;
        
        if (navigationController.navigationBarHidden == NO) {
            navigationController.navigationBarHidden = YES;
            navigationController.navigationBarHidden = NO;
        }
    }
    
    if (_barButtonItem) {
        _inView = [_barButtonItem valueForKey:@"view"];
        _rect = _inView.bounds;
    } else if ([_delegate respondsToSelector:@selector(popoverController:willRepositionPopoverToRect:inView:)]) {
        CGRect anotherRect;
        UIView *anotherInView;
        
        [_delegate popoverController:self willRepositionPopoverToRect:&anotherRect inView:&anotherInView];
        
        _rect = anotherRect;
        
        _inView = anotherInView;
    }
    
    [self positionPopover:NO];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //WY_LOG(@"orientation = %@", WYStringFromOrientation(orientation));
    //WY_LOG(@"WYKeyboardListener.rect = %@", NSStringFromCGRect(WYKeyboardListener.rect));
    
    BOOL shouldIgnore = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(popoverControllerShouldIgnoreKeyboardBounds:)]) {
        shouldIgnore = [_delegate popoverControllerShouldIgnoreKeyboardBounds:self];
    }
    
    if (shouldIgnore == NO) {
        [self positionPopover:YES];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    BOOL shouldIgnore = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(popoverControllerShouldIgnoreKeyboardBounds:)]) {
        shouldIgnore = [_delegate popoverControllerShouldIgnoreKeyboardBounds:self];
    }
    
    if (shouldIgnore == NO) {
        [self positionPopover:YES];
    }
}


#pragma mark Memory management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_backgroundView removeFromSuperview];
    [_backgroundView setDelegate:nil];
    
    [_overlayView removeFromSuperview];
    [_overlayView setDelegate:nil];
    @try {
        if (_isObserverAdded == YES) {
            _isObserverAdded = NO;
            
            if ([_viewController respondsToSelector:@selector(preferredContentSize)]) {
                [_viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(preferredContentSize))];
            } else {
                [_viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeForViewInPopover))];
            }
        }
    } @catch (NSException *exception) {
    } @finally {
        _viewController = nil;
    }
    
    [self unregisterTheme];
    
    _barButtonItem = nil;
    _passthroughViews = nil;
    _inView = nil;
    _overlayView = nil;
    _backgroundView = nil;
    
    _theme = nil;
}

@end
