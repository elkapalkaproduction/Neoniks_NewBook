//
//  ChaptersViewModel.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookOptionsProtocol.h"
#import "NNKChapter.h"

@protocol ChaptersListDelegate <NSObject>

- (void)didSelectChapter:(NNKChapter *)chapter;

@end

@interface ChaptersViewModel : NSObject <BookOptionsProtocol>

- (instancetype)initWithChapterList:(NSArray *)chaptersList delegate:(id<ChaptersListDelegate>)delegate;

@end
