//
//  UIView+Utilities.m
//
//  Created by Francisco José  Rodríguez Pérez on 06/03/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "UIView+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utilities)

- (UIImage *)snapshotFromView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
