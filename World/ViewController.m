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
#import "NNWVideoViewController.h"
#import "TextBarViewController.h"
#import "GameScene.h"
#import "IslandViewController.h"
#import "ShadowPlayViewController.h"
#import "SchoolOfMagicViewController.h"
#import "SideMenu.h"

@interface ViewController () <InfiniteTableViewDatasource, MainScreenViewModelDelegate, GameSceneDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopConstraint;
@property (weak, nonatomic) IBOutlet InfiniteTableView *infiniteTableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) MainScreenViewModel *viewModel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topBarNavigationsButtons;
@property (weak, nonatomic) IBOutlet UIButton *bookIcon;

@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;

@property (nonatomic, strong) GameScene *sampleScene;
@property (nonatomic, strong) UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *leftMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMenuLeadingConstraint;
@property (assign, nonatomic) BOOL isOpenLeftMenu;
@property (strong, nonatomic) SideMenu *inventary;

@end

@implementation ViewController

+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [self updateInterface];
    [self configureSideMenu];
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.sampleScene) return;
    
    self.sampleScene = [[GameScene alloc] initWithSize:self.spriteKitView.frame.size];
    self.sampleScene.gameSceneDelegate = self;
    self.sampleScene.contentView = self.scrollContentView;
    [self presentScene:self.sampleScene];
    [self hideObjectsOnInit];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}


- (void)didPressIslandInGameScene {
    IslandViewController *island = [IslandViewController instantiate];
    [[SoundPlayer sharedPlayer] playClick];
    [self presentViewController:island animated:YES completion:nil];
}


- (void)didPressShadowInGameScene {
    ShadowPlayViewController *shadow = [ShadowPlayViewController instantiate];
    [[SoundPlayer sharedPlayer] playClick];
    [self presentViewController:shadow animated:YES completion:nil];
}


- (void)didPressSchoolInGameScene {
    SchoolOfMagicViewController *school = [SchoolOfMagicViewController instantiate];
    [[SoundPlayer sharedPlayer] playClick];
    [self presentViewController:school animated:YES completion:nil];
}


- (void)didPressPlayerInGameScene {
    NNWVideoViewController *video = [NNWVideoViewController instantiate];
    [[SoundPlayer sharedPlayer] playClick];
    [self presentViewController:video animated:YES completion:nil];
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
    [self.view sendSubviewToBack:self.scrollView];
}


- (BOOL)isOpenIcon:(InventaryBarIconType)icon {
    return [InventaryContentHandler.sharedHandler formatForItemType:icon] != InventaryIconShowingEmpty;
}


- (BOOL)isGetableIcon:(InventaryBarIconType)icon {
    return [InventaryContentHandler.sharedHandler formatForItemType:icon] == InventaryIconShowingGet;
    
}


- (void)reset {
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.textBar stop];
    [self hideObjectsOnInit];
}


- (void)hideObjectsOnInit {
    if ([self isOpenIcon:InventaryBarIconTypeSword]) {
        [self.sampleScene hideSword];
    } else {
        [self.sampleScene showSword];
    }
    if ([self isOpenIcon:InventaryBarIconTypeWrench]) {
        [self.sampleScene hideWrench];
    } else {
        [self.sampleScene showWrench];
    }
    if ([self isOpenIcon:InventaryBarIconTypeMagicBook]) {
        [self.sampleScene hideBook];
    } else {
        [self.sampleScene showBook];
    }
    if ([self isOpenIcon:InventaryBarIconTypeExtinguisher]) {
        [self.sampleScene hideExtinguisher];
    } else {
        [self.sampleScene showExtinguisher];
    }
    if ([self isOpenIcon:InventaryBarIconTypeDandelion]) {
        [self.sampleScene hideDandelion];
    } else {
        [self.sampleScene showDandelion];
    }
    if ([self isOpenIcon:InventaryBarIconTypeSnail]) {
        [self.sampleScene hideSnail];
    } else {
        [self.sampleScene showSnail];
    }
    
    if ([self isGetableIcon:InventaryBarIconTypeMagicBallNinja]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallNinja];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeMagicBallNinja];
    }
    if ([self isGetableIcon:InventaryBarIconTypeMagicBallSheep]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallSheep];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeMagicBallSheep];
    }
    if ([self isGetableIcon:InventaryBarIconTypeMagicBook]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBook];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeMagicBook];
    }
    if ([self isGetableIcon:InventaryBarIconTypeWrench]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeWrench];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeWrench];
    }
    if ([self isGetableIcon:InventaryBarIconTypeMagicBallCat]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallCat];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeMagicBallCat];
    }
    if ([self isGetableIcon:InventaryBarIconTypeBottleOfMagic]) {
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeBottleOfMagic];
    } else {
        [self.sampleScene hideObjectOfType:GetableObjectTypeBottleOfMagic];
    }
}


- (void)didPressGetableObjectWithType:(GetableObjectType)type {
    switch (type) {
        case GetableObjectTypeBottleOfMagic:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeBottleOfMagic
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeBottleOfMagic inView:self.inventary.bottleOfMagic];
            break;
        case GetableObjectTypeMagicBook:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicBook
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeMagicBook inView:self.inventary.book];
            break;
        case GetableObjectTypeWrench:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeWrench
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeWrench inView:self.inventary.wrench];
            break;
        case GetableObjectTypeMagicBallCat:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicBallCat
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeMagicBallCat inView:self.inventary.magicBalls];
            break;
        case GetableObjectTypeMagicBallNinja:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicBallNinja
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeMagicBallNinja inView:self.inventary.magicBalls];
            break;
        case GetableObjectTypeMagicBallSheep:
            [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicBallSheep
                                                           withFormat:InventaryIconShowingFull];
            [self addViewOfType:InventaryBarIconTypeMagicBallSheep inView:self.inventary.magicBalls];
            break;
        default: break;
    }
    [[SoundPlayer sharedPlayer] playDsyn];
    [self.sampleScene hideObjectOfType:type];
}


- (void)didPressSkeletInGameScene {
    BOOL swordIsOpen = [self isOpenIcon:InventaryBarIconTypeSword];
    if (!swordIsOpen) {
        [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeSword
                                                       withFormat:InventaryIconShowingFull];
        [self addViewOfType:InventaryBarIconTypeSword inView:self.inventary.sword];
    }
}


- (void)didPressGoblinInGameScene {
    BOOL isOpenWrench = [self isOpenIcon:InventaryBarIconTypeWrench];
    if (!isOpenWrench) {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_goblin"]
                                         text:@"text_panel_goblin_initial"
                                     isObject:NO];
    }
}


- (void)didPressCatInGameScene {
    if (![self isOpenIcon:InventaryBarIconTypeMagicBallCat]) {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_cat"]
                                         text:@"text_panel_cat_initial"
                                     isObject:NO];
    }
    
}


- (void)didPressSheepInGameScene {
    if (![self isOpenIcon:InventaryBarIconTypeMagicBallSheep]) {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_sheep"]
                                         text:@"text_panel_sheep_initial"
                                     isObject:NO];
    }
}


- (void)didPressDragonInGameScene {
    if (![self isOpenIcon:InventaryBarIconTypeMagicBook]) {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_dragon"]
                                         text:@"text_panel_dragon_initial"
                                     isObject:NO];
    }
}


- (void)didPressNinjaInGameScene {
    if (![self isOpenIcon:InventaryBarIconTypeMagicBallNinja]) {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ninja"]
                                         text:@"text_panel_ninja_initial"
                                     isObject:NO];
    }
}


- (void)didPressExtinguisherInGameScene {
    BOOL isOpen = [self isOpenIcon:InventaryBarIconTypeExtinguisher];
    if (!isOpen) {
        [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeExtinguisher
                                                       withFormat:InventaryIconShowingFull];
        [self addViewOfType:InventaryBarIconTypeExtinguisher inView:self.inventary.extinguisher];
        [self.sampleScene hideExtinguisher];
        [[SoundPlayer sharedPlayer] playDsyn];
    }
}


- (void)didPressDandelionInGameScene {
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeDandelion
                                                   withFormat:InventaryIconShowingFull];
    [self addViewOfType:InventaryBarIconTypeDandelion inView:self.inventary.dandelion];
    
    [self.sampleScene hideDandelion];
    [[SoundPlayer sharedPlayer] playDsyn];
}


- (void)didPressSnailInGameScene {
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeSnail
                                                   withFormat:InventaryIconShowingFull];
    [self addViewOfType:InventaryBarIconTypeSnail inView:self.inventary.snail];
    
    [self.sampleScene hideSnail];
    [[SoundPlayer sharedPlayer] playDsyn];
}


- (void)didPressBlueHouseInGameScene {
    typeof(self) welf = self;
    if (self.viewModel.listenedToGinger) {
        if ([[InventaryContentHandler sharedHandler] isOpenedAll]) {
            self.viewModel.openBook = YES;
            [self updateBook];
            [self presentGingerWithText:@"text_panel_ginger_5" completion:^{
#warning indicator to book
            }];
        } else {
            [self presentGingerWithText:@"text_panel_ginger_4" completion:nil];
        }
    } else {
        self.viewModel.listenedToGinger = YES;
        [self presentGingerWithText:@"text_panel_ginger_1" completion:^{
            [welf presentGingerWithText:@"text_panel_ginger_2" completion:^{
                [welf presentGingerWithText:@"text_panel_ginger_3" completion:nil];
            }];
        }];
    }
}


- (void)didPressLampInGameScene {
    if (![self isOpenIcon:InventaryBarIconTypeBottleOfMagic]) {
        [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeBottleOfMagic
                                                       withFormat:InventaryIconShowingGet];
        [self.sampleScene showGetableObjectOfType:GetableObjectTypeBottleOfMagic];
    }
}


- (BOOL)canTapAnything {
    return self.viewModel.listenedToGinger;
}


- (void)presentGingerWithText:(NSString *)text completion:(void (^)())completion {
    [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                                     text:text
                                 isObject:NO
                               completion:completion];
}


- (void)updateInterface {
    [self hideObjectsOnInit];
    [self didChangeLanguageInMainScreenViewModel:nil];
    [self updateBook];
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


- (void)closeTopAndTextBarWithCompletion:(void (^)())completion {
    self.topBarTopConstraint.constant = 0;
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
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
    [[SoundPlayer sharedPlayer] playClick];
    [self.sampleScene closeDoor];
    [self closeLeftMenu];
    [self operOrCloseTopBarForType:MainScreenTopBarViewTypeSettings];
}


- (IBAction)showInventary:(id)sender {
    [[SoundPlayer sharedPlayer] playClick];
    [self.sampleScene closeDoor];
    self.isOpenLeftMenu = !self.isOpenLeftMenu;
    if (self.isOpenLeftMenu) {
        [self addContentToSideMenu];
        self.leftMenuLeadingConstraint.constant = 0;
    } else {
        self.leftMenuLeadingConstraint.constant = - self.leftMenu.frame.size.width;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isOpenLeftMenu) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0.9 * self.leftMenu.frame.size.width, 0, 0);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
    }];
    [self closeTopAndTextBarWithCompletion:nil];
    //    [self operOrCloseTopBarForType:MainScreenTopBarViewTypeInventary];
}


- (void)closeLeftMenu {
    if (!self.isOpenLeftMenu) return;
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:NO];
    self.isOpenLeftMenu = NO;
    self.leftMenuLeadingConstraint.constant = - self.leftMenu.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.sampleScene removeDragableObject];
    [self closeTopAndTextBarWithCompletion:nil];
    [self.sampleScene closeDoor];
}


- (void)setTopbarNavigationsButtonsHiddenState:(BOOL)hidden {
    for (UIButton *button in self.topBarNavigationsButtons) {
        button.hidden = hidden;
    }
}


- (void)didChangeLanguageInMainScreenViewModel:(MainScreenViewModel *)viewModel {
    [self.infiniteTableView reloadData];
    [self.sampleScene changeLanguage];
}


- (void)mainScreenViewModel:(MainScreenViewModel *)viewModel
didWantToOpenViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}


- (UIView *)contentView {
    UIScrollView *scrollView;
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = view;
        }
    }
    
    return [scrollView.subviews firstObject];
}


- (void)didSwipeIconWithType:(SettingsBarIconType)type
                      inRect:(CGRect)rect
               relatedToView:(UIView *)view
                       image:(UIImage *)image {
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:NO];
    CGRect newRect = [[self contentView] convertRect:rect fromView:view];
    switch (type) {
        case SettingsBarIconTypeSword:
            [self.sampleScene createObjectWithImage:image
                                             ofType:InventaryBarIconTypeMagicBallNinja
                                         hiddenType:InventaryBarIconTypeSword
                                           position:newRect.origin];
            break;
        case SettingsBarIconTypeWrench:
            [self.sampleScene createObjectWithImage:image
                                             ofType:InventaryBarIconTypeMagicBallCat
                                         hiddenType:InventaryBarIconTypeWrench
                                           position:newRect.origin];
            break;
        case SettingsBarIconTypeSnail:
            [self.sampleScene createObjectWithImage:image
                                             ofType:InventaryBarIconTypeWrench
                                         hiddenType:InventaryBarIconTypeSnail
                                           position:newRect.origin];
            break;
        case SettingsBarIconTypeDandelion:
            [self.sampleScene createObjectWithImage:image
                                             ofType:InventaryBarIconTypeMagicBallSheep
                                         hiddenType:InventaryBarIconTypeDandelion
                                           position:newRect.origin];
            break;
        case SettingsBarIconTypeExtinguisher:
            [self.sampleScene createObjectWithImage:image
                                             ofType:InventaryBarIconTypeMagicBook
                                         hiddenType:InventaryBarIconTypeExtinguisher
                                           position:newRect.origin];
            break;
        default:
            return;
    }
    [self closeLeftMenu];
}


- (IBAction)openBook {
    if (self.viewModel.openBook) {
        NewBookViewController *newBook = [NewBookViewController instantiate];
        [[SoundPlayer sharedPlayer] playClick];
        [self presentViewController:newBook animated:YES completion:nil];
    } else {
        [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                                         text:@"text_panel_empty_book"
                                     isObject:NO
                                   completion:nil];
    }
}


- (void)putButtonOnRightPositionWithType:(InventaryBarIconType)fullType
                              hiddenType:(InventaryBarIconType)hiddenType {
    if (fullType == InventaryBarIconTypeUnknown) return;
    [[InventaryContentHandler sharedHandler] markItemWithType:fullType
                                                   withFormat:InventaryIconShowingGet];
    [[InventaryContentHandler sharedHandler] markItemWithType:hiddenType
                                                   withFormat:InventaryIconShowingHidden];
    [self.sampleScene removeDragableObject];
    switch (fullType) {
        case InventaryBarIconTypeWrench: {
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_goblin"]
                                             text:@"text_panel_goblin_final"
                                         isObject:NO];
            [self.sampleScene showGetableObjectOfType:GetableObjectTypeWrench];
            [self addViewOfType:InventaryBarIconTypeSnail inView:self.inventary.snail];
            
            [self.sampleScene hideWrench];
            break;
        }
            
        case InventaryBarIconTypeMagicBook: {
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_dragon"]
                                             text:@"text_panel_dragon_final"
                                         isObject:NO];
            [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBook];
            [self addViewOfType:InventaryBarIconTypeExtinguisher inView:self.inventary.extinguisher];
            [self.sampleScene hideBook];
            break;
        }
            
        case InventaryBarIconTypeMagicBallCat: {
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_cat"]
                                             text:@"text_panel_cat_final"
                                         isObject:NO];
            [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallCat];
            [self addViewOfType:InventaryBarIconTypeWrench inView:self.inventary.wrench];
            break;
        }
            
        case InventaryBarIconTypeMagicBallNinja: {
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_ninja"]
                                             text:@"text_panel_ninja_final"
                                         isObject:NO];
            [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallNinja];
            [self addViewOfType:InventaryBarIconTypeSword inView:self.inventary.sword];
            break;
        }
            
        case InventaryBarIconTypeMagicBallSheep: {
            [self didRequireToOpenTextBarWithIcon:[UIImage imageNamed:@"text_panel_sheep"]
                                             text:@"text_panel_sheep_final"
                                         isObject:NO];
            [self.sampleScene showGetableObjectOfType:GetableObjectTypeMagicBallSheep];
            [self addViewOfType:InventaryBarIconTypeDandelion inView:self.inventary.dandelion];
            break;
        }
            
        default: {
            break;
        }
    }
}


- (void)didStartMoveDragableNode {
    [self closeTopAndTextBarWithCompletion:nil];
}


- (void)didRequireToOpenTextBarWithIcon:(UIImage *)image
                                   text:(NSString *)text
                               isObject:(BOOL)isObject {
    [self didRequireToOpenTextBarWithIcon:image text:text isObject:isObject completion:nil];
}


- (void)didRequireToOpenTextBarWithIcon:(UIImage *)image
                                   text:(NSString *)text
                               isObject:(BOOL)isObject
                             completion:(void (^)())completion {
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.textBar.image = image;
        self.textBar.block = completion;
        self.textBar.text = text;
        self.textBar.object = isObject;
        self.textBarBottomConstraint.constant = [self textBarOpenPosition];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 100;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


- (void)configureSideMenu {
    self.inventary = [SideMenu sideMenu];
    self.inventary.frame = CGRectMake(0, 0, self.leftMenu.frame.size.width, self.leftMenu.frame.size.height);
    [self.leftMenu addSubview:self.inventary];
    [self.leftMenu addConstraints:[self constraintsFromSide:self.leftMenu toSide:self.inventary]];
    [self.leftMenu layoutIfNeeded];
}


- (NSArray *)constraintsFromSide:(UIView *)first toSide:(UIView *)second {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:first
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:second
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:first
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:second
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:first
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:second
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:first
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:second
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1
                                                                 constant:0];
    
    return @[top, leading, bottom, trailing];
}


- (void)addContentToSideMenu {
    self.viewModel.type = MainScreenTopBarViewTypeInventary;
    SideMenu *inventary = self.inventary;
    [self addViewOfType:InventaryBarIconTypeIslandMap inView:inventary.island];
    [self addViewOfType:InventaryBarIconTypeMagicWand inView:inventary.magicWand];
    [self addViewOfType:InventaryBarIconTypeBottleOfMagic inView:inventary.bottleOfMagic];
    [self addViewOfType:InventaryBarIconTypeDandelion inView:inventary.dandelion];
    [self addViewOfType:InventaryBarIconTypeExtinguisher inView:inventary.extinguisher];
    [self addViewOfType:InventaryBarIconTypeMagicBall inView:inventary.magicBalls];
    [self addViewOfType:InventaryBarIconTypeMagicBook inView:inventary.book];
    [self addViewOfType:InventaryBarIconTypeMedal inView:inventary.medal];
    [self addViewOfType:InventaryBarIconTypeSnail inView:inventary.snail];
    [self addViewOfType:InventaryBarIconTypeSword inView:inventary.sword];
    [self addViewOfType:InventaryBarIconTypeWrench inView:inventary.wrench];
}


- (void)addViewOfType:(InventaryBarIconType)type inView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
    self.viewModel.type = MainScreenTopBarViewTypeInventary;
    view.backgroundColor = [UIColor clearColor];
    UIView *childView = [self.viewModel viewForIndex:type inRect:view.frame parentViewController:self];
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:childView];
    [view addConstraints:[self constraintsFromSide:view toSide:childView]];
    [view layoutIfNeeded];
}


- (void)updateVolume {
    [self.textBar updateVolume];
    [self.infiniteTableView reloadData];
}


- (void)updateBook {
    if (self.viewModel.openBook) {
        [self.bookIcon setImage:[UIImage imageNamed:@"top_bar_book"] forState:UIControlStateNormal];
    } else {
        [self.bookIcon setImage:[UIImage imageNamed:@"top_bar_empty_book"] forState:UIControlStateNormal];
    }
}

@end
