//
//  UIWebView+CSSRule.m
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIWebView+CSSRule.h"

#define varMySheet @"var mySheet = document.styleSheets[0];"
#define addCSSRules @"function addCSSRule(selector, newRule) {ruleIndex = mySheet.cssRules.length;mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);}"
#define createColumsRule @"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')"
#define textAlignRule @"addCSSRule('p', 'text-align: justify;')"
#define textFontRule @"addCSSRule('p', 'font-family: %@;')"
#define fontSizeRule @"addCSSRule('body', '-webkit-text-size-adjust: %lu%%;')"
#define backgroundColorRule @"addCSSRule('body', 'background-color: %@;')"
#define imageSizeRule @"addCSSRule('img', 'max-height:%fpx;')"
#define documentWidth @"document.documentElement.scrollWidth"

@implementation UIWebView (CSSRule)

- (void)createColumns {
    CGFloat screenWidth = [self shouldShowTwoColumns] ? [self width] / 2 : [self width];
    NSString *insertRule1 = [NSString stringWithFormat:createColumsRule, [self height], screenWidth];
    [self stringByEvaluatingJavaScriptFromString:insertRule1];
}


- (void)changeTextSizeToPercentSize:(NSUInteger)fontPercentSize {
    NSString *setTextSizeRule = [NSString stringWithFormat:fontSizeRule, (unsigned long)fontPercentSize];
    [self stringByEvaluatingJavaScriptFromString:setTextSizeRule];
}


- (void)resizeImagesToMaximumSize {
    NSString *imagesRule = [NSString stringWithFormat:imageSizeRule, [self height]];
    [self stringByEvaluatingJavaScriptFromString:imagesRule];
}


- (void)runFormatingTextRulesWithFontPercentSize:(NSUInteger)fontPercentSize {
    [self createColumns];
    [self stringByEvaluatingJavaScriptFromString:textAlignRule];
    [self changeTextSizeToPercentSize:fontPercentSize];
    [self resizeImagesToMaximumSize];
}


- (void)runFormatingTextRulesWithFontName:(NSString *)name {
    NSString *fontRule = [NSString stringWithFormat:textFontRule, name];
    [self stringByEvaluatingJavaScriptFromString:fontRule];

}


- (void)runCSSRulesToWebViewWithPercentSize:(NSUInteger)fontPercentSize
                                   fontName:(NSString *)fontName {
    [self stringByEvaluatingJavaScriptFromString:varMySheet];
    [self stringByEvaluatingJavaScriptFromString:addCSSRules];
    [self runFormatingTextRulesWithFontPercentSize:fontPercentSize];
    if (fontName) {
        [self runFormatingTextRulesWithFontName:fontName];
    }
    NSString *backgroundRule = [NSString stringWithFormat:backgroundColorRule, @"transparent"];
    [self stringByEvaluatingJavaScriptFromString:backgroundRule];
}


- (NSUInteger)numberOfPages {
    float totalWidth = [[self stringByEvaluatingJavaScriptFromString:documentWidth] floatValue];
    
    return (NSUInteger)ceil((totalWidth / self.bounds.size.width));
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (CGFloat)width {
    return self.frame.size.width;
}


- (BOOL)shouldShowTwoColumns {
    return [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone &&
    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

@end
