//
//  SettingsBarIconViewController.m
//  World
//
//  Created by Andrei Vidrasco on 3/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SettingsBarIconViewController.h"

@interface SettingsBarIconViewController ()

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) id<SettingsBarIconDelegate> delegate;
@property (assign, nonatomic) SettingsBarIconType type;
@property (assign, nonatomic) CGRect frame;

@end

@implementation SettingsBarIconViewController

+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                           delegate:(id<SettingsBarIconDelegate>)delegate {
    SettingsBarIconViewController *viewController = [[SettingsBarIconViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
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
        case SettingsBarIconTypeLanguage:
            baseText = @"top_bar_language";
            break;
        case SettingsBarIconTypePlayAgain:
            baseText = @"top_bar_play_again";
            break;
        case SettingsBarIconTypeAboutProject:
            baseText = @"top_bar_about";
            break;
        case SettingsBarIconTypeContributors:
            baseText = @"top_bar_contributors";
            break;
        case SettingsBarIconTypeRateUs:
            baseText = @"top_bar_rate_us";
            break;
        case SettingsBarIconTypeSound:
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
    [self.delegate settingBar:self didPressIconWithType:self.type];
}


@end
