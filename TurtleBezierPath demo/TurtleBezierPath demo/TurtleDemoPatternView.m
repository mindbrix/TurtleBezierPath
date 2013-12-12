//
//  TurtleDemoView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoPatternView.h"
#import "TurtleBezierPath+DemoPaths.h"

@implementation TurtleDemoPatternView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.fillColour = [ UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f ];
        self.strokeColour = [ UIColor whiteColor ];
        self.path = [ TurtleBezierPath demoPatternPath ];
    }
    return self;
}


@end
