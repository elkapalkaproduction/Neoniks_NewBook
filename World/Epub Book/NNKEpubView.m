//
//  NNKEpubView.m
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKEpubView.h"
#import "NNKEpubToChaptersConverter.h"
#import "NNKChapter.h"
#import "UIWebView+CSSRule.h"

#define kMinTextSize 50
#define kMaxTextSize 200
#define kChangeTextStep 25

@interface NNKEpubView () <ChapterDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSArray *chapters;
@property (nonatomic, strong) UIWebView *webView;

@property (assign, nonatomic) NSUInteger currentSpineIndex;
@property (assign, nonatomic) NSUInteger currentPageInSpineIndex;
@property (assign, nonatomic) NSUInteger pagesInCurrentSpineCount;
@property (assign, nonatomic) NSUInteger currentTextSize;
@property (strong, nonatomic) NSString *textColor;
@property (strong, nonatomic) NSString *backgroundColor;
@property (assign, nonatomic, readwrite) NSUInteger totalPagesCount;
@property (assign, nonatomic) BOOL paginating;

@end

@implementation NNKEpubView
@synthesize currentPageNumber = _currentPageNumber;
@synthesize fontName = _fontName;

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self onInit];
    }

    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self onInit];
    }

    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self onInit];
    }

    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
    [self updatePagination];
}


#pragma mark - Public Methods

- (void)loadEpub:(NSString *)epubPath {
    self.currentSpineIndex = 0;
    self.currentPageInSpineIndex = 0;
    self.pagesInCurrentSpineCount = 0;
    self.totalPagesCount = 0;
    NNKEpubToChaptersConverter *converter = [[NNKEpubToChaptersConverter alloc] init];
    [converter convertWithEpubPath:epubPath completionBlock:^(NSArray *resultArray) {
         self.chapters = resultArray;
         [self updatePagination];
     }];
}


- (void)loadSpine:(NSUInteger)spineIndex atPageIndex:(NSUInteger)pageIndex {
    NSURL *url = [NSURL fileURLWithPath:[(self.chapters)[spineIndex] spinePath]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    self.currentPageInSpineIndex = pageIndex;
    self.currentSpineIndex = spineIndex;
    if (!self.paginating && [self.delegate respondsToSelector:@selector(pageDidChange)]) {
        [self.delegate pageDidChange];
    }
}


- (void)increaseTextSize {
    if (!self.paginating) {
        if (self.currentTextSize + kChangeTextStep <= kMaxTextSize) {
            self.currentTextSize += kChangeTextStep;
            [self updatePagination];
        }
    }
}


- (void)decreaseTextSize {
    if (!self.paginating) {
        if (self.currentTextSize - kChangeTextStep >= kMinTextSize) {
            self.currentTextSize -= kChangeTextStep;
            [self updatePagination];
        }
    }
}


- (void)changeColorToColor:(NSString *)color {
    self.textColor = [color isEqual:@"black"] ? @"white" : @"black";
    self.backgroundColor = color;
    [self updatePagination];
}


#pragma mark - Chapters Delegate

- (void)chapterDidFinishLoad:(NNKChapter *)chapter {
    self.totalPagesCount += chapter.pageCount;

    if (chapter.chapterIndex + 1 < [self.chapters count]) {
        NNKChapter *currentChapter = self.chapters[chapter.chapterIndex + 1];
        [currentChapter setDelegate:self];
        [currentChapter loadChapter];
    } else {
        self.paginating = NO;
        if ([self.delegate respondsToSelector:@selector(pageDidChange)]) {
            [self.delegate pageDidChange];
        }

    }
}


#pragma mark - WebView Delegate


- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    [self updateCurrentSpineIndexBasedOnWebView:theWebView];
    [self.webView runCSSRulesToWebViewWithPercentSize:self.currentTextSize
                                             fontName:self.fontName
                                            fontColor:self.textColor];
    self.pagesInCurrentSpineCount = self.webView.numberOfPages;
    [self gotoPageInCurrentSpine:self.currentPageInSpineIndex];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

#pragma mark - Custom Accessors

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    [self updatePagination];
}


- (void)setPaginating:(BOOL)paginating {
    _paginating = paginating;
    if (paginating) {
        if ([self.delegate respondsToSelector:@selector(paginationDidStart)]) {
            [self.delegate paginationDidStart];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(paginationDidFinish)]) {
            [self.webView runCSSRulesToWebViewWithPercentSize:self.currentTextSize
                                                     fontName:self.fontName
                                                    fontColor:self.textColor];
            [self.delegate paginationDidFinish];
        }
    }
}


- (void)setCurrentPageNumber:(NSUInteger)currentPageNumber {
    __block NSUInteger pageSum = 0;
    __block NSUInteger chapterIndex = 0;
    __block NSUInteger pageIndex = 0;
    NSUInteger targetPage = currentPageNumber;

    [self.chapters enumerateObjectsUsingBlock:^(NNKChapter *currentChapter, NSUInteger idx, BOOL *stop) {
         pageSum += [currentChapter pageCount];
         if (pageSum >= targetPage) {
             pageIndex = [currentChapter pageCount] - 1 - pageSum + targetPage;
             chapterIndex = idx;
             *stop = YES;
         }
     }];

    [self loadSpine:chapterIndex atPageIndex:pageIndex];
}


- (NSUInteger)currentPageNumber {
    __block NSUInteger pageCount = 0;

    [self.chapters enumerateObjectsUsingBlock:^(NNKChapter *currentChapter, NSUInteger idx, BOOL *stop) {
         if (idx < self.currentSpineIndex) {
             pageCount += [currentChapter pageCount];
         } else {
             *stop = YES;
         }
     }];

    pageCount += self.currentPageInSpineIndex + 1;

    return pageCount;
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
        [self addSubview:_webView];
    }

    return _webView;
}


- (NSString *)textColor {
    if (!_textColor) {
        _textColor = @"black";
    }
    
    return _textColor;
}


- (NSString *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = @"white";
    }
    
    return _backgroundColor;
}


#pragma mark - Private Methods

- (void)disableScrollOnSubviews {
    UIScrollView *sv = nil;
    for (UIView *v in self.webView.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            sv = (UIScrollView *)v;
            sv.scrollEnabled = NO;
            sv.bounces = NO;
        }
    }
}


- (void)connectGestures {
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(gotoNextPage)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(gotoPrevPage)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];

    [self.webView addGestureRecognizer:rightSwipeRecognizer];
    [self.webView addGestureRecognizer:leftSwipeRecognizer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(showOrHideMenu)];
    tapGesture.delegate = self;
    [self.webView addGestureRecognizer:tapGesture];
}


- (void)updatePagination {
    if (!self.chapters) return;
    if (self.paginating) return;

    self.paginating = YES;
    self.totalPagesCount = 0;

    [self loadSpine:self.currentSpineIndex atPageIndex:self.currentPageInSpineIndex];

    NNKChapter *chapter = [self.chapters firstObject];

    [chapter setDelegate:self];
    [chapter loadChapter];
}


- (void)onInit {
    [self disableScrollOnSubviews];
    [self connectGestures];
    self.currentTextSize = 100;
}


- (void)updateCurrentSpineIndexBasedOnWebView:(UIWebView *)webView {
    NSString *path = webView.request.URL.path;
    for (NNKChapter *chapter in self.chapters) {
        if ([[chapter spinePath] isEqualToString:path] && self.currentSpineIndex != chapter.chapterIndex) {
            self.currentSpineIndex = chapter.chapterIndex;
        }
    }
}


- (void)showOrHideMenu {
    if ([self.delegate respondsToSelector:@selector(showOrHideMenu)]) {
        [self.delegate showOrHideMenu];
    }
}


- (void)gotoPageInCurrentSpine:(NSUInteger)pageIndex {
    if (pageIndex >= self.pagesInCurrentSpineCount) {
        pageIndex = self.pagesInCurrentSpineCount - 1;
        self.currentPageInSpineIndex = self.pagesInCurrentSpineCount - 1;
    }

    float pageOffset = pageIndex * self.bounds.size.width;

    NSString *goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
    NSString *goTo = [NSString stringWithFormat:@"pageScroll(%f)", pageOffset];

    [self.webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
    [self.webView stringByEvaluatingJavaScriptFromString:goTo];
    if (!self.paginating && [self.delegate respondsToSelector:@selector(pageDidChange)]) {
        [self.delegate pageDidChange];
    }
}


- (void)gotoNextSpine {
    if (self.paginating) return;

    if (self.currentSpineIndex + 1 < [self.chapters count]) {
        [self loadSpine:++self.currentSpineIndex atPageIndex:0];
    }
}


- (void)gotoPrevSpineOnLastPage {
    if (self.paginating) return;

    if (self.currentSpineIndex != 0) {
        NNKChapter *currentChapter = self.chapters[self.currentSpineIndex - 1];
        NSUInteger targetPage = [currentChapter pageCount];
        [self loadSpine:--self.currentSpineIndex atPageIndex:targetPage - 1];
    }
}


- (void)gotoNextPage {
    if (self.paginating) return;

    if (self.currentPageInSpineIndex + 1 < self.pagesInCurrentSpineCount) {
        [self gotoPageInCurrentSpine:++self.currentPageInSpineIndex];
    } else {
        [self gotoNextSpine];
    }
}


- (void)gotoPrevPage {
    if (self.paginating) return;

    if (self.currentPageInSpineIndex != 0) {
        [self gotoPageInCurrentSpine:--self.currentPageInSpineIndex];
    } else {
        [self gotoPrevSpineOnLastPage];
    }
}

@end
