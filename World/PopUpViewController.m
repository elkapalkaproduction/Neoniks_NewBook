//
//  PopUpViewController.m
//  World
//
//  Created by Andrei Vidrasco on 3/8/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "PopUpViewController.h"
#import "NNKMuseumNode.h"
#import "NNKFoamCastleNode.h"
#import "NNKLanternHouseNode.h"
#import "NNKBottomlessIslandNode.h"
#import "NNKSchoolNode.h"
#import "NNKCafeNode.h"
#import "NNKLighthouseNode.h"
#import "MyScene.h"
#import "AVAudioPlayer+Creation.h"

@import QuartzCore;

@interface PopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *topBanner;
@property (weak, nonatomic) id<PopUpDelegate> delegate;
@property (assign, nonatomic) PopUpType type;
@property (strong, nonatomic) MyScene *scene;
@property (strong, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation PopUpViewController

+ (instancetype)instantiateWithType:(PopUpType)type delegate:(id<PopUpDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PopUpViewController *popUpViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    
    popUpViewController.delegate = delegate;
    popUpViewController.type = type;
    
    return popUpViewController;
}


- (MyScene *)sceneWithFrame:(CGRect)frame node:(NNKSpriteNode *)node {
    MyScene *scene = [MyScene sceneWithSize:frame.size];
    scene.node = node;
    scene.backgroundColor = [UIColor clearColor];
    
    return scene;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.font = [UIFont baseFontOfSize:16.f];
    UILabel *label = self.label;
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(1.5f, 2.0);
    label.layer.shadowRadius = 0.6f;
    label.layer.shadowOpacity = 0.6f;
    label.layer.masksToBounds = NO;
    label.layer.shouldRasterize = YES;
    NSString *text = [NSString stringWithFormat:@"island_popup_description_%ld", (long)self.type];
    NSString *localizedText = NSLocalizedString(text, nil);
    NSString *bannerImageName = [NSString stringWithFormat:@"pop_up_banner_%ld", (long)self.type];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:localizedText];
    [attributedString addAttribute:NSKernAttributeName value:@(1.4) range:NSMakeRange(0, [localizedText length])];
    self.label.attributedText = attributedString;
    self.topBanner.image = [UIImage imageLocalizableNamed:bannerImageName];
    self.skView.allowsTransparency = YES;

    [self setupContentImage];
}


- (AVAudioPlayer *)player {
    if (!_player) {
        NSString *text = [NSString stringWithFormat:@"island_sound_%ld", (long)self.type];
        NSString *localizedText = NSLocalizedString(text, nil);
        _player = [AVAudioPlayer audioPlayerWithSoundName:localizedText];
    }
    
    return _player;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player play];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scene removeAllChildren];
}


- (MyScene *)scene {
    if (!_scene) {
        _scene = [self sceneWithFrame:self.skView.frame node:nil];
        [self.skView presentScene:_scene];
    }
    
    return _scene;
}


- (IBAction)close:(id)sender {
    [self.scene.node stopAction];
    [self.player stop];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromParent];
        [weakSelf.delegate didClosePopUp];
    }];

}


- (void)setupContentImage {
    CGSize size = self.skView.bounds.size;
    switch (self.type) {
        case PopUpTypeMuseum:
            self.scene.node = [[NNKMuseumNode alloc] initWithSize:size];
            break;
        case PopUpTypeFoamCastle:
            self.scene.node = [[NNKFoamCastleNode alloc] initWithSize:size];
            break;
        case PopUpTypeLanternHouse:
            self.scene.node = [[NNKLanternHouseNode alloc] initWithSize:size];
            break;
        case PopUpTypeBottomlessIsland:
            self.scene.node = [[NNKBottomlessIslandNode alloc] initWithSize:size];
            break;
        case PopUpTypeSchool:
            self.scene.node = [[NNKSchoolNode alloc] initWithSize:size];
            break;
        case PopUpTypeCafe:
            self.scene.node = [[NNKCafeNode alloc] initWithSize:size];
            break;
        case PopUpTypeLighthouse:
            self.scene.node = [[NNKLighthouseNode alloc] initWithSize:size];
            break;
    }
}


- (void)addOnParentView:(UIViewController *)viewController {
    [viewController addChildViewController:self withSuperview:viewController.view];
    self.view.alpha = 0.f;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.f;
    }];
}

@end
