//
//  TransitioningSpecs.m
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>
#import <OCMock/OCMock.h>

#import <TTZoomTransition/TTZoomTranstition.h>
#import "ModalViewController.h"

SpecBegin(Transitioning)

describe(@"Transitioning", ^{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    beforeEach(^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RootNavigation" bundle:nil];
        window.rootViewController = [storyboard instantiateInitialViewController];
    });
    
    context(@"when presentation", ^{
        __block ModalViewController* modalVC = nil;
        
        beforeEach(^{
            id transitioningMock = OCMProtocolMock(@protocol(UIViewControllerTransitioningDelegate));
            
            TTZoomTranstition* presentTransition = [[TTZoomTranstition alloc] init];
            OCMStub([transitioningMock animationControllerForPresentedController:[OCMArg any] presentingController:[OCMArg any] sourceController:[OCMArg any]]).andReturn(presentTransition);
            
            TTZoomTranstition* dismissTransition = [[TTZoomTranstition alloc] init];
            dismissTransition.presenting = NO;
            OCMStub([transitioningMock animationControllerForDismissedController:[OCMArg any]]).andReturn(dismissTransition);
            
            modalVC = [[ModalViewController alloc] init];
            modalVC.modalPresentationStyle = UIModalPresentationCustom;
            modalVC.transitioningDelegate = transitioningMock;
        });
        
        afterEach(^{
            modalVC = nil;
        });
        
        context(@"is animated", ^{
            beforeEach(^{
                waitUntil(^(DoneCallback done) {
                    [window.rootViewController presentViewController:modalVC animated:YES completion:^{
                        done();
                    }];
                });
            });
            
            it(@"modal VC should be presented", ^{
                expect(window).to.haveValidSnapshot();
            });
            
            context(@"and after dismissial is animated", ^{
                beforeEach(^{
                    waitUntil(^(DoneCallback done) {
                        [window.rootViewController dismissViewControllerAnimated:YES completion:^{
                            done();
                        }];
                    });
                });
                
                it(@"presenting VC should be visible", ^{
                    expect(window).to.haveValidSnapshot();
                });
            });
            
            context(@"and after dismissial is not animated", ^{
                beforeEach(^{
                    waitUntil(^(DoneCallback done) {
                        [window.rootViewController dismissViewControllerAnimated:NO completion:^{
                            done();
                        }];
                    });
                });
                
                it(@"presenting VC should be visible", ^{
                    expect(window).to.haveValidSnapshot();
                });
            });
        });
        
        context(@"is not animated", ^{
            beforeEach(^{
                waitUntil(^(DoneCallback done) {
                    [window.rootViewController presentViewController:modalVC animated:NO completion:^{
                        done();
                    }];
                });
            });
            
            it(@"modal VC should be presented", ^{
                expect(window).to.haveValidSnapshot();
            });
            
            context(@"and after dismissial is animated", ^{
                beforeEach(^{
                    waitUntil(^(DoneCallback done) {
                        [window.rootViewController dismissViewControllerAnimated:YES completion:^{
                            done();
                        }];
                    });
                });
                
                it(@"presenting VC should be visible", ^{
                    expect(window).to.haveValidSnapshot();
                });
            });
        });
    });
});

SpecEnd