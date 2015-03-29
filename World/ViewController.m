//
//  ViewController.m
//  World
//
//  Created by Andrei Vidrasco on 1/25/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteTableView.h"
#import "TopBarIconViewController.h"
#import "ShadowPlayOpenedHandler.h"
#import "MagicSchoolAnswersHandler.h"
#import "IslandViewModel.h"

@interface ViewController () <InfiniteTableViewDatasource, TopBarIconDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rightTopBarButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTopBarButton;
@property (weak, nonatomic) IBOutlet InfiniteTableView *infiniteTableView;
@property (strong, nonatomic) InfiniteTableView *scrollView;
@end

@implementation ViewController

- (CGFloat)columnWidthInInfiniteTableView:(InfiniteTableView *)tableView {
    return tableView.superview.frame.size.height;
}


- (CGFloat)columnHeightInInfiniteTableView:(InfiniteTableView *)tableView {
    return tableView.superview.frame.size.height;
}


- (CGFloat)columnGapInInfiniteTableView:(InfiniteTableView *)tableView {
    return tableView.superview.frame.size.width / 6.f - tableView.superview.frame.size.height - 2.f;
}


- (CGFloat)numberOfColumnsInInfiniteTableView:(InfiniteTableView *)tableView {
    return 6;
}


- (UIView *)infiniteTableView:(InfiniteTableView *)tableView viewForIndex:(NSInteger)index widthRect:(CGRect)rect {
    TopBarIconViewController *viewController = [TopBarIconViewController instantiateWithFrame:rect type:index + 1 delegate:self];
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];

    return viewController.view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftTopBarButton.hidden = self.rightTopBarButton.hidden = YES;
}


- (void)click:(UIButton *)sender {
    [self pressIconWithType:sender.tag];
}


- (void)pressIconWithType:(TopBarIconType)type {
    switch (type) {
        case TopBarIconTypeUnknown:
            break;
        case TopBarIconTypeLanguage:
            [NSBundle setLanguage:NSLocalizedString(@"opposite_language", nil)];
            [self.infiniteTableView reloadData];
            break;
        case TopBarIconTypePlayAgain:
            [[ShadowPlayOpenedHandler sharedHandler] resetOpenedCharacter];
            [[MagicSchoolAnswersHandler sharedHandler] deleteAllAnswers];
            [IslandViewModel deleteAnswers];
            break;
        case TopBarIconTypeAboutProject:
            break;
        case TopBarIconTypeContributors:
            break;
        case TopBarIconTypeRateUs:
            break;
        case TopBarIconTypeSound:
            break;
        default:
            break;
    }
}


- (IBAction)pressLeft:(id)sender {
    [self.infiniteTableView showPreviousView];
}


- (IBAction)pressRight:(id)sender {
    [self.infiniteTableView showNextView];
}

@end
