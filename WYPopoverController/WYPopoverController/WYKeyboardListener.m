//
//  WYKeyboardListener.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYKeyboardListener.h"
@import UIKit;

@implementation WYKeyboardListener

static BOOL _isVisible;
static CGRect _keyboardRect;

+ (void)load {
    @autoreleasepool {
        _keyboardRect = CGRectZero;
        _isVisible = NO;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
}


+ (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    _keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _isVisible = YES;
}


+ (void)keyboardWillHide {
    _keyboardRect = CGRectZero;
    _isVisible = NO;
}


+ (BOOL)isVisible {
    return _isVisible;
}


+ (CGRect)rect {
    return _keyboardRect;
}

@end
