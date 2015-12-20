//
//  SideMenu.m
//  World
//
//  Created by Andrei Vidrasco on 12/19/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

#import "SideMenu.h"

@implementation SideMenu

+ (instancetype)sideMenu {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:0];
}


- (void)awakeFromNib {
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
