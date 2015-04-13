//
//  ChaptersViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNKChapter.h"
#import "ChaptersViewModel.h"
#import "FontSelectViewModel.h"

@interface BookOptionsViewController : UIViewController

+ (instancetype)instantiateWithChapterList:(NSArray *)chaptersList delegate:(id<ChaptersListDelegate>)delegate;
+ (instancetype)instantiateFontSelectWithDelegate:(id<CustomizationDelegate>)delegate;

@end
