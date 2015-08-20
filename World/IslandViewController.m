//
//  IslandViewController.m
//  World
//
//  Created by Andrei Vidrasco on 3/7/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "IslandViewController.h"
#import "IslandViewModel.h"
#import "PopUpViewController.h"
#import "InventaryContentHandler.h"
#import "TextBarViewController.h"
#import "AlertViewController.h"

@interface IslandViewController () <UIScrollViewDelegate, IslandViewModelDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *islandImageView;
@property (strong, nonatomic) IslandViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *leftBarView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UIView *currentToFindView;
@property (weak, nonatomic) IBOutlet UIImageView *currentToFindImage;
@property (strong, nonatomic) NSLayoutConstraint *currentToFindViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *prizeView;
@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;

@end

@implementation IslandViewController

- (void)addOneTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnImageViewWith:)];
    doubleTapRecognizer.numberOfTapsRequired = 1;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mainScrollView addGestureRecognizer:doubleTapRecognizer];
}


- (void)addIslandImageViewToScrollView {
    self.islandImageView = [[UIImageView alloc] init];
    UIImage *turnImage = [UIImage imageNamed:@"Island_Main"];
    [self.islandImageView setImage:turnImage];
    [self.mainScrollView addSubview:self.islandImageView];
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.islandImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.islandImageView.frame = CGRectMake(0, 0, turnImage.size.width, turnImage.size.height);
    self.mainScrollView.contentSize = turnImage.size;
    self.mainScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IslandScrollViewBackgroundGradient"]];
}


- (void)leftBarSetup {
    if (self.currentToFindViewConstraint) {
        [self.currentToFindView.superview removeConstraint:self.currentToFindViewConstraint];
    }
    IslandToFind maxSolved = [self.viewModel maxSolved];
    self.currentToFindImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"puzzle_cake_%ld", (long)[self.viewModel currentNeedToFind]]];
    for (NSInteger index = 0; index < IslandToFindSolvedAll; index++) {
        [self.stars[index] setHidden:index >= maxSolved];
    }
    
    self.currentToFindView.hidden = maxSolved == IslandToFindSolvedAll;
    if (!self.currentToFindView.hidden) {
        self.currentToFindViewConstraint = [NSLayoutConstraint constraintWithItem:self.currentToFindView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.stars[maxSolved]
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
        [self.currentToFindView.superview addConstraint:self.currentToFindViewConstraint];
    }
    if ([self shouldShowPrize]) {
        [self showPrize];
    } else {
        self.prizeView.hidden = YES;

    }
}


- (BOOL)shouldShowPrize {
    InventaryIconShowing format = [[InventaryContentHandler sharedHandler] formatForItemType:InventaryBarIconTypeIslandMap];
    
    return self.currentToFindView.hidden && format == InventaryIconShowingEmpty;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addIslandImageViewToScrollView];
    [self addOneTapGesture];
    self.mainScrollView.delegate = self;
    [self leftBarSetup];
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewDidLayoutSubviews {
    [self setupScales];
    self.textBar.frame = self.textBarSuperView.bounds;
    [super viewDidLayoutSubviews];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.textBar stopStound];
}


- (IslandViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[IslandViewModel alloc] initWithDelegate:self];
    }
    
    return _viewModel;
}


#pragma mark -
#pragma mark - Scroll View scales setup and center

- (void)setupScales {
    CGSize scrollViewFrame = self.mainScrollView.frame.size;
    CGSize scrollViewSize = self.islandImageView.image.size;
    CGFloat scaleWidth = scrollViewFrame.width / scrollViewSize.width;
    CGFloat scaleHeight = scrollViewFrame.height / scrollViewSize.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    
    self.mainScrollView.minimumZoomScale = minScale;
    self.mainScrollView.maximumZoomScale = 1.5f;
    self.mainScrollView.zoomScale = minScale;
    self.mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.leftBarView.frame.size.width - 10);
    [self centerScrollViewContents];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.mainScrollView.bounds.size;
    CGRect contentsFrame = self.islandImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.islandImageView.frame = contentsFrame;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.islandImageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}


- (void)didTapOnImageViewWith:(UITapGestureRecognizer *)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.islandImageView];
    [self.viewModel didTapOnPoint:pointInView];
}


- (void)updateInterface {
    [self leftBarSetup];
}


- (void)openPopUpViewController:(PopUpViewController *)controller {
    [self.textBar stopStound];
    [controller addOnParentView:self];
}


- (void)showPrize {
    for (UIImageView *imageView in self.stars) {
        imageView.hidden = YES;
    }
    self.prizeView.hidden = NO;
}


- (IBAction)getPrize:(id)sender {
    for (UIImageView *imageView in self.stars) {
        imageView.hidden = NO;
    }
    self.prizeView.hidden = YES;
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeIslandMap
                                                   withFormat:InventaryIconShowingFull];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self shouldShowWelcomeAlert]) {
        [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                             text:@"text_panel_island_initial"
                         isObject:NO];
        [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
    }
}


- (TextBarViewController *)textBar {
    if (!_textBar) {
        _textBar = [TextBarViewController instantiate];
        [self.textBarSuperView addSubview:_textBar];
    }
    
    return _textBar;
}


- (void)openTextBarWithIcon:(UIImage *)image
                       text:(NSString *)text
                   isObject:(BOOL)isObject {
    [self closeTextBarWithCompletionBlock:^{
        self.textBar.image = image;
        self.textBar.text = text;
        self.textBar.object = isObject;
        self.textBarBottomConstraint.constant = [self textBarOpenPosition];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}


- (void)closeTextBarWithCompletionBlock:(void (^)(void))completion {
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}


- (BOOL)shouldShowWelcomeAlert {
    return !self.currentToFindView.hidden;
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 10;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (IBAction)reset:(id)sender {
    AlertViewController *alert = [AlertViewController initWithTitle:NSLocalizedString(@"alert_start_over", nil)
                                                   firstButtonTitle:NSLocalizedString(@"alert_yes", nil)
                                                  firstButtonAction:^{
                                                      [self.viewModel resetAnswers];
                                                  }
                                                  secondButtonTitle:NSLocalizedString(@"alert_no", nil)
                                                 secondButtonAction:nil];
    [alert showInViewController:self];
}

@end
