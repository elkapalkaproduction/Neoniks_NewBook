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

@interface IslandViewController () <UIScrollViewDelegate, IslandViewModelDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *islandImageView;
@property (strong, nonatomic) IslandViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *leftBarView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UIView *currentToFindView;
@property (weak, nonatomic) IBOutlet UIImageView *currentToFindImage;
@property (strong, nonatomic) NSLayoutConstraint *currentToFindViewConstraint;

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
    IslandToFind maxSolved = [self.viewModel currentNeedToFind];
    self.currentToFindImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"puzzle_cake_%ld", maxSolved]];
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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addIslandImageViewToScrollView];
    [self addOneTapGesture];
    self.mainScrollView.delegate = self;
    [self leftBarSetup];
}


- (void)viewDidLayoutSubviews {
    [self setupScales];
    [super viewDidLayoutSubviews];
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
    [controller addOnParentView:self];
}

- (IBAction)reset {
    [self.viewModel resetAnswers];
}

@end
