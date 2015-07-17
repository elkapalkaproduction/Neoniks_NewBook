//
//  MagicSchoolAnswersHandler.m
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MagicSchoolAnswersHandler.h"
#import "Storage.h"

const NSInteger numberOfQuestion = 10;
const NSInteger numberOfChoices = 4;

NSString *const AnswersFileName = @"Answers.plist";

@interface MagicSchoolAnswersHandler ()

@property (strong, nonatomic) NSArray *correctAnswers;

@end

@implementation MagicSchoolAnswersHandler

+ (instancetype)sharedHandler {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });

    return sharedMyManager;
}


- (NSArray *)correctAnswers {
    if (!_correctAnswers) {
        NSString *path = [[NSBundle mainBundle] pathForResource:AnswersFileName ofType:nil];
        _correctAnswers = [[NSArray alloc] initWithContentsOfFile:path];
    }

    return _correctAnswers;
}


- (BOOL)checkAnswer:(NSInteger)answer question:(NSInteger)questionNumber {
    if ([self rightAnswerToQuestion:questionNumber] == answer) {
        [Storage saveData:[self setForCorrectAnswer] forKey:[self keyForQuestion:questionNumber]];
        
        return YES;
    }
    NSIndexSet *set = [self selectedAnswersForQuestion:questionNumber];
    NSMutableIndexSet *mutableSet = [[NSMutableIndexSet alloc] initWithIndexSet:set];
    [mutableSet addIndex:answer];
    [Storage saveData:mutableSet forKey:[self keyForQuestion:questionNumber]];
    
    return NO;
}


- (NSIndexSet *)selectedAnswersForQuestion:(NSInteger)questionNumber {
    return [Storage loadDataForKey:[self keyForQuestion:questionNumber]];
}


- (NSString *)keyForQuestion:(NSInteger)questionNumber {
    return [NSString stringWithFormat:@"magicSchoolAnswers%ld", (long)questionNumber];
}


- (NSInteger)rightAnswerToQuestion:(NSInteger)questionNumber {
    return [self.correctAnswers[questionNumber] integerValue];
}


- (void)deleteAllAnswers {
    for (NSInteger index = 0; index < numberOfQuestion; index++) {
        [Storage removeDataForKey:[self keyForQuestion:index]];
    }
}


- (NSIndexSet *)setForCorrectAnswer {
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChoices)];
}


- (NSIndexSet *)answeredQuestions {
    NSMutableIndexSet *mutableSet = [[NSMutableIndexSet alloc] init];
    for (NSInteger index = 0; index < numberOfQuestion; index++) {
        NSIndexSet *numberOfAnswers = [self selectedAnswersForQuestion:index];
        if ([numberOfAnswers count] == numberOfChoices) {
            [mutableSet addIndex:index];
        }
    }

    return [[NSIndexSet alloc] initWithIndexSet:mutableSet];
}


- (BOOL)answeredToAllQuestion {
    return [[self answeredQuestions] count] == numberOfQuestion;
}

@end
