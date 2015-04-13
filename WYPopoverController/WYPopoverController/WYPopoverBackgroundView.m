//
//  WYPopoverBackgroundView.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYPopoverBackgroundView.h"
#import "WYPopoverBackgroundInnerView.h"

@interface WYPopoverBackgroundView () {
    WYPopoverBackgroundInnerView *_innerView;
    CGSize _contentSize;
}


@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign, readonly) float navigationBarHeight;




- (CGRect)outerRect;
- (CGRect)innerRect;
- (CGRect)arrowRect;

- (CGRect)outerRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection;
- (CGRect)innerRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection;
- (CGRect)arrowRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection;

- (id)initWithContentSize:(CGSize)contentSize;

@end

@implementation WYPopoverBackgroundView

- (id)initWithContentSize:(CGSize)aContentSize {
    self = [super initWithFrame:CGRectMake(0, 0, aContentSize.width, aContentSize.height)];
    
    if (self != nil) {
        _contentSize = aContentSize;
        
        self.autoresizesSubviews = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.arrowDirection = WYPopoverArrowDirectionDown;
        self.arrowOffset = 0;
        
        self.layer.name = @"parent";
        
        self.layer.drawsAsynchronously = YES;
        
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        //self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        self.layer.delegate = self;
    }
    
    return self;
}


- (void)tapOut {
    [self.delegate popoverBackgroundViewDidTouchOutside:self];
}


- (UIEdgeInsets)outerShadowInsets {
    UIEdgeInsets result = UIEdgeInsetsMake(_outerShadowBlurRadius, _outerShadowBlurRadius, _outerShadowBlurRadius, _outerShadowBlurRadius);
    
    result.top -= self.outerShadowOffset.height;
    result.bottom += self.outerShadowOffset.height;
    result.left -= self.outerShadowOffset.width;
    result.right += self.outerShadowOffset.width;
    
    return result;
}


- (void)setArrowOffset:(float)value {
    float coef = 1;
    
    if (value != 0) {
        coef = value / ABS(value);
        
        value = ABS(value);
        
        CGRect outerRect = [self outerRect];
        
        float delta = self.arrowBase / 2. + .5;
        
        delta  += MIN(_minOuterCornerRadius, _outerCornerRadius);
        
        outerRect = CGRectInset(outerRect, delta, delta);
        
        if (_arrowDirection == WYPopoverArrowDirectionUp || _arrowDirection == WYPopoverArrowDirectionDown) {
            value += coef * self.outerShadowOffset.width;
            value = MIN(value, CGRectGetWidth(outerRect) / 2);
        }
        
        if (_arrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
            value += coef * self.outerShadowOffset.height;
            value = MIN(value, CGRectGetHeight(outerRect) / 2);
        }
    } else {
        if (_arrowDirection == WYPopoverArrowDirectionUp || _arrowDirection == WYPopoverArrowDirectionDown) {
            value += self.outerShadowOffset.width;
        }
        
        if (_arrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
            value += self.outerShadowOffset.height;
        }
    }
    _arrowOffset = value * coef;
}


- (void)setViewController:(UIViewController *)viewController {
    _contentView = viewController.view;
    
    _contentView.frame = CGRectIntegral(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    [self addSubview:_contentView];
    
    _navigationBarHeight = 0;
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        _navigationBarHeight = navigationController.navigationBarHidden ? 0 : navigationController.navigationBar.bounds.size.height;
    }
    
    _contentView.frame = CGRectIntegral([self innerRect]);
    
    if (_innerView == nil) {
        _innerView = [[WYPopoverBackgroundInnerView alloc] initWithFrame:_contentView.frame];
        _innerView.userInteractionEnabled = NO;
        
        _innerView.gradientTopColor = self.fillTopColor;
        _innerView.gradientBottomColor = self.fillBottomColor;
        _innerView.innerShadowColor = _innerShadowColor;
        _innerView.innerStrokeColor = self.innerStrokeColor;
        _innerView.innerShadowOffset = _innerShadowOffset;
        _innerView.innerCornerRadius = self.innerCornerRadius;
        _innerView.innerShadowBlurRadius = _innerShadowBlurRadius;
        _innerView.borderWidth = self.borderWidth;
    }
    
    _innerView.navigationBarHeight = _navigationBarHeight;
    _innerView.gradientHeight = self.frame.size.height - 2 * _outerShadowBlurRadius;
    _innerView.gradientTopPosition = _contentView.frame.origin.y - self.outerShadowInsets.top;
    _innerView.wantsDefaultContentAppearance = _wantsDefaultContentAppearance;
    
    [self insertSubview:_innerView aboveSubview:_contentView];
    
    _innerView.frame = CGRectIntegral(_contentView.frame);
    
    [self.layer setNeedsDisplay];
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGSize result = size;
    
    result.width += 2 * (_borderWidth + _outerShadowBlurRadius);
    result.height += _borderWidth + 2 * _outerShadowBlurRadius;
    
    if (_navigationBarHeight == 0) {
        result.height += _borderWidth;
    }
    
    if (_arrowDirection == WYPopoverArrowDirectionUp || _arrowDirection == WYPopoverArrowDirectionDown) {
        result.height += _arrowHeight;
    }
    
    if (_arrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
        result.width += _arrowHeight;
    }
    
    return result;
}


- (void)sizeToFit {
    CGSize size = [self sizeThatFits:_contentSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}


#pragma mark Drawing

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    
    [self.layer setNeedsDisplay];
    
    self.alpha = self.preferredAlpha;
    
    if (_innerView) {
        _innerView.gradientTopColor = self.fillTopColor;
        _innerView.gradientBottomColor = self.fillBottomColor;
        _innerView.innerShadowColor = _innerShadowColor;
        _innerView.innerStrokeColor = self.innerStrokeColor;
        _innerView.innerShadowOffset = _innerShadowOffset;
        _innerView.innerCornerRadius = self.innerCornerRadius;
        _innerView.innerShadowBlurRadius = _innerShadowBlurRadius;
        _innerView.borderWidth = self.borderWidth;
        
        _innerView.navigationBarHeight = _navigationBarHeight;
        _innerView.gradientHeight = self.frame.size.height - 2 * _outerShadowBlurRadius;
        _innerView.gradientTopPosition = _contentView.frame.origin.y - self.outerShadowInsets.top;
        _innerView.wantsDefaultContentAppearance = _wantsDefaultContentAppearance;
        
        [_innerView setNeedsDisplay];
    }
}


#pragma mark CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    if ([layer.name isEqualToString:@"parent"]) {
        UIGraphicsPushContext(context);
        //CGContextSetShouldAntialias(context, YES);
        //CGContextSetAllowsAntialiasing(context, YES);
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        //// Gradient Declarations
        NSArray *fillGradientColors = [NSArray arrayWithObjects:
                                       (id)self.fillTopColor.CGColor,
                                       (id)self.fillBottomColor.CGColor, nil];
        
        CGFloat fillGradientLocations[2] = {0, 1};
        CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fillGradientColors, fillGradientLocations);
        
        // Frames
        CGRect rect = self.bounds;
        
        CGRect outerRect = [self outerRect:rect arrowDirection:self.arrowDirection];
        CGRect insetRect = CGRectInset(outerRect, 0.5, 0.5);
        if (!CGRectIsEmpty(insetRect) && !CGRectIsInfinite(insetRect)) {
            outerRect = insetRect;
        }
        
        // Inner Path
        CGMutablePathRef outerPathRef = CGPathCreateMutable();
        
        CGPoint arrowTipPoint = CGPointZero;
        CGPoint arrowBasePointA = CGPointZero;
        CGPoint arrowBasePointB = CGPointZero;
        
        float reducedOuterCornerRadius = 0;
        
        if (_arrowDirection == WYPopoverArrowDirectionUp || _arrowDirection == WYPopoverArrowDirectionDown) {
            if (_arrowOffset >= 0) {
                reducedOuterCornerRadius = CGRectGetMaxX(outerRect) - (CGRectGetMidX(outerRect) + _arrowOffset + _arrowBase / 2);
            } else {
                reducedOuterCornerRadius = (CGRectGetMidX(outerRect) + _arrowOffset - _arrowBase / 2) - CGRectGetMinX(outerRect);
            }
        } else if (_arrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
            if (_arrowOffset >= 0) {
                reducedOuterCornerRadius = CGRectGetMaxY(outerRect) - (CGRectGetMidY(outerRect) + _arrowOffset + _arrowBase / 2);
            } else {
                reducedOuterCornerRadius = (CGRectGetMidY(outerRect) + _arrowOffset - _arrowBase / 2) - CGRectGetMinY(outerRect);
            }
        }
        
        reducedOuterCornerRadius = MIN(reducedOuterCornerRadius, _outerCornerRadius);
        
        CGFloat roundedArrowControlLength = _arrowBase / 5.0f;
        if (_arrowDirection == WYPopoverArrowDirectionUp) {
            arrowTipPoint = CGPointMake(CGRectGetMidX(outerRect) + _arrowOffset,
                                        CGRectGetMinY(outerRect) - _arrowHeight);
            arrowBasePointA = CGPointMake(arrowTipPoint.x - _arrowBase / 2,
                                          arrowTipPoint.y + _arrowHeight);
            arrowBasePointB = CGPointMake(arrowTipPoint.x + _arrowBase / 2,
                                          arrowTipPoint.y + _arrowHeight);
            
            CGPathMoveToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
            
            if (self.usesRoundedArrow) {
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowBasePointA.x + roundedArrowControlLength, arrowBasePointA.y,
                                      arrowTipPoint.x - (roundedArrowControlLength * 0.75f), arrowTipPoint.y,
                                      arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowTipPoint.x + (roundedArrowControlLength * 0.75f), arrowTipPoint.y,
                                      arrowBasePointB.x - roundedArrowControlLength, arrowBasePointB.y,
                                      arrowBasePointB.x, arrowBasePointB.y);
            } else {
                CGPathAddLineToPoint(outerPathRef, NULL, arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointB.x, arrowBasePointB.y);
            }
            
            CGPathAddArcToPoint(outerPathRef, NULL, CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                (_arrowOffset >= 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL, CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL, CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL, CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                (_arrowOffset < 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            
            CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
        } else if (_arrowDirection == WYPopoverArrowDirectionDown) {
            arrowTipPoint = CGPointMake(CGRectGetMidX(outerRect) + _arrowOffset,
                                        CGRectGetMaxY(outerRect) + _arrowHeight);
            arrowBasePointA = CGPointMake(arrowTipPoint.x + _arrowBase / 2,
                                          arrowTipPoint.y - _arrowHeight);
            arrowBasePointB = CGPointMake(arrowTipPoint.x - _arrowBase / 2,
                                          arrowTipPoint.y - _arrowHeight);
            
            CGPathMoveToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
            
            if (self.usesRoundedArrow) {
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowBasePointA.x - roundedArrowControlLength, arrowBasePointA.y,
                                      arrowTipPoint.x + (roundedArrowControlLength * 0.75f), arrowTipPoint.y,
                                      arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowTipPoint.x - (roundedArrowControlLength * 0.75f), arrowTipPoint.y,
                                      arrowBasePointB.x + roundedArrowControlLength, arrowBasePointA.y,
                                      arrowBasePointB.x, arrowBasePointB.y);
            } else {
                CGPathAddLineToPoint(outerPathRef, NULL, arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointB.x, arrowBasePointB.y);
            }
            
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                (_arrowOffset < 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                (_arrowOffset >= 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            
            CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
        } else if (_arrowDirection == WYPopoverArrowDirectionLeft) {
            arrowTipPoint = CGPointMake(CGRectGetMinX(outerRect) - _arrowHeight,
                                        CGRectGetMidY(outerRect) + _arrowOffset);
            arrowBasePointA = CGPointMake(arrowTipPoint.x + _arrowHeight,
                                          arrowTipPoint.y + _arrowBase / 2);
            arrowBasePointB = CGPointMake(arrowTipPoint.x + _arrowHeight,
                                          arrowTipPoint.y - _arrowBase / 2);
            
            CGPathMoveToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
            
            if (self.usesRoundedArrow) {
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowBasePointA.x, arrowBasePointA.y - roundedArrowControlLength,
                                      arrowTipPoint.x, arrowTipPoint.y + (roundedArrowControlLength * 0.75f),
                                      arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowTipPoint.x, arrowTipPoint.y - (roundedArrowControlLength * 0.75f),
                                      arrowBasePointB.x, arrowBasePointB.y + roundedArrowControlLength,
                                      arrowBasePointB.x, arrowBasePointB.y);
            } else {
                CGPathAddLineToPoint(outerPathRef, NULL, arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointB.x, arrowBasePointB.y);
            }
            
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                (_arrowOffset < 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                (_arrowOffset >= 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            
            CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
        } else if (_arrowDirection == WYPopoverArrowDirectionRight) {
            arrowTipPoint = CGPointMake(CGRectGetMaxX(outerRect) + _arrowHeight,
                                        CGRectGetMidY(outerRect) + _arrowOffset);
            arrowBasePointA = CGPointMake(arrowTipPoint.x - _arrowHeight,
                                          arrowTipPoint.y - _arrowBase / 2);
            arrowBasePointB = CGPointMake(arrowTipPoint.x - _arrowHeight,
                                          arrowTipPoint.y + _arrowBase / 2);
            
            CGPathMoveToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
            
            if (self.usesRoundedArrow) {
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowBasePointA.x, arrowBasePointA.y + roundedArrowControlLength,
                                      arrowTipPoint.x, arrowTipPoint.y - (roundedArrowControlLength * 0.75f),
                                      arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddCurveToPoint(outerPathRef, NULL,
                                      arrowTipPoint.x, arrowTipPoint.y + (roundedArrowControlLength * 0.75f),
                                      arrowBasePointB.x, arrowBasePointB.y - roundedArrowControlLength,
                                      arrowBasePointB.x, arrowBasePointB.y);
            } else {
                CGPathAddLineToPoint(outerPathRef, NULL, arrowTipPoint.x, arrowTipPoint.y);
                CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointB.x, arrowBasePointB.y);
            }
            
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                (_arrowOffset >= 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                (_arrowOffset < 0) ? reducedOuterCornerRadius : _outerCornerRadius);
            
            CGPathAddLineToPoint(outerPathRef, NULL, arrowBasePointA.x, arrowBasePointA.y);
        } else if (_arrowDirection == WYPopoverArrowDirectionNone) {
            CGPoint origin = CGPointMake(CGRectGetMaxX(outerRect), CGRectGetMidY(outerRect));
            
            CGPathMoveToPoint(outerPathRef, NULL, origin.x, origin.y);
            
            CGPathAddLineToPoint(outerPathRef, NULL, CGRectGetMaxX(outerRect), CGRectGetMidY(outerRect));
            CGPathAddLineToPoint(outerPathRef, NULL, CGRectGetMaxX(outerRect), CGRectGetMidY(outerRect));
            
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect),
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMinX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                _outerCornerRadius);
            CGPathAddArcToPoint(outerPathRef, NULL,
                                CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect),
                                CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect),
                                _outerCornerRadius);
            
            CGPathAddLineToPoint(outerPathRef, NULL, origin.x, origin.y);
        }
        
        CGPathCloseSubpath(outerPathRef);
        UIBezierPath *outerRectPath = [UIBezierPath bezierPathWithCGPath:outerPathRef];
        
        CGContextSaveGState(context);
        {
            CGContextSetShadowWithColor(context, self.outerShadowOffset, _outerShadowBlurRadius, _outerShadowColor.CGColor);
            CGContextBeginTransparencyLayer(context, NULL);
            [outerRectPath addClip];
            CGRect outerRectBounds = CGPathGetPathBoundingBox(outerRectPath.CGPath);
            CGContextDrawLinearGradient(context, fillGradient,
                                        CGPointMake(CGRectGetMidX(outerRectBounds), CGRectGetMinY(outerRectBounds)),
                                        CGPointMake(CGRectGetMidX(outerRectBounds), CGRectGetMaxY(outerRectBounds)),
                                        0);
            CGContextEndTransparencyLayer(context);
        }
        CGContextRestoreGState(context);
        
        ////// outerRect Inner Shadow
        CGRect outerRectBorderRect = CGRectInset([outerRectPath bounds], -_glossShadowBlurRadius, -_glossShadowBlurRadius);
        outerRectBorderRect = CGRectOffset(outerRectBorderRect, -_glossShadowOffset.width, -_glossShadowOffset.height);
        outerRectBorderRect = CGRectInset(CGRectUnion(outerRectBorderRect, [outerRectPath bounds]), -1, -1);
        
        UIBezierPath *outerRectNegativePath = [UIBezierPath bezierPathWithRect:outerRectBorderRect];
        [outerRectNegativePath appendPath:outerRectPath];
        outerRectNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            float xOffset = _glossShadowOffset.width + round(outerRectBorderRect.size.width);
            float yOffset = _glossShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        _glossShadowBlurRadius,
                                        self.glossShadowColor.CGColor);
            
            [outerRectPath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(outerRectBorderRect.size.width), 0);
            [outerRectNegativePath applyTransform:transform];
            [[UIColor grayColor] setFill];
            [outerRectNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        [self.outerStrokeColor setStroke];
        outerRectPath.lineWidth = 1;
        [outerRectPath stroke];
        
        //// Cleanup
        CFRelease(outerPathRef);
        CGGradientRelease(fillGradient);
        CGColorSpaceRelease(colorSpace);
        
        UIGraphicsPopContext();
    }
}


#pragma mark Private

- (CGRect)outerRect {
    return [self outerRect:self.bounds arrowDirection:self.arrowDirection];
}


- (CGRect)innerRect {
    return [self innerRect:self.bounds arrowDirection:self.arrowDirection];
}


- (CGRect)arrowRect {
    return [self arrowRect:self.bounds arrowDirection:self.arrowDirection];
}


- (CGRect)outerRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection {
    CGRect result = rect;
    
    if (aArrowDirection == WYPopoverArrowDirectionUp || _arrowDirection == WYPopoverArrowDirectionDown) {
        result.size.height -= _arrowHeight;
        
        if (aArrowDirection == WYPopoverArrowDirectionUp) {
            result = CGRectOffset(result, 0, _arrowHeight);
        }
    }
    
    if (aArrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
        result.size.width -= _arrowHeight;
        
        if (aArrowDirection == WYPopoverArrowDirectionLeft) {
            result = CGRectOffset(result, _arrowHeight, 0);
        }
    }
    
    result = CGRectInset(result, _outerShadowBlurRadius, _outerShadowBlurRadius);
    result.origin.x -= self.outerShadowOffset.width;
    result.origin.y -= self.outerShadowOffset.height;
    
    return result;
}


- (CGRect)innerRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection {
    CGRect result = [self outerRect:rect arrowDirection:aArrowDirection];
    
    result.origin.x += _borderWidth;
    result.origin.y += 0;
    result.size.width -= 2 * _borderWidth;
    result.size.height -= _borderWidth;
    
    if (_navigationBarHeight == 0 || _wantsDefaultContentAppearance) {
        result.origin.y += _borderWidth;
        result.size.height -= _borderWidth;
    }
    
    result.origin.x += _viewContentInsets.left;
    result.origin.y += _viewContentInsets.top;
    result.size.width = result.size.width - _viewContentInsets.left - _viewContentInsets.right;
    result.size.height = result.size.height - _viewContentInsets.top - _viewContentInsets.bottom;
    
    if (_borderWidth > 0) {
        result = CGRectInset(result, -1, -1);
    }
    
    return result;
}


- (CGRect)arrowRect:(CGRect)rect arrowDirection:(WYPopoverArrowDirection)aArrowDirection {
    CGRect result = CGRectZero;
    
    if (_arrowHeight > 0) {
        result.size = CGSizeMake(_arrowBase, _arrowHeight);
        
        if (aArrowDirection == WYPopoverArrowDirectionLeft || _arrowDirection == WYPopoverArrowDirectionRight) {
            result.size = CGSizeMake(_arrowHeight, _arrowBase);
        }
        
        CGRect outerRect = [self outerRect:rect arrowDirection:aArrowDirection];
        
        if (aArrowDirection == WYPopoverArrowDirectionDown) {
            result.origin.x = CGRectGetMidX(outerRect) - result.size.width / 2 + _arrowOffset;
            result.origin.y = CGRectGetMaxY(outerRect);
        }
        
        if (aArrowDirection == WYPopoverArrowDirectionUp) {
            result.origin.x = CGRectGetMidX(outerRect) - result.size.width / 2 + _arrowOffset;
            result.origin.y = CGRectGetMinY(outerRect) - result.size.height;
        }
        
        if (aArrowDirection == WYPopoverArrowDirectionRight) {
            result.origin.x = CGRectGetMaxX(outerRect);
            result.origin.y = CGRectGetMidY(outerRect) - result.size.height / 2 + _arrowOffset;
        }
        
        if (aArrowDirection == WYPopoverArrowDirectionLeft) {
            result.origin.x = CGRectGetMinX(outerRect) - result.size.width;
            result.origin.y = CGRectGetMidY(outerRect) - result.size.height / 2 + _arrowOffset;
        }
    }
    
    return result;
}


#pragma mark Memory Management

- (void)dealloc {
    _contentView      = nil;
    _innerView         = nil;
    _tintColor        = nil;
    _outerStrokeColor = nil;
    _innerStrokeColor = nil;
    _fillTopColor     = nil;
    _fillBottomColor  = nil;
    _glossShadowColor = nil;
    _outerShadowColor = nil;
    _innerShadowColor = nil;
}

@end