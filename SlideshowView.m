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
        animationPace = 30.0;
        fadeDuration = 1;
        currentStep = -1;
        animationCurve = UIViewAnimationCurveLinear;
        
        images = [NSMutableArray new];
        imageViews = [NSMutableArray new];
    }
    return self;
}

- (void)setImages:(NSArray *)_images {
    for (UIImageView *iv in imageViews) {
        [iv removeFromSuperview];
    }
    [imageViews removeAllObjects];
    [images removeAllObjects];
    
    int i = 0;
    for (UIImage *image in _images) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.hidden = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [images addObject:image];
        [imageViews addObject:iv];
        
        [self addSubview:iv];
        i++;
    }

    if ([images count] > 0) {
        currentStep = 0;
        isAnimating = YES;
        [self animate];
    }
}

- (void)animate {
    UIImage *image = [images objectAtIndex:currentStep];
    UIImageView *iv = [imageViews objectAtIndex:currentStep];
    
    CGFloat ratio = self.frame.size.height / image.size.height;
    CGRect frame = CGRectMake(-((image.size.width * ratio) - self.frame.size.width), 0, image.size.width * ratio, self.frame.size.height);
    NSLog(@"%f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
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
    UIImageView *iv = [imageViews objectAtIndex:currentStep];
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
    
    currentStep = currentStep < [images count] - 1 ? currentStep + 1 : 0;
    [self animate];
}

@end
