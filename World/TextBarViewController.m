//
//  TextBarViewController.m
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "TextBarViewController.h"

@interface TextBarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *objectIcon;
@property (weak, nonatomic) IBOutlet UIImageView *characterIcon;

@end

@implementation TextBarViewController

- (instancetype)init {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TextBarViewController class])
                                          owner:self
                                        options:nil] firstObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.font = [UIFont baseFontOfSize:12.f];
}


- (void)setImage:(UIImage *)image {
    self.objectIcon.image = image;
    self.characterIcon.image = image;
}


- (void)setObject:(BOOL)object {
    self.objectIcon.hidden = !object;
    self.characterIcon.hidden = object;
}


- (void)setText:(NSString *)text {
    self.label.text = text;
}

@end
