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

static const CGFloat kPresentedZoomInScale = 0.75;
static const CGFloat kPresentedZoomOutScale = 0.952;
static const CGFloat kPresentingZoomScale = 1.05;

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
    if (self.isPresenting)
    {
        [self doPresentingAnimationInContext:transitionContext];
    }
    else
    {
        [self doDismissingAnimationInContext:transitionContext];
    }
}

- (void)doPresentingAnimationInContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView* transitionContainerView = [transitionContext containerView];
    
    // use snapshot of presenting vc (maybe direct transformation was bugous?)
    UIView* presentingSnapshot = [self snapshotPresentingViewControllerInContext:transitionContext];
    [transitionContainerView addSubview:presentingSnapshot];
    
    UIView* presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    presentedView.frame = [transitionContext containerView].bounds;
    presentedView.transform = CGAffineTransformMakeScale(kPresentedZoomInScale, kPresentedZoomInScale);
    presentedView.alpha = 0.0;
    [transitionContainerView addSubview:presentedView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        presentedView.transform = CGAffineTransformIdentity;
        presentedView.alpha = 1.0;
        
        presentingSnapshot.transform = CGAffineTransformMakeScale(kPresentingZoomScale, kPresentingZoomScale);
    } completion:^(BOOL finished) {
        [presentingSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)doDismissingAnimationInContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView* transitionContainerView = [transitionContext containerView];
    UIView* presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // use snapshot of presenting vc (maybe direct transformation was bugous?)
    UIView* presentingSnapshot = [self snapshotPresentingViewControllerInContext:transitionContext];
    presentingSnapshot.transform = CGAffineTransformMakeScale(kPresentingZoomScale, kPresentingZoomScale);
    [transitionContainerView addSubview:presentingSnapshot];
    [transitionContainerView sendSubviewToBack:presentingSnapshot];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        presentedView.transform = CGAffineTransformMakeScale(kPresentedZoomOutScale, kPresentedZoomOutScale);
        presentedView.alpha = 0.0;
        
        presentingSnapshot.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [presentingSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (UIView*)snapshotPresentingViewControllerInContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UITransitionContextViewControllerKey vcKey = self.isPresenting ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    
    // on iOS 10 transitionContext.viewController.view has to be used, transitionContext.view results blank snapshot
    return [[transitionContext viewControllerForKey:vcKey].view snapshotViewAfterScreenUpdates:false];
}

@end
