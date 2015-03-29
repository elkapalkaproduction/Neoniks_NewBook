//
//  TopBarIconViewController.h
//  World
//
//  Created by Andrei Vidrasco on 3/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopBarIconType) {
    TopBarIconTypeUnknown,
    TopBarIconTypeLanguage,
    TopBarIconTypePlayAgain,
    TopBarIconTypeAboutProject,
    TopBarIconTypeContributors,
    TopBarIconTypeRateUs,
    TopBarIconTypeSound,
};

@protocol TopBarIconDelegate <NSObject>

- (void)pressIconWithType:(TopBarIconType)type;

@end

@interface TopBarIconViewController : UIViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(TopBarIconType)type
                            delegate:(id<TopBarIconDelegate>)delegate;

@end
