//
//  MainScreenViewModel.h
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MainScreenTopBarViewType) {
    MainScreenTopBarViewTypeUndefinied,
    MainScreenTopBarViewTypeSettings,
    MainScreenTopBarViewTypeInventary,
};

@class MainScreenViewModel;

@protocol MainScreenViewModelDelegate <NSObject>

- (void)didChangeLanguageInMainScreenViewModel:(MainScreenViewModel *)viewModel;
- (void)mainScreenViewModel:(MainScreenViewModel *)viewModel didWantToOpenViewController:(UIViewController *)viewController;

@end

@interface MainScreenViewModel : NSObject

- (instancetype)initWithDelegate:(UIViewController<MainScreenViewModelDelegate> *)delegate;

@property (assign, nonatomic, readonly) NSInteger numberOfItems;
- (UIView *)viewForIndex:(NSInteger)index inRect:(CGRect)rect parentViewController:(UIViewController *)parentViewController;

@property (assign, nonatomic) MainScreenTopBarViewType type;

@end