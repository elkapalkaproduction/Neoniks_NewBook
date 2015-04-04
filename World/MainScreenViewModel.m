//
//  MainScreenViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MainScreenViewModel.h"
#import "SettingsBarIconViewController.h"
#import "InventaryBarIconViewController.h"
#import "ContributorsViewController.h"
#import "AboutViewController.h"
#import "AlertViewController.h"
#import "Animator.h"

#import "ShadowPlayOpenedHandler.h"
#import "MagicSchoolAnswersHandler.h"
#import "IslandViewModel.h"

NSString *const AppID = @"899196882";

@interface MainScreenViewModel () <SettingsBarIconDelegate, InventaryBarIconDelegate>

@property (weak, nonatomic) UIViewController<MainScreenViewModelDelegate> *delegate;

@end

@implementation MainScreenViewModel

- (instancetype)initWithDelegate:(UIViewController<MainScreenViewModelDelegate> *)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}


- (BOOL)isOpenedSettings {
    return self.type == MainScreenTopBarViewTypeSettings;
}

- (NSInteger)numberOfItems {
    return [self isOpenedSettings] ? 6 : 8;
}


- (UIViewController *)viewControllerForIndex:(NSInteger)index rect:(CGRect)rect {
    switch (self.type) {
        case MainScreenTopBarViewTypeUndefinied:
            return nil;
            break;
        case MainScreenTopBarViewTypeSettings:
            return [SettingsBarIconViewController instantiateWithFrame:rect type:index delegate:self];
            break;
        case MainScreenTopBarViewTypeInventary:
            return [InventaryBarIconViewController instantiateWithFrame:rect type:index delegate:self];
            break;
        default:
            break;
    }
}

- (UIView *)viewForIndex:(NSInteger)index inRect:(CGRect)rect parentViewController:(UIViewController *)parentViewController {
    UIViewController *viewController = [self viewControllerForIndex:index + 1 rect:rect];
    if (!viewController) return [UIView new];
    [viewController willMoveToParentViewController:parentViewController];
    [parentViewController addChildViewController:viewController];
    [viewController didMoveToParentViewController:parentViewController];

    return viewController.view;
}


- (void)didPressStartOver {
    AlertViewController *alert = [AlertViewController initWithTitle:NSLocalizedString(@"alert_start_over", nil)
                                                   firstButtonTitle:NSLocalizedString(@"alert_yes", nil)
                                                  firstButtonAction:^{
                                                       [[ShadowPlayOpenedHandler sharedHandler] resetOpenedCharacter];
                                                       [[MagicSchoolAnswersHandler sharedHandler] deleteAllAnswers];
                                                       [IslandViewModel deleteAnswers];
                                                   }
                                                  secondButtonTitle:NSLocalizedString(@"alert_no", nil)
                                                 secondButtonAction:nil];
    [alert showInViewController:self.delegate];
}


- (void)didPressContributors {
    ContributorsViewController *viewController = [ContributorsViewController instantiate];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = [Animator disolveAnimator];
    [self.delegate mainScreenViewModel:self didWantToOpenViewController:viewController];
}


- (void)didPressAbout {
    AboutViewController *viewController = [AboutViewController instantiate];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = [Animator disolveAnimator];
    [self.delegate mainScreenViewModel:self didWantToOpenViewController:viewController];
}


- (void)didPressRateUs {
    [[UIApplication sharedApplication] openURL:[NSURL openStoreToAppWithID:AppID]];
}


- (void)settingBar:(SettingsBarIconViewController *)settings didPressIconWithType:(SettingsBarIconType)type {
    switch (type) {
        case SettingsBarIconTypeUnknown:
            break;
        case SettingsBarIconTypeLanguage:
            [NSBundle setLanguage:NSLocalizedString(@"opposite_language", nil)];
            [self.delegate didChangeLanguageInMainScreenViewModel:self];
            break;
        case SettingsBarIconTypePlayAgain:
            [self didPressStartOver];
            break;
        case SettingsBarIconTypeAboutProject:
            [self didPressAbout];
            break;
        case SettingsBarIconTypeContributors:
            [self didPressContributors];
            break;
        case SettingsBarIconTypeRateUs:
            [self didPressRateUs];
            break;
        case SettingsBarIconTypeSound:
            break;
        default:
            break;
    }
}


- (void)inventaryBar:(InventaryBarIconViewController *)settings didPressIconWithType:(InventaryBarIconType)type {
    
}

@end
