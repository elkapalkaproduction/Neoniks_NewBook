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

@interface SchoolOfMagicViewController () <MagicTableDelegate>

@property (weak, nonatomic) IBOutlet UIView *textBarSuperView;
@property (strong, nonatomic) TextBarViewController *textBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBarBottomConstraint;

@end

@implementation SchoolOfMagicViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[MagicTableViewController class]]) {
        MagicTableViewController *table = segue.destinationViewController;
        table.delegate = self;
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
    [self openTextBarWithIcon:[UIImage imageNamed:@"text_panel_teacher"]
                         text:@"text_panel_teacher_final"
                     isObject:NO];
    [self performSelector:@selector(closeTextBarWithCompletionBlock:) withObject:nil afterDelay:5.f];
}


- (BOOL)shouldShowWelcomeAlert {
    return ![[MagicSchoolAnswersHandler sharedHandler] answeredToAllQuestion];
}


- (CGFloat)textBarHiddenPosition {
    return -self.textBarSuperView.frame.size.height - 10;
}


- (CGFloat)textBarOpenPosition {
    return 5;
}


- (void)stopPlayerIfIsPlaying {
    [self.textBar stopStound];
}

@end
