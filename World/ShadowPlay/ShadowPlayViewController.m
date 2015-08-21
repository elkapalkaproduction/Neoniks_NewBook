//
//  ShadowPlayViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/2/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ShadowPlayViewController.h"
#import "CharacterShadowViewController.h"
#import "ShadowPlayOpenedHandler.h"
#import "DragableButton.h"
#import "InventaryContentHandler.h"
#import "MyScene.h"
#import "NNKMinerNode.h"
#import "NNKJayNode.h"
#import "NNKWandaNode.h"
#import "NNKHaroldNode.h"
#import "NNKFurcoatNode.h"
#import "NNKPhoebeNode.h"
#import "NNKJustacreepNode.h"
#import "NNKMystieNode.h"
#import "TextBarViewController.h"
#import "AVAudioPlayer+Creation.h"
#import "SoundPlayer.h"
#import "AlertViewController.h"

NSString *const NSPSegueIdentifierPattern = @"character";

NSString *const NSPTextPatternDescription = @"shadow_description_%ld";
NSString *const NSPImagePatternPortraitColor = @"full_portret_color_%ld";
NSString *const NSPImagePatternPortraitShadow = @"full_portret_shadow_%ld";

NSString *const NSPImageNameTitle = @"shadow_title";
NSString *const NSPFileNameWrongPosition = @"shadow_wrong_position.plist";
NSString *const NSPFileNameCorrectPosition = @"shadow_correct_position.plist";

@interface ShadowPlayViewController () <CharacterShadowDelegate, DragableButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIView *viewForElements;
@property (weak, nonatomic) IBOutlet UIView *viewForResults;
@property (weak, nonatomic) IBOutlet UIImageView *fullPortret;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) ShadowCharacter loadedCharacter;
@property (strong, nonatomic) NSMutableArray *shadowElements;
@property (strong, nonatomic) NSMutableSet *arrayOfSegues;
@property (weak, nonatomic, readonly) NSDictionary *wrongAnswers;
@property (weak, nonatomic, readonly) NSDictionary *correctAnswers;
@property (assign, nonatomic, readonly) CGFloat imageRatio;
@property (weak, nonatomic) IBOutlet UIView *prizeView;
@property (strong, nonatomic) MyScene *scene;
@property (strong, nonatomic) SKView *skView;

@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ShadowPlayViewController

- (MyScene *)sceneWithFrame:(CGRect)frame node:(SKNode<CustomNodeProtocol> *)node {
    MyScene *scene = [MyScene sceneWithSize:frame.size];
    scene.node = node;
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


- (void)prepareSkView {
    CGRect frame = self.viewForResults.bounds;
    self.skView = [self skViewWithSize:frame node:nil];
    
    [self.viewForResults addSubview:self.skView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowElements = [[NSMutableArray alloc] init];
    self.descriptionLabel.font = [UIFont baseFontOfSize:[UIDevice isIpad] ? 30 : 18];
    self.bannerImage.image = [UIImage imageNamed:NSLocalizedString(NSPImageNameTitle, nil)];
    self.loadedCharacter = ShadowCharacterJay;
    self.prizeView.hidden = YES;
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self didPressCharacter:self.loadedCharacter];
    [self.player stop];
    self.viewForElements.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareSkView];
    [self didPressCharacter:self.loadedCharacter];
    if ([self shouldShowWelcomeAlert]) {
        [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                             text:@"text_panel_shadow_initial"
                         isObject:NO];
        [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
        [self.player stop];
    } else {
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textBar stopStound];
    [self.player stop];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier rangeOfString:NSPSegueIdentifierPattern].location != NSNotFound) {
        if (self.arrayOfSegues) {
            [self.arrayOfSegues addObject:segue];
        } else {
            self.arrayOfSegues = [[NSMutableSet alloc] initWithObjects:segue, nil];
        }
    }
}


- (void)setLoadedCharacter:(ShadowCharacter)loadedCharacter {
    _loadedCharacter = loadedCharacter;
    [self updateCharactersMenuInformation];
}


- (NSDictionary *)wrongAnswers {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSPFileNameWrongPosition ofType:nil];
    
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}


- (NSDictionary *)correctAnswers {
    NSString *path = [[NSBundle mainBundle] pathForResource:NSPFileNameCorrectPosition ofType:nil];
    
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}


- (void)didPressCharacter:(ShadowCharacter)character {
    if (!self.prizeView.hidden) return;
    self.loadedCharacter = character;
    NSString *audioName = [NSString stringWithFormat:@"shadow_sound_%ld", self.loadedCharacter];
    self.player = [AVAudioPlayer audioPlayerWithSoundName:NSLocalizedString(audioName, nil)];
    if ([[ShadowPlayOpenedHandler sharedHandler] isOpenedCharacter:character]) {
        [self loadUnlockedCharacter:character];
        [self.textBar stopStound];
        [self.player play];
    } else {
        [self loadLockedCharacter:character];
        [self.player stop];
    }
    
    
    
}


- (void)removeAllShadowsFromTheScreen {
    [self.shadowElements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.shadowElements removeAllObjects];
}


- (void)loadShadowsForCharacter:(ShadowCharacter)character {
    [self removeAllShadowsFromTheScreen];
    NSString *key = [NSString stringWithFormat:@"character%ld", (long)character];
    NSDictionary *wrongCharacterPositions = self.wrongAnswers[key];
    NSDictionary *correctCharacterPositions = self.correctAnswers[key];
    NSArray *allKeys = [wrongCharacterPositions allKeys];
    for (NSString *currentKey in allKeys) {
        [self createShadowElement:[UIImage imageNamed:currentKey]
          wrongCharacterPositions:CGPointFromString(wrongCharacterPositions[currentKey])
        correctCharacterPositions:CGRectFromString(correctCharacterPositions[currentKey])];
    }
}


- (CGRect)scaledRectFromRect:(CGRect)rect {
    CGRect newRect = rect;
    newRect.origin.x *= self.imageRatio;
    newRect.origin.y *= self.imageRatio;
    newRect.size.width *= self.imageRatio;
    newRect.size.height *= self.imageRatio;
    
    return newRect;
}


- (CGFloat)imageRatio {
    return self.fullPortret.frame.size.width / 814;
}


- (BOOL)shouldShowPrize {
    InventaryIconShowing format = [[InventaryContentHandler sharedHandler] formatForItemType:InventaryBarIconTypeMagicWand];
    
    return [[[ShadowPlayOpenedHandler sharedHandler] allOpenedCharacter] count] == 8 && format == InventaryIconShowingEmpty;
}


- (void)hideShadowsAndMarksAsSolved {
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:self.loadedCharacter];
    
    [self updateCharactersMenuInformation];
    [self.shadowElements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.3 animations:^{
            [obj setAlpha:0.f];
        } completion:^(BOOL finished) {
            [obj removeFromSuperview];
            [self.player play];
            [self loadUnlockedCharacter:self.loadedCharacter];
        }];
    }];
}


- (void)putButton:(DragableButton *)button onRightFrame:(CGRect)newFrame {
    [button removeFromSuperview];
    [self.viewForResults addSubview:button];
    [button setFrame:newFrame];
    [UIView animateWithDuration:0.4 animations:^{
        [button setFrame:button.correctRect];
    } completion:^(BOOL finished) {
        if ([self.viewForElements.subviews count] == 0) {
            [self hideShadowsAndMarksAsSolved];
        }
    }];
}


- (BOOL)correctTargetPositionForButton:(DragableButton *)button {
    CGRect newFrame = [button.superview convertRect:button.frame toView:self.viewForResults];
    if (CGRectIntersectsRect(newFrame, button.correctRect)) {
        [self putButton:button onRightFrame:newFrame];
        
        return YES;
    }
    
    return NO;
}


- (CharactersInteraction)characterInteractionForCharacter:(ShadowCharacter)character {
    if ([[ShadowPlayOpenedHandler sharedHandler] isOpenedCharacter:character]) {
        return CharactersInteractionOpened;
    }
    if (self.loadedCharacter == character) {
        return CharactersInteractionSelected;
    }
    
    return CharactersInteractionClosed;
}


- (void)updateCharactersMenuInformation {
    for (UIStoryboardSegue *segue in self.arrayOfSegues) {
        [self updateCharacterInfoFromSegue:segue];
    }
}


- (void)updateCharacterInfoFromSegue:(UIStoryboardSegue *)segue {
    NSString *identifier = [segue.identifier stringByReplacingOccurrencesOfString:NSPSegueIdentifierPattern withString:@""];
    NSInteger characterID = [identifier integerValue];
    CharacterShadowViewController *character = segue.destinationViewController;
    character.delegate = self;
    CharactersInteraction characterInteraction = [self characterInteractionForCharacter:characterID];
    [character updateInterfaceWithCharacter:characterID characterInteraction:characterInteraction];
}


- (void)loadUnlockedCharacter:(ShadowCharacter)character {
    [self removeAllShadowsFromTheScreen];
    self.viewForElements.hidden = YES;
    self.descriptionLabel.hidden = NO;
    self.prizeView.hidden = YES;
    NSString *string = [NSString stringWithFormat:NSPTextPatternDescription, (long)character];
    self.descriptionLabel.text = NSLocalizedString(string, nil);
    
    CGSize size = self.viewForResults.bounds.size;
    SKNode<CustomNodeProtocol> *node;
    
    switch (character) {
        case ShadowCharacterJay:
            node = [[NNKJayNode alloc] initWithSize:size];
            break;
        case ShadowCharacterWanda:
            node = [[NNKWandaNode alloc] initWithSize:size];
            break;
        case ShadowCharacterFurcoat:
            node = [[NNKFurcoatNode alloc] initWithSize:size];
            break;
        case ShadowCharacterMiner:
            node = [[NNKMinerNode alloc] initWithSize:size];
            break;
        case ShadowCharacterHarold:
            node = [[NNKHaroldNode alloc] initWithSize:size];
            break;
        case ShadowCharacterPhoebe:
            node = [[NNKPhoebeNode alloc] initWithSize:size];
            break;
        case ShadowCharacterJustacreep:
            node = [[NNKJustacreepNode alloc] initWithSize:size];
            break;
        case ShadowCharacterMystie:
            node = [[NNKMystieNode alloc] initWithSize:size];
            break;
        default: {
            break;
        }
    }
    self.fullPortret.image = nil;
    self.scene.node = node;
    
}


- (void)loadLockedCharacter:(ShadowCharacter)character {
    self.scene.node = nil;
    self.descriptionLabel.hidden = YES;
    self.fullPortret.image = [UIImage imageNamed:[NSString stringWithFormat:NSPImagePatternPortraitShadow, (long)character]];
    self.viewForElements.hidden = NO;
    self.prizeView.hidden = YES;
    [self loadShadowsForCharacter:character];
}


- (void)createShadowElement:(UIImage *)image
    wrongCharacterPositions:(CGPoint)wrongCharacterPositions
  correctCharacterPositions:(CGRect)correctCharacterPositions {
    CGRect frame;
    frame.size = correctCharacterPositions.size;
    
    CGFloat viewWidth = self.viewForElements.frame.size.width;
    CGFloat viewHeigth = self.viewForElements.frame.size.height;
    
    const CGFloat X = arc4random() % (int)viewWidth - viewWidth / 2;
    const CGFloat Y = arc4random() % (int)viewHeigth - viewHeigth / 2;
    
    frame.origin = wrongCharacterPositions;
    frame.origin.x += X;
    frame.origin.y += Y;
    frame = [self scaledRectFromRect:frame];
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.x + frame.size.width > viewWidth) {
        frame.origin.x = viewWidth - frame.size.width;
    }
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.origin.y + frame.size.height > viewHeigth) {
        frame.origin.y = viewHeigth - frame.size.height;
    }
    DragableButton *shadow = [[DragableButton alloc] initWithFrame:frame];
    shadow.correctRect = [self scaledRectFromRect:correctCharacterPositions];
    shadow.delegate = self;
    [shadow setImage:image forState:UIControlStateNormal];
    [self.shadowElements addObject:shadow];
    [self.viewForElements addSubview:shadow];
}


- (IBAction)getPrize:(id)sender {
    [[SoundPlayer sharedPlayer] playCorrectAnswer];
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMagicWand withFormat:InventaryIconShowingFull];
    [self closeTextBarWithCompletionBlock:^{
        [self.textBar stopStound];
        [self backButton:nil];
    }];
}


- (void)showMagicWand {
    self.fullPortret.hidden = YES;
    self.descriptionLabel.hidden = YES;
    self.viewForElements.hidden = YES;
    self.prizeView.hidden = NO;
    self.scene.node = nil;
    [self.player stop];
    [self prizeDidAppear];
}


- (void)viewDidLayoutSubviews {
    self.textBar.frame = self.textBarSuperView.bounds;
    [super viewDidLayoutSubviews];
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


- (void)prizeDidAppear {
    [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_ginger"]
                         text:@"text_panel_shadow_final"
                     isObject:NO];
    [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
}


- (BOOL)shouldShowWelcomeAlert {
    return [[[ShadowPlayOpenedHandler sharedHandler] allOpenedCharacter] count] != 8;
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 10;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (void)backButton:(id)sender {
    if ([self shouldShowPrize]) {
        [self showMagicWand];
    } else {
        [super backButton:sender];
    }
}


- (IBAction)reset:(id)sender {
    AlertViewController *alert = [AlertViewController initWithTitle:NSLocalizedString(@"alert_start_over", nil)
                                                   firstButtonTitle:NSLocalizedString(@"alert_yes", nil)
                                                  firstButtonAction:^{
                                                      [[ShadowPlayOpenedHandler sharedHandler] resetOpenedCharacter];
                                                      [self didPressCharacter:self.loadedCharacter];
                                                  }
                                                  secondButtonTitle:NSLocalizedString(@"alert_no", nil)
                                                 secondButtonAction:nil];
    [alert showInViewController:self];
}

@end
