//
//  TurtleDemoView.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoPatternView.h"

#import "TurtleBezierPath.h"


@implementation TurtleDemoPatternView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.fillColour = [ UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f ];
        self.strokeColour = [ UIColor whiteColor ];
        self.path = [ self demoPath ];
        
    }
    return self;
}



#pragma mark - Demo pattern

-(TurtleBezierPath *)demoPath
{
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
    
    turtlePath.lineWidth = 1.0f;
    
    TurtleBezierPath *clone = [ turtlePath copy ];
    
    NSData *cloneData = [ NSKeyedArchiver archivedDataWithRootObject:clone ];
    TurtleBezierPath *unarchivedPath = [ NSKeyedUnarchiver unarchiveObjectWithData:cloneData ];
    
    return unarchivedPath;
}


@end
