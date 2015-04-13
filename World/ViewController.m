//
//  ViewController.m
//  World
//
//  Created by Andrei Vidrasco on 1/25/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteTableView.h"
#import "SettingsBarIconViewController.h"
#import "ShadowPlayOpenedHandler.h"
#import "MagicSchoolAnswersHandler.h"
#import "IslandViewModel.h"
#import "MainScreenViewModel.h"
#import "NewBookViewController.h"

@interface ViewController () <InfiniteTableViewDatasource, MainScreenViewModelDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopConstraint;
@property (weak, nonatomic) IBOutlet InfiniteTableView *infiniteTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) MainScreenViewModel *viewModel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarNavigationsButtons;

@end

@implementation ViewController

- (MainScreenViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MainScreenViewModel alloc] initWithDelegate:self];
    }
    
    return _viewModel;
}


- (CGFloat)numberOfColumnsInInfiniteTableView:(InfiniteTableView *)tableView {
    NSInteger numberOfItems = self.viewModel.numberOfItems;
    [self setTopbarNavigationsButtonsHiddenState:numberOfItems < 7];
    
    return numberOfItems;
}


- (UIView *)infiniteTableView:(InfiniteTableView *)tableView viewForIndex:(NSInteger)index widthRect:(CGRect)rect {
    return [self.viewModel viewForIndex:index inRect:rect parentViewController:self];
}


- (IBAction)pressLeft:(id)sender {
    [self.infiniteTableView showPreviousView];
}


- (IBAction)pressRight:(id)sender {
    [self.infiniteTableView showNextView];
}


- (BOOL)isShowingTopBar {
    return self.topBarTopConstraint.constant == CGRectGetHeight(self.topBarView.frame);
}


- (void)closeTopBarWithCompletion:(void(^)())completion {
    self.topBarTopConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (completion) completion();
    }];
}


- (void)openTopBar {
    [self.infiniteTableView reloadData];
    self.topBarTopConstraint.constant = CGRectGetHeight(self.topBarView.frame);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)operOrCloseTopBarForType:(MainScreenTopBarViewType)type {
    if ([self isShowingTopBar]) {
        [self closeTopBarWithCompletion:^{
            if (self.viewModel.type != type) {
                self.viewModel.type = type;
                [self openTopBar];
            }
        }];
    } else {
        self.viewModel.type = type;
        [self openTopBar];
    }
}


- (IBAction)showSettings:(id)sender {
    [self operOrCloseTopBarForType:MainScreenTopBarViewTypeSettings];
}


- (IBAction)showInventary:(id)sender {
    [self operOrCloseTopBarForType:MainScreenTopBarViewTypeInventary];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self closeTopBarWithCompletion:nil];
}


- (void)setTopbarNavigationsButtonsHiddenState:(BOOL)hidden {
    for (UIButton *button in self.topBarNavigationsButtons) {
        button.hidden = hidden;
    }
}


- (void)didChangeLanguageInMainScreenViewModel:(MainScreenViewModel *)viewModel {
    [self.infiniteTableView reloadData];
}


- (void)mainScreenViewModel:(MainScreenViewModel *)viewModel didWantToOpenViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}


- (IBAction)openBook {
    NewBookViewController *newBook = [NewBookViewController instantiate];
    [self presentViewController:newBook animated:YES completion:nil];
}

@end
