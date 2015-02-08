//
//  MagicTableViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MagicTableViewController.h"
#import "MagicSchoolAnswersHandler.h"

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
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray * answers;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray * questionIndicators;
@property (assign, nonatomic) NSUInteger questionNumber;

@end

@implementation MagicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicVisualSetup];
    [self updateImages];
}


- (void)basicVisualSetup {
    for (UIButton *answer in self.answers) {
        answer.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        answer.titleLabel.numberOfLines = 2;
        answer.titleLabel.textAlignment = NSTextAlignmentCenter;
        answer.titleLabel.font = [UIFont questionFontOfSize:[UIDevice isIpad] ? 15: 10];
        answer.titleLabel.adjustsFontSizeToFitWidth = YES;
        [answer setTitleColor:[UIColor answerForQuestionColor] forState:UIControlStateNormal];
    }
    self.questionNumberTitle.textColor = [UIColor questionTitleColor];
    self.questionNumberTitle.font = [UIFont questionFontOfSize:[UIDevice isIpad] ? 25 :15];
    self.questionText.font = [UIFont questionFontOfSize:[UIDevice isIpad] ? 20 : 15];
}


- (NSString *)answerTitleForQuestionNumber:(NSInteger)index {
    NSString *questionNumber = [NSString stringWithFormat:SOMTextPatternAnswer, (long)index];
    NSString *string = [self questionNameWithString:questionNumber];
    
    return NSLocalizedString(string, nil);
}


- (void)updateImages {
    self.questionNumberTitle.text = NSLocalizedString([self questionNameWithString:SOMImagePatternTitle], nil);
    self.questionText.text = NSLocalizedString([self questionNameWithString:SOMTextPatternQuestion], nil);
    for (NSInteger index = 0; index < [self.answers count]; index++) {
        [self.answers[index] setTitle:[self answerTitleForQuestionNumber:index] forState:UIControlStateNormal];
    }
    [self updateAnswerImage];
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


- (void)updateAnswerImage {
    NSIndexSet *set = [[MagicSchoolAnswersHandler sharedHandler] selectedAnswersForQuestion:self.questionNumber];
    NSArray *imagesNames = @[SOMAskImageName, SOMSadImageName, SOMSadderImageName, SOMSadestImageName,
                             NSLocalizedString([self questionNameWithString:SOMImagePatternAnswer], nil)];
    NSInteger index = [set count];
    self.answerImage.image = [UIImage imageNamed:imagesNames[index]];
    [self updateBorder:set];
    [self updateQuestionsIndicator];
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


- (void)showSuccesMessage {
    if ([[MagicSchoolAnswersHandler sharedHandler] answeredToAllQuestion]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Now you should see prize"
                                                       delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)updateQuestionsIndicator {
    [self resetAllQuestionIndicatorsToNoAnswer];
    [self changeCurrentQuestionIndicatorImage];
    [self changeIndicatorToAnsweredQuestion];
    [self showSuccesMessage];
}


- (NSString *)questionNameWithString:(NSString *)string {
    NSString *qString = [NSString stringWithFormat:SOMQuestionPattern, self.questionNumber];
    
    return [qString stringByAppendingString:string];
}


- (IBAction)openQuestion:(UIButton *)sender {
    self.questionNumber = [self.questionIndicators indexOfObject:sender];
    [self updateImages];
}


- (IBAction)selectAnswer:(UIButton *)sender {
    NSInteger answerNumber = [self.answers indexOfObject:sender];
    [[MagicSchoolAnswersHandler sharedHandler] checkAnswer:answerNumber question:self.questionNumber];
    [self updateImages];
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

@end
