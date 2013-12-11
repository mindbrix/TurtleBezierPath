//
//  TurtleDemoState.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 11/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoState.h"

@implementation TurtleDemoState

-(instancetype)initWithIndex:(NSInteger)index path:(TurtleBezierPath *)path value0:(NSInteger)value0 value1:(NSInteger)value1
{
    self = [ super init ];
    
    if( self )
    {
        _index = index;
        _path = path;
        _value0 = value0;
        _value1 = value1;
    }
    
    return self;
}


-(BOOL)isEqual:(id)object
{
    TurtleDemoState *aState = object;
    
    if( self.index == aState.index && self.value0 == aState.value0 && self.value1 == aState.value1 )
    {
        NSData *selfPathData = [ NSKeyedArchiver archivedDataWithRootObject:self.path ];
        NSData *aStatePathData = [ NSKeyedArchiver archivedDataWithRootObject:aState.path ];
        
        return [ selfPathData isEqualToData:aStatePathData ];
    }
    
    return NO;
}

@end
