//
//  TTZoomTranstition.m
//
// Copyright (c) 2015 Tamás Tímár (https://tamastimar.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TTZoomTranstition.h"

@implementation TTZoomTranstition

- (instancetype)init
{
    if (self = [super init])
    {
        _presenting = YES;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.isPresenting ? 0.3 : 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // snapshot to get nicer animations
    UIView* fromSnapshot = [self.isPresenting ? fromViewController.view : toViewController.view snapshotViewAfterScreenUpdates:NO];
    
    CGFloat toZoomInScale = 0.75;
    CGFloat toZoomOutScale = 0.952;
    CGFloat fromZoomScale = 1.05;
    
    if (self.isPresenting)
    {
        [[transitionContext containerView] addSubview:fromSnapshot];
        
        toViewController.view.frame = [transitionContext containerView].bounds;
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.transform = CGAffineTransformMakeScale(toZoomInScale, toZoomInScale);
        toViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.alpha = 1.0;
            
            fromSnapshot.transform = CGAffineTransformMakeScale(fromZoomScale, fromZoomScale);
        } completion:^(BOOL finished) {
            [fromSnapshot removeFromSuperview];
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else
    {
        fromSnapshot.transform = CGAffineTransformMakeScale(fromZoomScale, fromZoomScale);
        [[transitionContext containerView] addSubview:fromSnapshot];
        [[transitionContext containerView] sendSubviewToBack:fromSnapshot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(toZoomOutScale, toZoomOutScale);
            fromViewController.view.alpha = 0.0;
            
            fromSnapshot.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [fromSnapshot removeFromSuperview];
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

@end
