//
//  AboutViewController.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation AboutViewController

+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleImage.image = [UIImage imageLocalizableNamed:@"about_page_title"];
    NSString *text = NSLocalizedString(@"about_page_text", nil);
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont baseFontOfSize:22],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSString *site = NSLocalizedString(@"site_address", nil);
    NSRange range = [text rangeOfString:site];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor yellowColor]
                             range:range];
    self.mainLabel.attributedText = attributedString;
}

@end
