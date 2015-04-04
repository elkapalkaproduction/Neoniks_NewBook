//
//  ContributorsViewController.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ContributorsViewController.h"

@interface ContributorsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@end

@implementation ContributorsViewController

+ (instancetype)instantiate {
    ContributorsViewController *viewController = [[ContributorsViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleImageName = NSLocalizedString(@"contributions_title", nil);
    self.titleImage.image = [UIImage imageNamed:titleImageName];
    NSString *mainImageName = NSLocalizedString(@"contributions_main_image", nil);
    self.mainImage.image = [UIImage imageNamed:mainImageName];
}


- (IBAction)openSite:(id)sender {
    NSString *siteAddress = [@"http://" stringByAppendingString:NSLocalizedString(@"site_address", nil)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:siteAddress]];
}

@end
