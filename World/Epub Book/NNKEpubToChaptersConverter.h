//
//  NNKEpubToChaptersConverter.h
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

typedef void (^ActionBlock)(NSArray *resultArray);

@interface NNKEpubToChaptersConverter : NSObject

- (void)convertWithEpubPath:(NSString *)path
            completionBlock:(ActionBlock)completion;

@end
