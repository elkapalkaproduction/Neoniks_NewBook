//
//  NNKChapter.m
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKChapter.h"
#import "UIWebView+CSSRule.h"

@interface NNKChapter ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NNKChapter

- (instancetype)initWithPath:(NSString *)theSpinePath
                       title:(NSString *)theTitle
                chapterIndex:(NSUInteger)theIndex {
    self = [super init];
    if (self) {
        _spinePath = theSpinePath;
        _title = theTitle;
        _chapterIndex = theIndex;
    }
    
    return self;
}


- (void)loadChapter {
    self.webView = [[UIWebView alloc] initWithFrame:[self.delegate bounds]];
    [self.webView setDelegate:self];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.spinePath]];
    [self.webView loadRequest:urlRequest];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView runCSSRulesToWebViewWithPercentSize:[self.delegate currentTextSize]
                                        fontName:[self.delegate fontName]];
    
    self.pageCount = webView.numberOfPages;
    self.webView = nil;
    
    [self.delegate chapterDidFinishLoad:self];
}

@end
