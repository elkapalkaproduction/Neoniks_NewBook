//
//  TopBarIconViewController.m
//  World
//
//  Created by Andrei Vidrasco on 3/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "TopBarIconViewController.h"

@interface TopBarIconViewController ()

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) id<TopBarIconDelegate> delegate;
@property (assign, nonatomic) TopBarIconType type;
@property (assign, nonatomic) CGRect frame;

@end

@implementation TopBarIconViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(TopBarIconType)type
                           delegate:(id<TopBarIconDelegate>)delegate {
    TopBarIconViewController *viewController = [[TopBarIconViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    viewController.frame = frame;
    viewController.type = type;
    viewController.delegate = delegate;
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = self.frame;
    NSString *baseText;
    switch (self.type) {
        case TopBarIconTypeLanguage:
            baseText = @"top_bar_language";
            break;
        case TopBarIconTypePlayAgain:
            baseText = @"top_bar_play_again";
            break;
        case TopBarIconTypeAboutProject:
            baseText = @"top_bar_about";
            break;
        case TopBarIconTypeContributors:
            baseText = @"top_bar_contributors";
            break;
        case TopBarIconTypeRateUs:
            baseText = @"top_bar_rate_us";
            break;
        case TopBarIconTypeSound:
            baseText = @"top_bar_sound";
            break;
        default:
            break;
    }
    NSString *iconName = NSLocalizedString([baseText stringByAppendingString:@"_icon"], nil);
    NSString *textImageName = NSLocalizedString([baseText stringByAppendingString:@"_text"], nil);
    [self.icon setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [self.titleImage setImage:[UIImage imageNamed:textImageName]];
    // Do any additional setup after loading the view.
}


- (IBAction)selectIcon:(id)sender {
    [self.delegate pressIconWithType:self.type];
}


@end
