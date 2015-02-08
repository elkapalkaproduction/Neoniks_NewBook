//
//  BaseViewController.h
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

@interface BaseViewController : UIViewController

@property (strong, nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray * constraintsToUpdate;

+ (NSString *)storyboardID;
- (IBAction)backButton:(id)sender;
@end
