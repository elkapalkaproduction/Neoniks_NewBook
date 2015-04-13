//
//  ChaptersViewModel.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ChaptersViewModel.h"

@interface ChaptersViewModel ()

@property (strong, nonatomic) NSArray *chaptersList;
@property (weak, nonatomic) id<ChaptersListDelegate> delegate;

@end

@implementation ChaptersViewModel

- (instancetype)initWithChapterList:(NSArray *)chaptersList delegate:(id<ChaptersListDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _chaptersList = chaptersList;
    }
    
    return self;
}


- (NSInteger)numberOfRows {
    return [self.chaptersList count];
}


- (NSString *)titleForRowAtIndext:(NSInteger)index {
    return [self.chaptersList[index] title];
}


- (void)didSelectRowAtIndex:(NSInteger)index {
    [self.delegate didSelectChapter:self.chaptersList[index]];
}

@end
