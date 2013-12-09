//
//  TurtleDemoView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoView.h"

#import "TurtleBezierPath.h"


@implementation TurtleDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [ UIColor whiteColor ];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    
    [ self setNeedsDisplay ];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    TurtleBezierPath *turtlePath = [ TurtleBezierPath new ];
    
    [ turtlePath home ];
    [ turtlePath up ];
    [ turtlePath forward:100.0f ];
    [ turtlePath down ];
    
    for( NSInteger i = 0; i < 400; i++ )
    {
        CGFloat scale = 1 - (CGFloat)i / 400.0f;
        
        [ turtlePath rightArc:20.0f * scale turn:200.0f ];
        [ turtlePath turn:-180.0f ];
    }
    
    [ turtlePath centreInBounds:self.bounds ];
    
    turtlePath.lineWidth = 1.0f;
    [[ UIColor blackColor ] set ];
    //[ turtlePath stroke ];
    
    TurtleBezierPath *clone = [ turtlePath copy ];
   // [ clone stroke ];
    
    
    NSData *cloneData = [ NSKeyedArchiver archivedDataWithRootObject:clone ];
    TurtleBezierPath *unarchivedPath = [ NSKeyedUnarchiver unarchiveObjectWithData:cloneData ];
    
    [ unarchivedPath stroke ];
}


@end
