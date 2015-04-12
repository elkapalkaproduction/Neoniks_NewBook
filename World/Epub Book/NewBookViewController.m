//
//  NewBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NewBookViewController.h"
#import "NNKEpubView.h"
#import "DejalActivityView.h"
#import "ChaptersViewController.h"
#import "CustomizationViewController.h"
#import <WYPopoverController.h>
#import "SettingsBarIconViewController.h"

@interface NewBookViewController () <NNKEpubViewDelegate, ChaptersListDelegate, CustomizationDelegate, UIPopoverPresentationControllerDelegate, SettingsBarIconDelegate>

@property (weak, nonatomic) IBOutlet NNKEpubView *epubView;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) UIPopoverPresentationController *popover;
//@property (strong, nonatomic) WYPopoverController *popover;
@property (assign, nonatomic) BOOL beforePaginationHiddingState;
@property (weak, nonatomic) IBOutlet UILabel *bookNameFooter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *topContentSuperview;
@property (weak, nonatomic) IBOutlet UIView *topAudioSuperview;
@property (weak, nonatomic) IBOutlet UIView *topBookmarksSuperview;
@property (weak, nonatomic) IBOutlet UIView *topFontSuperview;

@end

@implementation NewBookViewController

+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Book" bundle:[NSBundle mainBundle]];
    NewBookViewController *newBook = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    
    return newBook;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *epubFilepath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"book_name", nil) ofType:nil];
    self.epubView.delegate = self;
    [self.epubView loadEpub:epubFilepath];
    self.bookNameFooter.text = NSLocalizedString(@"book_name_footer", nil);
    self.bookNameFooter.font = [UIFont baseFontOfSize:10];
    self.label.font = [UIFont baseFontOfSize:10];
    UIImage *thumbnail = [UIImage imageNamed:@"book-slider-thumbnail"];
    [self.slider setThumbImage:thumbnail forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbnail forState:UIControlStateHighlighted];
    [self.slider setThumbImage:thumbnail forState:UIControlStateSelected];
    [self createTabBar];
    // Do any additional setup after loading the view from its nib.
}


- (void)createTopBarItemWithType:(SettingsBarIconType)type onView:(UIView *)view {
    SettingsBarIconViewController *contentIcon = [SettingsBarIconViewController instantiateWithFrame:view.bounds
                                                                                                type:type
                                                                                            delegate:self];
    [self addChildViewController:contentIcon withSuperview:view];
}


- (void)createTabBar {
    [self createTopBarItemWithType:SettingsBarIconTypeBookAudio onView:self.topAudioSuperview];
    [self createTopBarItemWithType:SettingsBarIconTypeBookBookmark onView:self.topBookmarksSuperview];
    [self createTopBarItemWithType:SettingsBarIconTypeBookContent onView:self.topContentSuperview];
    [self createTopBarItemWithType:SettingsBarIconTypeBookFontSize onView:self.topFontSuperview];
}


- (void)showOrHideMenu {
    self.topBar.hidden = !self.topBar.hidden;
    self.bottomView.hidden = self.topBar.hidden;
}


- (void)paginationDidStart {
    self.beforePaginationHiddingState = self.topBar.hidden;
    self.topBar.hidden = self.bottomView.hidden = YES;
    self.epubView.hidden = YES;
    [DejalActivityView activityViewForView:self.view];
}


- (void)paginationDidFinish {
    self.topBar.hidden = self.bottomView.hidden = self.beforePaginationHiddingState;
    self.epubView.hidden = NO;
    [DejalActivityView removeView];
}


- (void)pageDidChange {
    self.label.text = [NSString stringWithFormat:@"%lu %@ %lu",
                       (unsigned long)self.epubView.currentPageNumber,
                       NSLocalizedString(@"page_attribute", nil),
                       (unsigned long)self.epubView.totalPagesCount];
    self.slider.value = (float)self.epubView.currentPageNumber / (float)self.epubView.totalPagesCount;
}


- (void)didSelectChapter:(NNKChapter *)chapter {
    [self.epubView loadSpine:chapter.chapterIndex atPageIndex:0];
//    [self.popover dismissPopoverAnimated:YES];
}


- (void)didChangeFontToFontWithName:(NSString *)fontName {
    self.epubView.fontName = fontName;
//    [self.popover dismissPopoverAnimated:YES];
}


- (void)didChangeBackgroundColorToColor:(NSString *)color {
    if ([color isEqualToString:@"white"]) {
        self.label.textColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor whiteColor];
    } else if ([color isEqualToString:@"black"]) {
        self.label.textColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.label.textColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor colorWithHexString:color];
    }
    [self.epubView changeColorToColor:color];
//    [self.popover dismissPopoverAnimated:YES];
}


- (IBAction)finishChangingValue:(id)sender {
    self.epubView.currentPageNumber = self.slider.value * self.epubView.totalPagesCount;
}


- (IBAction)valueChanged:(id)sender {
    NSUInteger currentPage = self.slider.value * self.epubView.totalPagesCount;
    self.label.text = [NSString stringWithFormat:@"%lu %@ %lu",
                       (unsigned long)currentPage,
                       NSLocalizedString(@"page_attribute", nil),
                       (unsigned long)self.epubView.totalPagesCount];
}


- (IBAction)decrease:(id)sender {
    [self.epubView decreaseTextSize];
}


- (IBAction)increase:(id)sender {
    [self.epubView increaseTextSize];
}


- (IBAction)chapters:(UIButton *)sender {
    ChaptersViewController *viewController = [ChaptersViewController instantiateWithChapterList:self.epubView.chapters
                                                                                       delegate:self];
    self.popover = [[UIPopoverPresentationController alloc] initWithPresentedViewController:viewController
                                                                   presentingViewController:self];
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    CGRect rect = sender.frame;
    rect.origin.y += sender.superview.frame.origin.y;
    rect.origin.x += sender.superview.frame.origin.x;
    [self presentViewController:viewController animated:YES completion:nil];
//    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (IBAction)customization:(UIButton *)sender {
    CustomizationViewController *viewController = [CustomizationViewController instantiateWithDelegate:self];
    self.popover = [[UIPopoverPresentationController alloc] initWithPresentedViewController:viewController
                                                                   presentingViewController:self];
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    CGRect rect = sender.frame;
    rect.origin.y += sender.superview.frame.origin.y;
    rect.origin.x += sender.superview.frame.origin.x;
    [self presentViewController:viewController animated:YES completion:nil];
    UIPopoverPresentationController *presentationController =
    [viewController popoverPresentationController];
    presentationController.delegate = self;
//    presentationController.presentationStyle = UIModalPresentationPopover;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentationController.sourceView = self.view;
    presentationController.sourceRect = rect;
//    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationPopover;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self adjustViewsForOrientation];
    }
}


- (NSLayoutAttribute)attributeForHardcoverImage {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return NSLayoutAttributeLeading;
        default:
            return NSLayoutAttributeCenterX;
            break;
    }

}


- (void)adjustViewsForOrientation {
    [self.view removeConstraint:self.leadingConstraint];
    self.leadingConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundImage
                                                          attribute:[self attributeForHardcoverImage]
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0];
    [self.view addConstraint:self.leadingConstraint];
}


- (void)settingBar:(SettingsBarIconViewController *)settings didPressIconWithType:(SettingsBarIconType)type {
    
}

@end

@interface UIPopoverController (iPhone)
+ (BOOL)_popoversDisabled;
@end

// UIPopoverController+iPhone.m file
@implementation UIPopoverController (iPhone)

+ (BOOL)_popoversDisabled {
    return NO;
}

@end