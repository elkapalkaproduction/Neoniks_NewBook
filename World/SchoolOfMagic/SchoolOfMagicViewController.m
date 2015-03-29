//
//  SchoolOfMagicViewController.m
//  World
//
//  Created by Andrei Vidrasco on 1/31/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SchoolOfMagicViewController.h"
#import "MagicTableViewController.h"
#import "MagicSchoolAnswersHandler.h"

@interface SchoolOfMagicViewController ()
@property (weak, nonatomic) MagicTableViewController *tableViewController;
@end

@implementation SchoolOfMagicViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:[MagicTableViewController storyboardID]]) {
        self.tableViewController = segue.destinationViewController;
    }
}

@end
