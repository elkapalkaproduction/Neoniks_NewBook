//
//  SideMenu.h
//  World
//
//  Created by Andrei Vidrasco on 12/19/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenu : UIView

+ (instancetype)sideMenu;
@property (weak, nonatomic) IBOutlet UIView *island;
@property (weak, nonatomic) IBOutlet UIView *bottleOfMagic;
@property (weak, nonatomic) IBOutlet UIView *medal;
@property (weak, nonatomic) IBOutlet UIView *book;
@property (weak, nonatomic) IBOutlet UIView *magicWand;
@property (weak, nonatomic) IBOutlet UIView *magicBalls;
@property (weak, nonatomic) IBOutlet UIView *wrench;
@property (weak, nonatomic) IBOutlet UIView *extinguisher;
@property (weak, nonatomic) IBOutlet UIView *sword;
@property (weak, nonatomic) IBOutlet UIView *dandelion;
@property (weak, nonatomic) IBOutlet UIView *snail;

@end
