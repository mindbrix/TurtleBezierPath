//
//  TurtleBezierPath+DemoPaths.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 12/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleBezierPath+DemoPaths.h"

@implementation TurtleBezierPath (DemoPaths)


#pragma mark - Demo pattern

+(TurtleBezierPath *)demoPatternPath
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

+(TurtleBezierPath *)pointerPath
{
    TurtleBezierPath *path = [ TurtleBezierPath new ];
    
    CGFloat scale = 2.0f;
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 2.0 * scale;
    
    [ path home ];
    [ path forward:0.01f ];
    
    [ path up ];
    
    [ path home ];
    [ path forward: 20.0f * scale ];
    [ path turn:180.0f ];
    [ path down ];
    [ path leftArc:40.f * scale turn:30.0f ];
    
    [ path up ];
    
    [ path home ];
    [ path forward: 20.0f * scale ];
    [ path turn:180.0f ];
    [ path down ];
    [ path rightArc:40.f * scale turn:30.0f ];
    
    return path;
}


@end
