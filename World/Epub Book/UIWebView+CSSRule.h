//
//  UIWebView+CSSRule.h
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (CSSRule)

- (void)runCSSRulesToWebViewWithPercentSize:(NSUInteger)fontPercentSize
                                   fontName:(NSString *)fontName;

@property (assign, nonatomic, readonly) NSUInteger numberOfPages;

@end
