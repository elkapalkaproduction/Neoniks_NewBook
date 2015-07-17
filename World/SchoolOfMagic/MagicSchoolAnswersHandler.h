//
//  MagicSchoolAnswersHandler.h
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagicSchoolAnswersHandler : NSObject

+ (instancetype)sharedHandler;
- (BOOL)checkAnswer:(NSInteger)answer question:(NSInteger)questionNumber;
- (NSIndexSet *)selectedAnswersForQuestion:(NSInteger)questionNumber;
- (NSInteger)rightAnswerToQuestion:(NSInteger)questionNumber;
- (void)deleteAllAnswers;
- (NSIndexSet *)answeredQuestions;
- (BOOL)answeredToAllQuestion;

@end
