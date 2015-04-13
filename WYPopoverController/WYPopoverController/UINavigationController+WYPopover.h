//
//  UINavigationController+WYPopover.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface UINavigationController (WYPopover)

@property (nonatomic, assign, getter = wy_isEmbedInPopover) BOOL wy_embedInPopover;

@end
