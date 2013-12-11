//
//  TurtleDemoPointerView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 11/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoPointerView.h"

#import "TurtleBezierPath.h"


@implementation TurtleDemoPointerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [ UIColor clearColor ];
        self.strokeColour = [ UIColor redColor ];
        self.path = [ self pointerPath ];
    }
    
    return self;
}

-(TurtleBezierPath *)pointerPath
{
    TurtleBezierPath *path = [ TurtleBezierPath new ];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 2.0;
    
    [ path home ];
    [ path forward:0.01f ];
    
    [ path up ];
    
    [ path home ];
    [ path forward: 20.0f ];
    [ path turn:180.0f ];
    [ path down ];
    [ path leftArc:40.f turn:30.0f ];
    
    [ path up ];
    
    [ path home ];
    [ path forward: 20.0f ];
    [ path turn:180.0f ];
    [ path down ];
    [ path rightArc:40.f turn:30.0f ];
    
    return path;
}

-(void)positionPointerOnPath:(TurtleBezierPath *)path
{
    self.center = path.currentPoint;
    self.transform = CGAffineTransformMakeRotation( path.bearing * M_PI / 180.0f );
    
    self.alpha = ( path.penUp ) ? 0.333f : 1.0f;
}

@end
