//
//  FRPChangeRootViewControllerSegue.m
//
//  Created by Francisco José  Rodríguez Pérez on 06/03/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "FRPChangeRootViewControllerSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Utilities.h"

@interface FRPChangeRootViewControllerSegueTransitionViewController : UIViewController

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, weak) UIView *destinationView;

- (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect;

@end

@implementation FRPChangeRootViewControllerSegueTransitionViewController

- (void)viewWillLayoutSubviews
{
    UIImageView *sourceViewSnapshotImageView = [[UIImageView alloc] initWithImage:[self.sourceView snapshotFromView]];
    [self.view addSubview:sourceViewSnapshotImageView];

    UIImageView *destinationViewSnapshotImageView = [[UIImageView alloc] initWithImage:[self.destinationView snapshotFromView]];
    destinationViewSnapshotImageView.frame = CGRectOffset(destinationViewSnapshotImageView.frame, 0, destinationViewSnapshotImageView.frame.size.height);
    destinationViewSnapshotImageView.frame = CGRectInset(destinationViewSnapshotImageView.frame, 15.0, 30.0);
    [self.view addSubview:destinationViewSnapshotImageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        sourceViewSnapshotImageView.frame = CGRectInset(sourceViewSnapshotImageView.frame, 15.0, 30.0);
    } completion:^(BOOL finished) {
        CGFloat offset = 0;
        if (self.destinationView.frame.origin.y == 0.0 && ![self respondsToSelector:@selector(setPreferredContentSize:)]) {
            //In iPhone pre iOS 7 the snapshot includes the status bar but not in iPad
            offset = 20.0;
        }
        [UIView animateWithDuration:0.5 animations:^{
            destinationViewSnapshotImageView.frame = CGRectOffset(destinationViewSnapshotImageView.frame, 0, -(destinationViewSnapshotImageView.frame.size.height + 60.0 + offset));
            sourceViewSnapshotImageView.frame = CGRectOffset(sourceViewSnapshotImageView.frame, 0, -(sourceViewSnapshotImageView.frame.size.height + 60.0 + offset));
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.destinationView.frame;
                frame.origin.y = -offset;
                destinationViewSnapshotImageView.frame = frame;
            } completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
        }];
    }];
}

- (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect
{
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end

@implementation FRPChangeRootViewControllerSegue

- (void)perform
{
    UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
    [[UIApplication sharedApplication] delegate].window.rootViewController = destinationViewController;
    if (!self.animationsDisabled) {
        FRPChangeRootViewControllerSegueTransitionViewController *transitionViewController = [[FRPChangeRootViewControllerSegueTransitionViewController alloc] init];
        transitionViewController.sourceView = ((UIViewController *)self.sourceViewController).view;
        transitionViewController.destinationView = destinationViewController.view;
        [destinationViewController presentViewController:transitionViewController animated:NO completion:nil];
    }
}

@end
