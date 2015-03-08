//
//  IslandViewModel.h
//  World
//
//  Created by Andrei Vidrasco on 3/7/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopUpViewController;

typedef NS_ENUM(NSInteger, IslandToFind) {
    IslandToFindSchool,
    IslandToFindHouse,
    IslandToFindCafe,
    IslandToFindLighthouse,
    IslandToFindMuseum,
    IslandToFindCastle,
    IslandToFindBottomles,
    IslandToFindSolvedAll,
};

@protocol IslandViewModelDelegate <NSObject>

- (void)openPopUpViewController:(PopUpViewController *)controller;
- (void)updateInterface;

@end

@interface IslandViewModel : NSObject

- (instancetype)initWithDelegate:(id<IslandViewModelDelegate>)delegate;

- (void)didTapOnPoint:(CGPoint)point;
- (IslandToFind)currentNeedToFind;
- (void)resetAnswers;

@end
