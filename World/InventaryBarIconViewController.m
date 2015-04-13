//
//  InventaryBarIconViewController.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "InventaryBarIconViewController.h"

@interface InventaryBarIconViewController ()

@property (assign, nonatomic) CGRect frame;

@end

@implementation InventaryBarIconViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame type:(InventaryBarIconType)type delegate:(id<InventaryBarIconDelegate>)delegate {
    return [InventaryBarIconViewController new];
//    InventaryBarIconViewController *viewController = [[InventaryBarIconViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
//    viewController.frame = frame;
//    viewController.type = type;
//    viewController.delegate = delegate;
//    
//    return viewController;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = self.frame;
}

@end
