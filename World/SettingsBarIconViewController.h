//
//  SettingsBarIconViewController.h
//  World
//
//  Created by Andrei Vidrasco on 3/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingsBarIconType) {
    SettingsBarIconTypeUnknown,
    SettingsBarIconTypeLanguage,
    SettingsBarIconTypePlayAgain,
    SettingsBarIconTypeAboutProject,
    SettingsBarIconTypeContributors,
    SettingsBarIconTypeRateUs,
    SettingsBarIconTypeSound,
    
    SettingsBarIconTypeBookContent,
    SettingsBarIconTypeBookAudio,
    SettingsBarIconTypeBookBookmark,
    SettingsBarIconTypeBookFontSize,
    
    SettingsBarIconTypeIslandMap,
    SettingsBarIconTypeMagicWand,
    SettingsBarIconTypeMagicBook,
    SettingsBarIconTypeMedal,
    SettingsBarIconTypeBottleOfMagic,
    SettingsBarIconTypeMagicBall,
    SettingsBarIconTypeExtinguisher,
    SettingsBarIconTypeDandelion,
    SettingsBarIconTypeSword,
    SettingsBarIconTypeWrench,
    SettingsBarIconTypeSnail,
};

typedef NS_ENUM(NSInteger, InventaryBarIconType) {
    InventaryBarIconTypeUnknown,
    InventaryBarIconTypeIslandMap,
    InventaryBarIconTypeMagicWand,
    InventaryBarIconTypeMagicBook,
    InventaryBarIconTypeMedal,
    InventaryBarIconTypeBottleOfMagic,
    InventaryBarIconTypeMagicBall,
    InventaryBarIconTypeExtinguisher,
    InventaryBarIconTypeDandelion,
    InventaryBarIconTypeSword,
    InventaryBarIconTypeWrench,
    InventaryBarIconTypeSnail,
};

typedef NS_ENUM(NSInteger, InventaryIconShowing) {
    InventaryIconShowingEmpty,
    InventaryIconShowingFull,
    InventaryIconShowingHidden,
};

@class SettingsBarIconViewController;
@protocol SettingsBarIconDelegate <NSObject>

- (void)settingBar:(SettingsBarIconViewController *)settings didPressIconWithType:(SettingsBarIconType)type;

@end

@interface SettingsBarIconViewController : UIViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                            delegate:(id<SettingsBarIconDelegate>)delegate;

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                              target:(id)target
                            selector:(SEL)selector;

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(InventaryBarIconType)type
                              format:(InventaryIconShowing)format
                            delegate:(id<SettingsBarIconDelegate>)delegate;

@property (assign, nonatomic, readonly) InventaryIconShowing format;

@end
