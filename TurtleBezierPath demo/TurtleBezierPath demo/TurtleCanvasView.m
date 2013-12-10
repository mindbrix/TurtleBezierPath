//
//  TurtleCanvasView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleCanvasView.h"

#import "TurtleBezierPath.h"


@implementation TurtleCanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [ UIColor whiteColor ];
        self.strokeColour = [ UIColor blackColor ];
    }
    return self;
}


#pragma mark - Properties

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


#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if( self.path )
    {
        TurtleBezierPath *drawPath = [ self.path copy ];
        [ drawPath centreInBounds:self.bounds ];
        
        if( self.fillColour )
        {
            [ self.fillColour setFill ];
            [ drawPath fill ];
        }
        
        UIColor *strokeColour = ( self.strokeColour ) ? self.strokeColour : [ UIColor blackColor ];
        [ strokeColour set ];
        [ drawPath stroke ];
    }
}

@end
