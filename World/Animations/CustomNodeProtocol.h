//
//  CustomNodeProtocol.h
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

@protocol CustomNodeProtocol <NSObject>

- (instancetype)initWithSize:(CGSize)size;

- (void)runAction;

@end