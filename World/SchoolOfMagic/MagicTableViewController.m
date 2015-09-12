//
//  MagicTableViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MagicTableViewController.h"
#import "MagicSchoolAnswersHandler.h"
#import "InventaryContentHandler.h"
#import "SoundPlayer.h"
#import "AVAudioPlayer+Creation.h"

NSString *const SOMSadImageName = @"school_sad";
NSString *const SOMSadderImageName = @"school_sadder";
NSString *const SOMSadestImageName = @"school_sadest";
NSString *const SOMAskImageName = @"school_ask";

NSString *const SOMQuestionPattern = @"q%lu_";

NSString *const SOMTextPatternAnswer = @"answer_%ld";
NSString *const SOMTextPatternQuestion = @"question";
NSString *const SOMImagePatternTitle = @"title";
NSString *const SOMImagePatternAnswer = @"answer_img";

NSString *const SOMQIndicatorAnswered = @"school_answer_exists";
NSString *const SOMQIndicatorSelected = @"school_question_selected";
NSString *const SOMQIndicatorNoAnswer = @"school_no_answer";

NSString *const SOMCorrectBorder = @"school_corect_border";
NSString *const SOMWrongBorder = @"school_wrong_border";
NSString *const SOMNoBorder = @"school_not_selected_border";

@interface MagicTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionNumberTitle;
@property (weak, nonatomic) IBOutlet UILabel *questionText;
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answers;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *questionIndicators;
@property (assign, nonatomic) NSUInteger questionNumber;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *prizeView;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MagicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicVisualSetup];
    [self showNextUnAnsweredQuestion];
    [self.player stop];
}


- (void)basicVisualSetup {
    for (UIButton *answer in self.answers) {
        answer.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        answer.titleLabel.numberOfLines = 2;
        answer.titleLabel.textAlignment = NSTextAlignmentCenter;
        answer.titleLabel.font = [UIFont baseFontOfSize:9];
        answer.titleLabel.adjustsFontSizeToFitWidth = YES;
        [answer setTitleColor:[UIColor baseYellowColor] forState:UIControlStateNormal];
    }
    self.questionNumberTitle.textColor = [UIColor questionTitleColor];
    self.questionNumberTitle.font = [UIFont baseFontOfSize:15];
    self.questionText.font = [UIFont baseFontOfSize:15];
    [self changeIndicatorToAnsweredQuestion];
}


- (NSString *)answerTitleForQuestionNumber:(NSInteger)index {
    NSString *questionNumber = [NSString stringWithFormat:SOMTextPatternAnswer, (long)index];
    NSString *string = [self questionNameWithString:questionNumber];
    
    return NSLocalizedString(string, nil);
}


- (BOOL)updateImages {
    self.questionNumberTitle.text = NSLocalizedString([self questionNameWithString:SOMImagePatternTitle], nil);
    self.questionText.text = NSLocalizedString([self questionNameWithString:SOMTextPatternQuestion], nil);
    NSString *soundName = NSLocalizedString([self questionNameWithString:@"sound"], nil);
    [self.player stop];
    self.player = [AVAudioPlayer audioPlayerWithSoundName:soundName];
    for (NSInteger index = 0; index < [self.answers count]; index++) {
        [self.answers[index] setTitle:[self answerTitleForQuestionNumber:index] forState:UIControlStateNormal];
    }
    
    return [self updateAnswerImage];
}


- (void)resetAnswerToNoBorderState {
    [self.answers enumerateObjectsUsingBlock:^(UIButton *answer, NSUInteger idx, BOOL *stop) {
        [answer setBackgroundImage:[UIImage imageNamed:SOMNoBorder] forState:UIControlStateNormal];
    }];
}


- (void)correctAnswerExists {
    [self resetAnswerToNoBorderState];
    NSInteger index = [[MagicSchoolAnswersHandler sharedHandler] rightAnswerToQuestion:self.questionNumber];
    [self.answers[index] setBackgroundImage:[UIImage imageNamed:SOMCorrectBorder] forState:UIControlStateNormal];
}


- (void)setWrongAnswersBorder:(NSIndexSet *)set {
    [self resetAnswerToNoBorderState];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self.answers[idx] setBackgroundImage:[UIImage imageNamed:SOMWrongBorder] forState:UIControlStateNormal];
    }];
}


- (void)updateBorder:(NSIndexSet *)set {
    if ([set count] == 4) {
        [self setInactiveButtons];
        [self correctAnswerExists];
    } else {
        [self setActiveButtons];
        [self setWrongAnswersBorder:set];
    }
}


- (BOOL)updateAnswerImage {
    NSIndexSet *set = [[MagicSchoolAnswersHandler sharedHandler] selectedAnswersForQuestion:self.questionNumber];
    NSArray *imagesNames = @[SOMAskImageName, SOMSadImageName, SOMSadderImageName, SOMSadestImageName,
                             NSLocalizedString([self questionNameWithString:SOMImagePatternAnswer], nil)];
    NSInteger index = [set count];
    self.answerImage.image = [UIImage imageNamed:imagesNames[index]];
    [self updateBorder:set];
    [self updateQuestionsIndicator];
    
    return index == 4;
}


- (void)resetAllQuestionIndicatorsToNoAnswer {
    [self.questionIndicators enumerateObjectsUsingBlock:^(UIButton *indicator, NSUInteger idx, BOOL *stop) {
        [indicator setImage:[UIImage imageNamed:SOMQIndicatorNoAnswer] forState:UIControlStateNormal];
    }];
}


- (void)changeCurrentQuestionIndicatorImage {
    [self.questionIndicators[self.questionNumber] setImage:[UIImage imageNamed:SOMQIndicatorSelected] forState:UIControlStateNormal];
}


- (void)changeIndicatorToAnsweredQuestion {
    NSIndexSet *answeredQuestions = [[MagicSchoolAnswersHandler sharedHandler] answeredQuestions];
    [answeredQuestions enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self.questionIndicators[idx] setImage:[UIImage imageNamed:SOMQIndicatorAnswered] forState:UIControlStateNormal];
    }];
}


- (BOOL)shouldShowPrize {
    InventaryIconShowing format = [[InventaryContentHandler sharedHandler] formatForItemType:InventaryBarIconTypeMedal];
    
    return [[MagicSchoolAnswersHandler sharedHandler] answeredToAllQuestion] && format == InventaryIconShowingEmpty;
}


- (void)showSuccesMessage {
    if ([self shouldShowPrize]) {
        [self showPrize];
    } else {
        self.prizeView.hidden = YES;
    }
}


- (void)updateQuestionsIndicator {
    [self resetAllQuestionIndicatorsToNoAnswer];
    [self changeCurrentQuestionIndicatorImage];
    [self changeIndicatorToAnsweredQuestion];
    if (![self shouldShowPrize]) {
        self.prizeView.hidden = YES;
    }
}


- (NSString *)questionNameWithString:(NSString *)string {
    NSString *qString = [NSString stringWithFormat:SOMQuestionPattern, (unsigned long)self.questionNumber];
    
    return [qString stringByAppendingString:string];
}


- (void)showQuestion:(NSInteger)question {
    self.questionNumber = question;
    [self updateImages];
    [self.player play];
    [self.delegate stopPlayerIfIsPlaying];
}


- (IBAction)openQuestion:(UIButton *)sender {
    if ([self shouldShowPrize]) return;
    [[SoundPlayer sharedPlayer] playClick];
    [self.timer invalidate];
    NSInteger index = [self.questionIndicators indexOfObject:sender];
    [self showQuestion:index];
}


- (IBAction)selectAnswer:(UIButton *)sender {
    NSInteger answerNumber = [self.answers indexOfObject:sender];
    BOOL answer = [[MagicSchoolAnswersHandler sharedHandler] checkAnswer:answerNumber question:self.questionNumber];
    if (answer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                      target:self
                                                    selector:@selector(showNextUnAnsweredQuestion)
                                                    userInfo:nil
                                                     repeats:NO];
        [[SoundPlayer sharedPlayer] playCorrectAnswer];
    } else {
        [[SoundPlayer sharedPlayer] playWrongAnswer];
    }
    [self updateAnswerImage];
}


- (void)setInactiveButtons {
    [self.answers enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button setUserInteractionEnabled:NO];
    }];
}


- (void)setActiveButtons {
    [self.answers enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button setUserInteractionEnabled:YES];
    }];
}


- (void)showPrize {
    [self.player stop];
    self.answerView.hidden = YES;
    self.questionNumberTitle.hidden = YES;
    self.questionText.hidden = YES;
    self.answerImage.hidden = YES;
    self.prizeView.hidden = NO;
    [self.delegate prizeDidAppear];
}


- (IBAction)getPrize:(id)sender {
    self.answerView.hidden = NO;
    self.questionNumberTitle.hidden = NO;
    self.questionText.hidden = NO;
    self.answerImage.hidden = NO;
    self.prizeView.hidden = YES;
    [[InventaryContentHandler sharedHandler] markItemWithType:InventaryBarIconTypeMedal
                                                   withFormat:InventaryIconShowingFull];
    [self showQuestion:self.questionNumber];
}


- (void)showNextUnAnsweredQuestion {
    NSInteger index = [[MagicSchoolAnswersHandler sharedHandler] nextUnansweredQuestion];
    if (index == NSNotFound) {
        if ([self shouldShowPrize]) {
            [self showPrize];
        } else {
            self.prizeView.hidden = YES;
            [self showQuestion:0];
        }
        return;
    }
    [self showQuestion:index];
}


- (IBAction)didPressOnQuestion:(id)sender {
    [self.timer invalidate];
    [self showQuestion:self.questionNumber];
}


- (void)reset {
    [[MagicSchoolAnswersHandler sharedHandler] deleteAllAnswers];
    [self showQuestion:self.questionNumber];
}


- (IBAction)showNextQuestion:(id)sender {
    if (self.questionNumber == 9) {
        self.questionNumber = 0;
    } else {
        self.questionNumber++;
    }
    [self showQuestion:self.questionNumber];
}


- (IBAction)showPrevQuestion:(id)sender {
    if (self.questionNumber == 0) {
        self.questionNumber = 9;
    } else {
        self.questionNumber--;
    }
    [self showQuestion:self.questionNumber];
    
}

@end
