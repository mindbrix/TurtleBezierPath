//
//  TurtleCanvasView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleCanvasView.h"


@implementation TurtleCanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [ self setDefaults ];
    }
    return self;
}

-(id)initWithPath:(TurtleBezierPath *)path
{
    self = [super initWithFrame:[ path boundsForView ]];
    
    if (self)
    {
        [ self setDefaults ];
        self.path = path;
    }
    return self;
}

-(void)setDefaults
{
    // Initialization code
    self.backgroundColor = [ UIColor whiteColor ];
    self.strokeColour = [ UIColor blackColor ];
}

-(void)positionOnPath:(TurtleBezierPath *)path
{
    self.center = path.currentPoint;
    self.transform = CGAffineTransformMakeRotation( path.bearing * M_PI / 180.0f );
}


#pragma mark - Properties

-(void)setFillColour:(UIColor *)fillColour
{
    _fillColour = fillColour;
    
    [ self setNeedsDisplay ];
}

-(void)setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    
    [ self setNeedsDisplay ];
}

-(void)setPath:(TurtleBezierPath *)path
{
    _path = path;
    
    [ self setNeedsDisplay ];
}

-(void)setStrokeColour:(UIColor *)strokeColour
{
    _strokeColour = strokeColour;
    
    [ self setNeedsDisplay ];
}


#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    if( self.path )
    {
        TurtleBezierPath *drawPath = [ self.path copy ];
        [ drawPath centreInBounds:self.bounds ];
        
        if( self.fillColour )
        {
            [ self.fillColour setFill ];
            [ drawPath fill ];
        }
        
        if( self.strokeColour )
        {
            [ self.strokeColour set ];
            [ drawPath stroke ];
        }
    }
}

@end
