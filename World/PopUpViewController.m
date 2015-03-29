//
//  PopUpViewController.m
//  World
//
//  Created by Andrei Vidrasco on 3/8/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "PopUpViewController.h"

@import QuartzCore;

@interface PopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSString *stringText;
@property (strong, nonatomic) UIImage *mainImage;
@property (strong, nonatomic) UIImage *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UIImageView *topBanner;
@property (weak, nonatomic) id<PopUpDelegate> delegate;
@end

@implementation PopUpViewController

+ (instancetype)instantiateWithMainImage:(UIImage *)mainImage
                             bannerImage:(UIImage *)bannerImage
                                    text:(NSString *)text
                                delegate:(id<PopUpDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PopUpViewController *popUpViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    
    popUpViewController.delegate = delegate;
    popUpViewController.stringText = text;
    popUpViewController.mainImage = mainImage;
    popUpViewController.bannerImage = bannerImage;
    
    return popUpViewController;
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
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.stringText];
    [attributedString addAttribute:NSKernAttributeName value:@(1.4) range:NSMakeRange(0, [self.stringText length])];
    self.label.attributedText = attributedString;
    self.topBanner.image = self.bannerImage;
    self.contentImage.image = self.mainImage;
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


- (void)addOnParentView:(UIViewController *)viewController {
    [self willMoveToParentViewController:viewController];
    [viewController addChildViewController:self];
    [self didMoveToParentViewController:viewController];
    self.view.alpha = 0.f;
    [viewController.view addSubview:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.f;
    }];
}

@end
