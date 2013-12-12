//
//  TurtleDemoPointerView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 11/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoPointerView.h"

#import "TurtleBezierPath.h"
#import "TurtleBezierPath+DemoPaths.h"


@implementation TurtleDemoPointerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [ UIColor clearColor ];
        self.strokeColour = [ UIColor redColor ];
        self.path = [ TurtleBezierPath pointerPath ];
    }
    
    return self;
}


-(void)positionPointerOnPath:(TurtleBezierPath *)path
{
    self.center = path.currentPoint;
    self.transform = CGAffineTransformMakeRotation( path.bearing * M_PI / 180.0f );
    
    self.alpha = ( path.penUp ) ? 0.333f : 1.0f;
}

@end
