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
#import "NNKCatNode.h"
#import "NNKDragonNode.h"
#import "NNKNinjaNode.h"
#import "TextBarViewController.h"

@interface ViewController () <InfiniteTableViewDatasource, MainScreenViewModelDelegate, UIScrollViewDelegate, DragableButtonDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopConstraint;
@property (weak, nonatomic) IBOutlet InfiniteTableView *infiniteTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) MainScreenViewModel *viewModel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarNavigationsButtons;
@property (weak, nonatomic) IBOutlet UIButton *snailImage;
@property (weak, nonatomic) IBOutlet UIButton *dandelionImage;
@property (strong, nonatomic) DragableButton *dragableObject;

@property (weak, nonatomic) IBOutlet SKView *catSKView;
@property (strong, nonatomic) MyScene *catScene;
@property (strong, nonatomic) NNKCatNode *catNode;

@property (weak, nonatomic) IBOutlet SKView *skeletSKView;
@property (strong, nonatomic) MyScene *skeletScene;
@property (strong, nonatomic) NNKSkeletNode *skeletNode;

@property (weak, nonatomic) IBOutlet SKView *goblinSKView;
@property (strong, nonatomic) MyScene *goblinScene;
@property (strong, nonatomic) NNKGoblinNode *goblinNode;

@property (weak, nonatomic) IBOutlet SKView *ninjaSKView;
@property (strong, nonatomic) MyScene *ninjaScene;
@property (strong, nonatomic) NNKNinjaNode *ninjaNode;

@property (weak, nonatomic) IBOutlet SKView *sheepSKView;
@property (strong, nonatomic) MyScene *sheepScene;
@property (strong, nonatomic) NNKSheepNode *sheepNode;

@property (weak, nonatomic) IBOutlet SKView *dragonSKView;
@property (strong, nonatomic) MyScene *dragonScene;
@property (strong, nonatomic) NNKDragonNode *dragonNode;

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
    self.dragonSKView.allowsTransparency = YES;
    self.dragonScene.node = self.dragonNode;
    self.ninjaSKView.allowsTransparency = YES;
    self.ninjaScene.node = self.ninjaNode;
    self.catSKView.allowsTransparency = YES;
    self.catScene.node = self.catNode;
    [self.catNode runBackgrounAction];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    self.textBarBottomConstraint.constant = -1000;
    [self prepareScenes];
    [self setupScales];
}


- (void)setupScales {
    self.scrollView.contentSize = self.backgroundImage.image.size;
    CGSize scrollViewFrame = self.scrollView.frame.size;
    CGSize scrollViewSize = self.backgroundImage.image.size;
    CGFloat scaleWidth = scrollViewFrame.width / scrollViewSize.width;
    CGFloat scaleHeight = scrollViewFrame.height / scrollViewSize.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.5f;
    self.scrollView.zoomScale = minScale;
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


- (MyScene *)catScene {
    if (!_catScene) {
        _catScene = [self sceneFromSkView:self.catSKView];
    }
    
    return _catScene;
}


- (NNKCatNode *)catNode {
    if (!_catNode) {
        _catNode = [[NNKCatNode alloc] initWithSize:self.catSKView.bounds.size];
        __weak typeof(self) weakSelf = self;
        _catNode.completionBlock = ^void() {
            if (![weakSelf isOpenIcon:InventaryBarIconTypeMagicBallCat]) {
                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_cat"]
                                                     text:@"text_panel_cat_initial"
                                                 isObject:NO];
            }
        };
    }
    
    return _catNode;
}


- (MyScene *)sheepScene {
    if (!_sheepScene) {
        _sheepScene = [self sceneFromSkView:self.sheepSKView];
    }
    
    return _sheepScene;
}


- (NNKSheepNode *)sheepNode {
    if (!_sheepNode) {
        _sheepNode = [[NNKSheepNode alloc] initWithSize:self.sheepSKView.bounds.size];
        __weak typeof(self) weakSelf = self;
        _sheepNode.completionBlock = ^void(NNKSheepNode *node) {
            if (![weakSelf isOpenIcon:InventaryBarIconTypeMagicBallSheep]) {
                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_sheep"]
                                                     text:@"text_panel_sheep_initial"
                                                 isObject:NO];
            }
        };
    }
    
    return _sheepNode;
}


- (NNKDragonNode *)dragonNode {
    if (!_dragonNode) {
        BOOL isOpenWrench = [self isOpenIcon:InventaryBarIconTypeMagicBook];
        _dragonNode = [[NNKDragonNode alloc] initWithSize:self.dragonSKView.bounds.size
                                           shouldHideBook:isOpenWrench];
        __weak typeof(self) weakSelf = self;
        _dragonNode.completionBlock = ^void(NNKDragonNode *node) {
            if (![weakSelf isOpenIcon:InventaryBarIconTypeMagicBook]) {
                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_dragon"]
                                                     text:@"text_panel_dragon_initial"
                                                 isObject:NO];
            }
        };
    }
    
    return _dragonNode;
}


- (MyScene *)dragonScene {
    if (!_dragonScene) {
        _dragonScene = [self sceneFromSkView:self.dragonSKView];
    }
    
    return _dragonScene;
}


- (NNKNinjaNode *)ninjaNode {
    if (!_ninjaNode) {
        _ninjaNode = [[NNKNinjaNode alloc] initWithSize:self.ninjaSKView.bounds.size];
        __weak typeof(self) weakSelf = self;
        _ninjaNode.completionBlock = ^void() {
            if (![weakSelf isOpenIcon:InventaryBarIconTypeMagicBallNinja]) {
                [weakSelf didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ninja"]
                                                     text:@"text_panel_ninja_initial"
                                                 isObject:NO];
            }
        };
    }
    
    return _ninjaNode;
}


- (MyScene *)ninjaScene {
    if (!_ninjaScene) {
        _ninjaScene = [self sceneFromSkView:self.ninjaSKView];
    }
    
    return _ninjaScene;
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
            button.correctRect = self.ninjaSKView.frame;
            button.fullType = InventaryBarIconTypeMagicBallNinja;
            button.hiddenType = InventaryBarIconTypeSword;
            break;
        case SettingsBarIconTypeWrench:
            button.correctRect = self.catSKView.frame;
            button.fullType = InventaryBarIconTypeMagicBallCat;
            button.hiddenType = InventaryBarIconTypeWrench;
            break;
        case SettingsBarIconTypeSnail:
            button.correctRect = self.goblinSKView.frame;
            button.fullType = InventaryBarIconTypeWrench;
            button.hiddenType = InventaryBarIconTypeSnail;
            break;
        case SettingsBarIconTypeDandelion:
            button.correctRect = self.sheepSKView.frame;
            button.fullType = InventaryBarIconTypeMagicBallSheep;
            button.hiddenType = InventaryBarIconTypeDandelion;
            break;
        case SettingsBarIconTypeExtinguisher:
            button.correctRect = self.dragonSKView.frame;
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
            [self.dragonNode removeBook];
            break;
        case InventaryBarIconTypeMagicBallCat:
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_cat"]
                                             text:@"text_panel_cat_final"
                                         isObject:NO];
        case InventaryBarIconTypeMagicBallNinja:
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ninja"]
                                             text:@"text_panel_ninja_final"
                                         isObject:NO];
            break;
        case InventaryBarIconTypeMagicBallSheep:
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_sheep"]
                                             text:@"text_panel_sheep_final"
                                         isObject:NO];
            break;
        default:
            break;
    }
}


- (void)putMagicBallButtonOnRightPosition:(DragableButton *)button {
    switch (button.hiddenType) {
        case InventaryBarIconTypeWrench:
            break;
        default: {
            break;
        }
    }
}


- (void)didStartDragButton:(DragableButton *)button {
    [self closeTopAndTextBarWithCompletion:nil];
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
