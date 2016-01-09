//
//  IslandViewModel.h
//  World
//
//  Created by Andrei Vidrasco on 3/7/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopUpViewController;

@protocol IslandViewModelDelegate <NSObject>

- (void)openPopUpViewController:(PopUpViewController *)controller;
- (void)updateInterface;

@end

@interface IslandViewModel : NSObject

- (instancetype)initWithDelegate:(id<IslandViewModelDelegate>)delegate;

- (void)didTapOnPoint:(CGPoint)point;
- (NSInteger)currentNeedToFind;
- (NSInteger)maxSolved;
- (void)resetAnswers;
- (BOOL)foundAll;
+ (void)deleteAnswers;

@end
