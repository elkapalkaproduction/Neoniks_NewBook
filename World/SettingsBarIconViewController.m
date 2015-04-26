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
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@property (assign, nonatomic) InventaryIconShowing format;

@end

@implementation SettingsBarIconViewController

+ (SettingsBarIconViewController *)instantiateWithFrame:(CGRect)frame type:(SettingsBarIconType)type {
    SettingsBarIconViewController *viewController = [[SettingsBarIconViewController alloc] initWithNibName:nil bundle:nil];
    viewController.frame = frame;
    viewController.type = type;
    
    return viewController;
}


+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                           delegate:(id<SettingsBarIconDelegate>)delegate {
    SettingsBarIconViewController *viewController = [self instantiateWithFrame:frame type:type];
    viewController.delegate = delegate;
    
    return viewController;
}


+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(SettingsBarIconType)type
                              target:(id)target
                            selector:(SEL)selector {
    SettingsBarIconViewController *viewController = [self instantiateWithFrame:frame type:type];
    viewController.target = target;
    viewController.selector = selector;
    
    return viewController;
}


+ (instancetype)instantiateWithFrame:(CGRect)frame
                                type:(InventaryBarIconType)type
                              format:(InventaryIconShowing)format
                            delegate:(id<SettingsBarIconDelegate>)delegate {
    SettingsBarIconType settingsType = type + SettingsBarIconTypeBookFontSize;
    SettingsBarIconViewController *settings = [self instantiateWithFrame:frame type:settingsType delegate:delegate];
    settings.format = format;
    
    return settings;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = self.frame;
    NSString *prefix = @"inventary_";
    NSString *prefixWithFormat = [self addFormatToPrefix:prefix];
    NSString *baseText = [self addIconNameToPrefix:prefixWithFormat];
    NSString *iconName = NSLocalizedString([baseText stringByAppendingString:@"_icon"], nil);
    NSString *textImageName = NSLocalizedString([baseText stringByAppendingString:@"_text"], nil);
    [self.icon setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [self.titleImage setImage:[UIImage imageNamed:textImageName]];
    if (!self.target) {
        self.target = self;
        self.selector = @selector(selectIcon:);
    }
    [self.icon addTarget:self.target action:self.selector forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}


- (NSString *)addFormatToPrefix:(NSString *)prefix {
    switch (self.format) {
        case InventaryIconShowingEmpty:
            return [prefix stringByAppendingString:@"empty_"];
        case InventaryIconShowingFull:
            return [prefix stringByAppendingString:@"full_"];
        default:
            return nil;
    }
}


- (NSString *)addIconNameToPrefix:(NSString *)prefix {
    switch (self.type) {
        case SettingsBarIconTypeLanguage:
            return @"top_bar_language";
        case SettingsBarIconTypePlayAgain:
            return @"top_bar_play_again";
        case SettingsBarIconTypeAboutProject:
            return @"top_bar_about";
        case SettingsBarIconTypeContributors:
            return @"top_bar_contributors";
        case SettingsBarIconTypeRateUs:
            return @"top_bar_rate_us";
        case SettingsBarIconTypeSound:
            return @"top_bar_sound";
        case SettingsBarIconTypeBookAudio:
            return @"book_top_audio";
        case SettingsBarIconTypeBookBookmark:
            return @"book_top_bookmarks";
        case SettingsBarIconTypeBookContent:
            return @"book_top_content";
        case SettingsBarIconTypeBookFontSize:
            return @"book_top_font";
        case SettingsBarIconTypeIslandMap:
            return [prefix stringByAppendingString:@"island_map"];
        case SettingsBarIconTypeMagicWand:
            return [prefix stringByAppendingString:@"magic_wand"];
        case SettingsBarIconTypeMagicBook:
            return [prefix stringByAppendingString:@"book"];
        case SettingsBarIconTypeMedal:
            return [prefix stringByAppendingString:@"medal"];
        case SettingsBarIconTypeBottleOfMagic:
            return [prefix stringByAppendingString:@"bottle"];
        case SettingsBarIconTypeMagicBall:
            return [prefix stringByAppendingString:@"ball_of_magic"];
        case SettingsBarIconTypeExtinguisher:
            return [prefix stringByAppendingString:@"extinguisher"];
        case SettingsBarIconTypeDandelion:
            return [prefix stringByAppendingString:@"dandelion"];
        case SettingsBarIconTypeSword:
            return [prefix stringByAppendingString:@"sword"];
        case SettingsBarIconTypeWrench:
            return [prefix stringByAppendingString:@"wrench"];
        case SettingsBarIconTypeSnail:
            return [prefix stringByAppendingString:@"snail"];
        default:
            return nil;
    }
    
}


- (IBAction)selectIcon:(id)sender {
    [self.delegate settingBar:self didPressIconWithType:self.type];
}

@end
