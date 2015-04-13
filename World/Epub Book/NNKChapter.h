//
//  NNKChapter.h
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class NNKChapter;

@protocol ChapterDelegate <NSObject>
- (void)chapterDidFinishLoad:(NNKChapter *)chapter;
- (NSString *)fontName;
- (NSUInteger)currentTextSize;
- (CGRect)bounds;

@end

@interface NNKChapter : NSObject <UIWebViewDelegate>

@property (nonatomic, strong) id<ChapterDelegate> delegate;

@property (nonatomic, assign) NSUInteger chapterIndex;
@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *spinePath;

- (instancetype)initWithPath:(NSString *)theSpinePath
                       title:(NSString *)theTitle
                chapterIndex:(NSUInteger)theIndex;

- (void)loadChapter;

@end
