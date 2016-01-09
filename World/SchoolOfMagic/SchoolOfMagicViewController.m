//
//  SchoolOfMagicViewController.m
//  World
//
//  Created by Andrei Vidrasco on 1/31/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SchoolOfMagicViewController.h"
#import "MagicTableViewController.h"
#import "MagicSchoolAnswersHandler.h"
#import "TextBarViewController.h"
#import "AlertViewController.h"

@interface SchoolOfMagicViewController () <MagicTableDelegate, TextBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;
@property (weak, nonatomic) MagicTableViewController *table;
@property (assign, nonatomic) BOOL prizeAlreadyShowed;
@property (assign, nonatomic, getter=isViewAppear) BOOL viewAppear;

@end

@implementation SchoolOfMagicViewController

+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[MagicTableViewController class]]) {
        MagicTableViewController *table = segue.destinationViewController;
        table.delegate = self;
        self.table = table;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewDidLayoutSubviews {
    self.textBar.frame = self.textBarSuperView.bounds;
    [super viewDidLayoutSubviews];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textBar stopStound];
    self.viewAppear = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewAppear = YES;
    self.textBarBottomConstraint.constant = [self textBarHiddenPosition];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self shouldShowWelcomeAlert]) {
        [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_teacher"]
                             text:@"text_panel_teacher_initial"
                         isObject:NO];
        [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
        [self.textBar stopStound];
    }
}


- (TextBarViewController *)textBar {
    if (!_textBar) {
        _textBar = [TextBarViewController instantiate];
        _textBar.delegate = self;
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
    if (!self.isViewAppear) return;
    if (self.prizeAlreadyShowed) return;
    self.prizeAlreadyShowed = YES;
    [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_teacher"]
                         text:@"text_panel_teacher_final"
                     isObject:NO];
    [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
}


- (BOOL)shouldShowWelcomeAlert {
    return ![[MagicSchoolAnswersHandler sharedHandler] answeredToAllQuestion];
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 100;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (void)stopPlayerIfIsPlaying {
    [self.textBar stopStound];
}


- (void)textBarSoundDidFinish:(TextBarViewController *)textBar {
    [self closeTextBarWithCompletionBlock:nil];
    [self.table showNextUnAnsweredQuestion];
}


- (IBAction)reset:(id)sender {
    AlertViewController *alert = [AlertViewController initWithTitle:@"alert_start_over"
                                                   firstButtonTitle:@"alert_yes"
                                                  firstButtonAction:^{
                                                      [self.table reset];
                                                  }
                                                  secondButtonTitle:NSLocalizedString(@"alert_no", nil)
                                                 secondButtonAction:nil];
    [alert showInViewController:self];
}

@end
