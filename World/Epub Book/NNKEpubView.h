//
//  NNKEpubView.h
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NNKEpubViewDelegate <NSObject>

@optional
- (void)paginationDidStart;
- (void)paginationDidFinish;
- (void)pageDidChange;
- (void)showOrHideMenu;

@end

@interface NNKEpubView : UIView

- (void)loadEpub:(NSString *)epubPath;
- (void)loadSpine:(NSUInteger)spineIndex atPageIndex:(NSUInteger)pageIndex;
- (void)increaseTextSize;
- (void)decreaseTextSize;

@property (weak, nonatomic) id<NNKEpubViewDelegate> delegate;
@property (assign, nonatomic) NSUInteger currentPageNumber;
@property (assign, nonatomic, readonly) NSUInteger totalPagesCount;
@property (strong, nonatomic, readonly) NSArray *chapters;
@property (strong, nonatomic) NSString *fontName;

@end
