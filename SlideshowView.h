/*
    SlideshowView.h

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

#import <UIKit/UIKit.h>

@interface SlideshowView : UIView {
    int currentStep;
    NSMutableArray *imageViews;
}

@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign) CGFloat animationPace;
@property (nonatomic, assign) UIViewAnimationCurve animationCurve;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSMutableArray *images;

- (void)animate;

@end
