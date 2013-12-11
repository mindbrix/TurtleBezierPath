//
//  RoundedUISlider.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 10/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "RoundedUISlider.h"

@implementation RoundedUISlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(CGFloat)value
{
    return roundToStep( super.value, self.rounding );
}


#pragma mark - Maths

static inline CGFloat roundToStep( CGFloat number, CGFloat step )
{
    return ( step != 0.0f ) ? floorf( number / step ) * step : number;
}


@end
