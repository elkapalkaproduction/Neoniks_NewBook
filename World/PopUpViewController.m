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

@import QuartzCore;

@interface PopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UIImageView *topBanner;
@property (weak, nonatomic) id<PopUpDelegate> delegate;
@property (assign, nonatomic) PopUpType type;
@property (strong, nonatomic) MyScene *scene;

@end

@implementation PopUpViewController

+ (instancetype)instantiateWithType:(PopUpType)type delegate:(id<PopUpDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PopUpViewController *popUpViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    
    popUpViewController.delegate = delegate;
    popUpViewController.type = type;
    
    return popUpViewController;
}


- (MyScene *)sceneWithFrame:(CGRect)frame node:(SKNode<CustomNodeProtocol> *)node {
    MyScene *scene = [MyScene sceneWithSize:frame.size];
    scene.self.scene.node =node;
    scene.backgroundColor = [UIColor clearColor];
    
    return scene;
}


- (SKView *)skViewWithSize:(CGRect)frame node:(SKNode<CustomNodeProtocol> *)node {
    SKView *skView = [[SKView alloc] initWithFrame:frame];
    skView.allowsTransparency = YES;
    self.scene = [self sceneWithFrame:frame node:node];
    [skView presentScene:self.scene];
    
    return skView;
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
    NSString *text = [NSString stringWithFormat:@"island_popup_description_%ld", self.type];
    NSString *localizedText = NSLocalizedString(text, nil);
    NSString *bannerImageName = [NSString stringWithFormat:@"pop_up_banner_%ld", self.type];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:localizedText];
    [attributedString addAttribute:NSKernAttributeName value:@(1.4) range:NSMakeRange(0, [localizedText length])];
    self.label.attributedText = attributedString;
    self.topBanner.image = [UIImage imageNamed:NSLocalizedString(bannerImageName, nil)];
    CGRect frame = self.contentImage.bounds;
    SKView *skView = [self skViewWithSize:frame node:nil];
    
    [self.contentImage addSubview:skView];

    [self setupContentImage];
}


- (IBAction)close:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [weakSelf.delegate didClosePopUp];
    }];

}


- (void)setupContentImage {
    CGSize size = self.contentImage.bounds.size;
    self.contentImage.image = nil;
    self.contentImage.userInteractionEnabled = YES;
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
