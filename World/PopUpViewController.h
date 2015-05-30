//
//  PopUpViewController.h
//  World
//
//  Created by Andrei Vidrasco on 3/8/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, PopUpType) {
    PopUpTypeSchool,
    PopUpTypeLanternHouse,
    PopUpTypeCafe,
    PopUpTypeLighthouse,
    PopUpTypeMuseum,
    PopUpTypeFoamCastle,
    PopUpTypeBottomlessIsland,
};

@protocol PopUpDelegate  <NSObject>

- (void)didClosePopUp;

@end

@interface PopUpViewController : BaseViewController

+ (instancetype)instantiateWithType:(PopUpType)type
                          delegate:(id<PopUpDelegate>)delegate;

- (void)addOnParentView:(UIViewController *)viewController;

@end
