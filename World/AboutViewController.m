//
//  AboutViewController.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (assign, nonatomic) BOOL updated;

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
    NSString *siteAddress = [@"http://" stringByAppendingString:site];

    NSRange range = [text rangeOfString:site];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:siteAddress]
                             range:range];
    self.mainLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor yellowColor]};
    self.mainLabel.attributedText = attributedString;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.updated) {
        self.updated = YES;
        self.mainLabel.contentOffset = CGPointZero;
    }
}

@end
