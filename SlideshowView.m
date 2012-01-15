/*
    SlideshowView.m

    Created by Wojtek Siudzinski on 03.01.2012.
    Copyright (c) 2012 Appsome. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#import "SlideshowView.h"

@implementation SlideshowView

@synthesize animationPace, fadeDuration, animationCurve, isAnimating, images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        animationPace = 20.0;
        fadeDuration = 1;
        currentStep = -1;
        previousStep = -1;
        animationCurve = UIViewAnimationCurveLinear;
        
        images = [NSMutableArray new];
        firstIv = [UIImageView new];
        [self addSubview:firstIv];
        secondIv = [UIImageView new];        
        [self addSubview:secondIv];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)animate {
    if (!self.isAnimating) return;
    
    UIImage *image = [UIImage imageNamed:[images objectAtIndex:currentStep]];
    UIImageView *iv = (currentStep % 2) == 0 ? firstIv : secondIv;
    [iv setImage:image];
    
    CGFloat ratio = self.frame.size.height / image.size.height;
    CGRect frame = CGRectMake(-((image.size.width * ratio) - self.frame.size.width), 0, image.size.width * ratio, self.frame.size.height);
    
    iv.frame = frame;
    iv.hidden = NO;
    iv.alpha = 1;
    
    [UIView beginAnimations:[NSString stringWithFormat:@"scroll_%i", currentStep] context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(scrollDone)];
    [UIView setAnimationDuration:((-frame.origin.x) / self.animationPace)];
    [UIView setAnimationCurve:self.animationCurve];
    [UIView setAnimationBeginsFromCurrentState:NO];
    frame.origin.x = -(animationPace * fadeDuration);
    [iv setFrame:frame];
    [UIView commitAnimations];
}

- (void)scrollDone {
    if (!self.isAnimating) return;
    
    UIImageView *iv = (currentStep % 2) == 0 ? firstIv : secondIv;
    [self bringSubviewToFront:iv];
    
    CGRect frame = iv.frame;
    [UIView beginAnimations:[NSString stringWithFormat:@"fade_%i", currentStep] context:nil];
    [UIView setAnimationDuration:fadeDuration];
    [UIView setAnimationCurve:self.animationCurve];
    [UIView setAnimationBeginsFromCurrentState:NO];
    frame.origin.x = 0;
    [iv setFrame:frame];
    [iv setAlpha:0];
    [UIView commitAnimations];
    
    previousStep = currentStep;
    currentStep = currentStep < [images count] - 1 ? currentStep + 1 : 0;
    [self animate];
}

- (void)setImages:(NSArray *)_images {
    images = _images;
    [firstIv setImage:nil];
    [secondIv setImage:nil];

    if ([images count] > 0) {
        currentStep = 0;
        isAnimating = YES;
        [self animate];
    }
}

- (void)didRotate:(NSNotification *)notification {
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
}

- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval paused_time = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = paused_time;
    isAnimating = NO;
}

- (void)resumeLayer:(CALayer*)layer {
    CFTimeInterval paused_time = [layer timeOffset];
    layer.speed = 1.0f;
    layer.timeOffset = 0.0f;
    layer.beginTime = 0.0f;
    CFTimeInterval time_since_pause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - paused_time;
    layer.beginTime = time_since_pause;
    isAnimating = YES;
}

- (void)pause {
    [self pauseLayer:[firstIv layer]];
    [self pauseLayer:[secondIv layer]];
}

- (void)resume {
    if (self.isAnimating) return;
    
    [self resumeLayer:[firstIv layer]];
    [self resumeLayer:[secondIv layer]];
}

@end
