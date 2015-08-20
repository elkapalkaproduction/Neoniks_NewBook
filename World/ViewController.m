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
#import "InventaryContentHandler.h"
#import "MyScene.h"
#import "DragableButton.h"
#import "NNKSkeletNode.h"
#import "NNKGoblinNode.h"
#import "NNKSheepNode.h"
#import "TextBarViewController.h"

@interface ViewController () <InfiniteTableViewDatasource, MainScreenViewModelDelegate, UIScrollViewDelegate, DragableButtonDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopConstraint;
@property (weak, nonatomic) IBOutlet InfiniteTableView *infiniteTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) MainScreenViewModel *viewModel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarNavigationsButtons;
@property (weak, nonatomic) IBOutlet UIButton *snailImage;
@property (weak, nonatomic) IBOutlet UIButton *dandelionImage;
@property (strong, nonatomic) DragableButton *dragableObject;
@property (weak, nonatomic) IBOutlet SKView *skeletSKView;
@property (strong, nonatomic) MyScene *skeletScene;
@property (strong, nonatomic) NNKSkeletNode *skeletNode;
@property (weak, nonatomic) IBOutlet SKView *goblinSKView;
@property (strong, nonatomic) MyScene *goblinScene;
@property (strong, nonatomic) NNKGoblinNode *goblinNode;
@property (weak, nonatomic) IBOutlet SKView *sheepSKView;
@property (strong, nonatomic) MyScene *sheepScene;
@property (strong, nonatomic) NNKSheepNode *sheepNode;
@property (weak, nonatomic) IBOutlet UIView *dragonView;
@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;

@end

@implementation ViewController

- (void)prepareScenes {
    self.skeletSKView.allowsTransparency = YES;
    self.skeletScene.node = self.skeletNode;
    self.goblinSKView.allowsTransparency = YES;
    self.goblinScene.node = self.goblinNode;
    self.sheepSKView.allowsTransparency = YES;
    self.sheepScene.node = self.sheepNode;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    [self prepareScenes];
    self.textBarBottomConstraint.constant = -1000;
}


- (TextBarViewController *)textBar {
    if (!_textBar) {
        _textBar = [TextBarViewController instantiate];
        [self.textBarSuperView addSubview:_textBar];
    }
    
    return _textBar;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textBar stopStound];
}


- (void)viewDidLayoutSubviews {
    self.textBar.frame = self.textBarSuperView.bounds;
    [super viewDidLayoutSubviews];
}


- (BOOL)isOpenIcon:(InventaryBarIconType)icon {
    InventaryContentHandler *handler = [InventaryContentHandler sharedHandler];
    InventaryIconShowing iconShowing = [handler formatForItemType:icon];
    
    return iconShowing != InventaryIconShowingEmpty;
}


- (NNKSkeletNode *)skeletNode {
    if (!_skeletNode) {
        BOOL swordIsOpen = [self isOpenIcon:InventaryBarIconTypeSword];
        _skeletNode = [[NNKSkeletNode alloc] initWithSize:self.skeletSKView.bounds.size
                                      showLastFrameOnLoad:swordIsOpen];
        _skeletNode.disableAnimation = swordIsOpen;
        _skeletNode.completionBlock = ^void(NNKSkeletNode *node) {
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeSword withFormat:InventaryIconShowingFull];
            node.disableAnimation = YES;
        };
    }
    
    return _skeletNode;
}


- (MyScene *)skeletScene {
    if (!_skeletScene) {
        _skeletScene = [self sceneFromSkView:self.skeletSKView];
    }
    
    return _skeletScene;
}


- (MyScene *)goblinScene {
    if (!_goblinScene) {
        _goblinScene = [self sceneFromSkView:self.goblinSKView];
    }
    
    return _goblinScene;
}


- (NNKGoblinNode *)goblinNode {
    if (!_goblinNode) {
        BOOL isOpenWrench = [self isOpenIcon:InventaryBarIconTypeWrench];
        _goblinNode = [[NNKGoblinNode alloc] initWithSize:self.goblinSKView.bounds.size
                                         shouldHideWrench:isOpenWrench];
        __weak typeof(self) weakSelf = self;
        _goblinNode.completionBlock = ^void(NNKGoblinNode *node) {
            if (![weakSelf isOpenIcon:InventaryBarIconTypeWrench]) {
                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_goblin"]
                                                     text:@"text_panel_goblin_initial"
                                                 isObject:NO];
            }
        };
    }
    
    return _goblinNode;
}


- (NNKSheepNode *)sheepNode {
    if (!_sheepNode) {
        _sheepNode = [[NNKSheepNode alloc] initWithSize:self.sheepSKView.bounds.size];
        //        __weak typeof(self) weakSelf = self;
        _sheepNode.completionBlock = ^void(NNKSheepNode *node) {
            //            if (![weakSelf isOpenIcon:InventaryBarIconTypeWrench]) {
            //                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_goblin"]
            //                                                     text:@"text_panel_goblin_initial"
            //                                                 isObject:NO];
            //            }
        };
    }
    
    return _sheepNode;
}


- (MyScene *)sheepScene {
    if (!_sheepScene) {
        _sheepScene = [self sceneFromSkView:self.sheepSKView];
    }
    
    return _sheepScene;
}


- (void)updateInterface {
    if ([self isOpenIcon:InventaryBarIconTypeDandelion]) {
        [self.dandelionImage removeFromSuperview];
    }
    if ([self isOpenIcon:InventaryBarIconTypeSnail]) {
        [self.snailImage removeFromSuperview];
    }
}


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


- (void)closeTopAndTextBarWithCompletion:(void(^)())completion {
    self.topBarTopConstraint.constant = 0;
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
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
        [self closeTopAndTextBarWithCompletion:^{
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
    [self.dragableObject removeFromSuperview];
    [self closeTopAndTextBarWithCompletion:nil];
}


- (void)setTopbarNavigationsButtonsHiddenState:(BOOL)hidden {
    for (UIButton *button in self.topBarNavigationsButtons) {
        button.hidden = hidden;
    }
}


- (void)didChangeLanguageInMainScreenViewModel:(MainScreenViewModel *)viewModel {
    [self.infiniteTableView reloadData];
}


- (void)mainScreenViewModel:(MainScreenViewModel *)viewModel
didWantToOpenViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)didSwipeIconWithType:(SettingsBarIconType)type
                      inRect:(CGRect)rect
               relatedToView:(UIView *)view
                       image:(UIImage *)image {
    [self.dragableObject removeFromSuperview];
    CGRect startPosition = [self.view convertRect:rect fromView:view];
    startPosition.origin.x += 5;
    startPosition.origin.y += 5;
    DragableButton *button = [[DragableButton alloc] initWithFrame:startPosition];
    switch (type) {
        case SettingsBarIconTypeSword:
            break;
        case SettingsBarIconTypeWrench:
            break;
        case SettingsBarIconTypeSnail:
            button.correctRect = self.goblinSKView.frame;
            button.fullType = InventaryBarIconTypeWrench;
            button.hiddenType = InventaryBarIconTypeSnail;
            break;
        case SettingsBarIconTypeDandelion:
            button.correctRect = self.sheepSKView.frame;
            button.fullType = InventaryBarIconTypeMagicBall;
            button.hiddenType = InventaryBarIconTypeDandelion;
            break;
        case SettingsBarIconTypeExtinguisher:
            button.correctRect = self.dragonView.frame;
            button.fullType = InventaryBarIconTypeMagicBook;
            button.hiddenType = InventaryBarIconTypeExtinguisher;
            break;
        default:
            break;
    }
    button.delegate = self;
    [button setImage:image forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.dragableObject = button;
}


- (IBAction)openBook {
    NewBookViewController *newBook = [NewBookViewController instantiate];
    [self presentViewController:newBook animated:YES completion:nil];
}


- (void)dandelionPress {
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeDandelion
                                                   withFormat:InventaryIconShowingFull];
    [self.dandelionImage removeFromSuperview];
}


- (void)snailPress {
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeSnail
                                                   withFormat:InventaryIconShowingFull];
    [self.snailImage removeFromSuperview];
}


- (BOOL)correctTargetPositionForButton:(DragableButton *)button {
    BOOL correctPosition = CGRectIntersectsRect([self.scrollView convertRect:button.frame fromView:self.view], button.correctRect);
    if (!correctPosition) {
        [button removeFromSuperview];
    }
    
    return correctPosition;
}


- (void)putButtonOnRightPosition:(DragableButton *)button {
    if (button.fullType == InventaryBarIconTypeUnknown) return;
    [[InventaryContentHandler sharedHandler] markItemWithType:button.fullType
                                                   withFormat:InventaryIconShowingFull];
    [[InventaryContentHandler sharedHandler] markItemWithType:button.hiddenType
                                                   withFormat:InventaryIconShowingHidden];
    [button removeFromSuperview];
    switch (button.fullType) {
        case InventaryBarIconTypeWrench:
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_goblin"]
                                             text:@"text_panel_goblin_final"
                                         isObject:NO];
            [self.goblinNode removeWrench];
            break;
        case InventaryBarIconTypeMagicBook:
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_dragon"]
                                             text:@"text_panel_dragon_final"
                                         isObject:NO];
        default:
            break;
    }
}


- (void)didStartDragButton:(DragableButton *)button {
    [self closeTopAndTextBarWithCompletion:nil];
}


- (IBAction)showDragonText:(id)sender {
    if ([self isOpenIcon:InventaryBarIconTypeMagicBook]) return;
    [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_dragon"]
                                     text:@"text_panel_dragon_initial"
                                 isObject:NO];
    
}


- (void)didRequireToOpenTextBarWithIcon:(UIImage *)image
                                   text:(NSString *)text
                               isObject:(BOOL)isObject {
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.textBar.image = image;
        self.textBar.text = text;
        self.textBar.object = isObject;
        self.textBarBottomConstraint.constant = [self textBarOpenPosition];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}


- (MyScene *)sceneFromSkView:(SKView *)view {
    MyScene *scene = [MyScene sceneWithSize:view.frame.size];
    scene.backgroundColor = [UIColor clearColor];
    
    [view presentScene:scene];
    
    return scene;
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 10;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}

@end
