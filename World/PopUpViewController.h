//
//  PopUpViewController.h
//  World
//
//  Created by Andrei Vidrasco on 3/8/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"

@protocol PopUpDelegate  <NSObject>

- (void)didClosePopUp;

@end

@interface PopUpViewController : BaseViewController

+ (instancetype)instantiateWithMainImage:(UIImage *)mainImage
                             bannerImage:(UIImage *)bannerImage
                                    text:(NSString *)text
                                delegate:(id<PopUpDelegate>)delegate;

- (void)addOnParentView:(UIViewController *)viewController;

@end
