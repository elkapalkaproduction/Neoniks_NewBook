//
//  InventaryBarIconViewController.h
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InventaryBarIconType) {
    InventaryBarIconTypeUnknown,
    InventaryBarIconTypeLanguage,
    InventaryBarIconTypePlayAgain,
    InventaryBarIconTypeAboutProject,
    InventaryBarIconTypeContributors,
    InventaryBarIconTypeRateUs,
    InventaryBarIconTypeSound,
};

@class InventaryBarIconViewController;

@protocol InventaryBarIconDelegate <NSObject>

- (void)inventaryBar:(InventaryBarIconViewController *)settings didPressIconWithType:(InventaryBarIconType)type;

@end

@interface InventaryBarIconViewController : UIViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(InventaryBarIconType)type
                            delegate:(id<InventaryBarIconDelegate>)delegate;

@end
