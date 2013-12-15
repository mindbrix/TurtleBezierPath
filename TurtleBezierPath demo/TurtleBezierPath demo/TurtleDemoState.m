//
//  TurtleDemoState.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 11/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleDemoState.h"

@implementation TurtleDemoState

-(instancetype)initWithIndex:(NSInteger)index path:(TurtleBezierPath *)path previewPath:(TurtleBezierPath *)previewPath value0:(NSInteger)value0 value1:(NSInteger)value1
{
    self = [ super init ];
    
    if( self )
    {
        _index = index;
        _path = path;
        _previewPath = previewPath;
        _value0 = value0;
        _value1 = value1;
    }
    
    return self;
}


-(BOOL)isEqual:(id)object
{
    TurtleDemoState *aState = object;
    
    return ( self.index == aState.index &&
                self.value0 == aState.value0 &&
                self.value1 == aState.value1 &&
                [ self.path isEqual:aState.path ] &&
                [ self.previewPath isEqual:aState.previewPath ]);
}

-(NSString *)description
{
    return [ NSString stringWithFormat:@"index = %ld, path = %@, previewPath = %@, value0 = %g, value1 = %g", (long)self.index, self.path, self.previewPath, self.value0, self.value1 ];
}

@end
