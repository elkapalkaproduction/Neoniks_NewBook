//
//  NNKShapedButton.m
//
//
//  Created by Andrei Vidrasco on 7/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NNKShapedButton.h"

const CGFloat ShapedButtonAlphaVisibleThreshold = 0.1f;

@interface NNKShapedButton ()

@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL previousTouchHitTestResponse;
@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UIImage *buttonBackground;
@end

@implementation NNKShapedButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }

    return self;
}


- (void)awakeFromNib {
    [self setup];
}


- (void)setup {
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}


#pragma mark - Hit testing

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;
    
    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;

    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }

    return alpha >= ShapedButtonAlphaVisibleThreshold;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }

    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }

    BOOL response = [self isAlphaVisibleAtPoint:point forImage:self.buttonImage] || [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];

    self.previousTouchHitTestResponse = response;

    return response;
}


#pragma mark - Accessors

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}


- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [super setBackgroundImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}


- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateImageCacheForCurrentState];
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateImageCacheForCurrentState];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateImageCacheForCurrentState];
}


#pragma mark - Helper methods

- (void)updateImageCacheForCurrentState {
    _buttonBackground = [self currentBackgroundImage];
    _buttonImage = [self currentImage];
}


- (void)resetHitTestCache {
    self.previousTouchPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    self.previousTouchHitTestResponse = NO;
}



@end
