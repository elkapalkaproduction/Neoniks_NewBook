//
//  MainScreenViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MainScreenViewModel.h"
#import "SettingsBarIconViewController.h"
#import "ContributorsViewController.h"
#import "AboutViewController.h"
#import "AlertViewController.h"
#import "Animator.h"
#import "DragableButton.h"
#import "ShadowPlayOpenedHandler.h"
#import "MagicSchoolAnswersHandler.h"
#import "IslandViewModel.h"
#import "InventaryContentHandler.h"

NSString *const AppID = @"899196882";

@interface MainScreenViewModel () <SettingsBarIconDelegate>

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
    return [self isOpenedSettings] ? 6 : [[InventaryContentHandler sharedHandler] numberOfItems];
}


- (UIViewController *)viewControllerForIndex:(NSInteger)index rect:(CGRect)rect {
    switch (self.type) {
        case MainScreenTopBarViewTypeUndefinied:
            return nil;
        case MainScreenTopBarViewTypeSettings:
            return [SettingsBarIconViewController instantiateWithFrame:rect type:index + 1 delegate:self];
        case MainScreenTopBarViewTypeInventary:
            return [self inventaryControllerForIndex:index rect:rect];
        default:
            return nil;
    }
}


- (UIViewController *)inventaryControllerForIndex:(NSInteger)index rect:(CGRect)rect {
    InventaryContentHandler *handler = [InventaryContentHandler sharedHandler];
    InventaryItemOption *option = [handler inventaryOptionForType:index];
    SettingsBarIconViewController *controller = [SettingsBarIconViewController instantiateWithFrame:rect
                                                                                               type:option.type
                                                                                             format:option.format
                                                                                           delegate:self];
    
    return controller;
}


- (UIView *)viewForIndex:(NSInteger)index inRect:(CGRect)rect parentViewController:(UIViewController *)parentViewController {
    UIViewController *viewController = [self viewControllerForIndex:index rect:rect];
    if (!viewController) return [UIView new];
    [parentViewController addChildViewController:viewController withSuperview:nil];
    
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
        case SettingsBarIconTypeIslandMap:
        case SettingsBarIconTypeMagicWand:
        case SettingsBarIconTypeMagicBook:
        case SettingsBarIconTypeMedal:
        case SettingsBarIconTypeBottleOfMagic:
        case SettingsBarIconTypeMagicBall:
        case SettingsBarIconTypeExtinguisher:
        case SettingsBarIconTypeDandelion:
        case SettingsBarIconTypeSword:
        case SettingsBarIconTypeWrench:
        case SettingsBarIconTypeSnail:
            if (settings.format == InventaryIconShowingEmpty) {
                [self.delegate didRequireToOpenTextBarWithIcon:[UIImage imageNamed:[self imageNameFromSettingType:type]]
                                                          text:NSLocalizedString([self textFromSettingsType:type], nil)
                                                      isObject:YES];
            }
            break;
        default:
            break;
    }
}


- (void)settingBar:(SettingsBarIconViewController *)settings
didSwipeIconWithType:(SettingsBarIconType)type
            inRect:(CGRect)rect
     relatedToView:(UIView *)view
             image:(UIImage *)image {
    [self.delegate didSwipeIconWithType:type inRect:rect relatedToView:view image:image];
}


- (NSString *)imageNameFromSettingType:(SettingsBarIconType)type {
    switch (type) {
        case SettingsBarIconTypeIslandMap:
            return @"inventary_full_island_map_icon";
        case SettingsBarIconTypeMagicWand:
            return @"inventary_full_magic_wand_icon";
        case SettingsBarIconTypeMagicBook:
            return @"inventary_full_book_icon";
        case SettingsBarIconTypeMedal:
            return @"inventary_full_medal_icon";
        case SettingsBarIconTypeBottleOfMagic:
            return @"inventary_full_bottle_icon";
        case SettingsBarIconTypeMagicBall:
            return @"inventary_full_ball_of_magic_icon";
        case SettingsBarIconTypeExtinguisher:
            return @"inventary_full_extinguisher_icon";
        case SettingsBarIconTypeDandelion:
            return @"inventary_full_dandelion_icon";
        case SettingsBarIconTypeSword:
            return @"inventary_full_sword_icon";
        case SettingsBarIconTypeWrench:
            return @"inventary_full_wrench_icon";
        case SettingsBarIconTypeSnail:
            return @"inventary_full_snail_icon";
        default:
            return @"";
    }
}


- (NSString *)textFromSettingsType:(SettingsBarIconType)type {
    switch (type) {
        case SettingsBarIconTypeIslandMap:
            return @"text_panel_island";
        case SettingsBarIconTypeMagicWand:
            return @"text_panel_wand";
        case SettingsBarIconTypeMagicBook:
            return @"text_panel_book";
        case SettingsBarIconTypeMedal:
            return @"text_panel_medal";
        case SettingsBarIconTypeBottleOfMagic:
            return @"text_panel_bottle";
        case SettingsBarIconTypeMagicBall:
            return @"text_panel_magic_ball";
        case SettingsBarIconTypeExtinguisher:
            return @"text_panel_extinguisher";
        case SettingsBarIconTypeDandelion:
        case SettingsBarIconTypeSword:
        case SettingsBarIconTypeWrench:
        case SettingsBarIconTypeSnail:
            return @"text_panel_other";
        default:
            return @"";
    }
}

@end
