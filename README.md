SlideshowView
=============

Simple slideshow view in Cocoa Touch.
Example usage: http://www.youtube.com/watch?v=c4s84iph1Ms

Usage
-----
    slideshow = [[SlideshowView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [slideshow setImages:[NSArray arrayWithObjects:
                         [UIImage imageNamed:@"1.jpeg"],
                         [UIImage imageNamed:@"2.jpeg"],
                         [UIImage imageNamed:@"3.jpeg"],
                         nil]];

    // 20 pixels per second
    slideshow.animationPace = 20.0;
    // 2 seconds between images
    slideshow.fadeDuration = 2;
    // Linear scroll and fade
    slideshow.animationCurve = UIViewAnimationCurveLinear
    [[self view] addSubview:slideshow];

Todo
----
* Different directions of animation
* Play/Pause/Stop

LICENCE
-------

Copyright (C) 2012 Wojtek Siudzinski <admin@suda.pl>, [Appsome](http://appsome.co)

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0