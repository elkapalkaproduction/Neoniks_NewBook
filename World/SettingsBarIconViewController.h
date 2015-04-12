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
};

@class SettingsBarIconViewController;
@protocol SettingsBarIconDelegate <NSObject>

- (void)settingBar:(SettingsBarIconViewController *)settings didPressIconWithType:(SettingsBarIconType)type;

@end

@interface SettingsBarIconViewController : UIViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                            delegate:(id<SettingsBarIconDelegate>)delegate;

@end
