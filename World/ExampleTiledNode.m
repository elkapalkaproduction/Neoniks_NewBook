//
// Created by Piotr Zbyszyński on 2014-04-22.
// Copyright (c) 2014 Piotr Zbyszyński. All rights reserved.
//


#import "ExampleTiledNode.h"

@implementation ExampleTiledNode

#pragma mark -
#pragma mark Properties

- (uint)rowsCount {

	return 8;
}


- (uint)columnsCount {

	return 6;
}


#pragma mark -
#pragma mark Methods

- (NSString *)imageFileNameForRow:(NSUInteger)row column:(NSUInteger)column {

	return [NSString stringWithFormat:@"menu_512x512_%lu.png", ([self rowsCount] - row - 1) * [self columnsCount] + column];
}

@end
