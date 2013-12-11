//
//  TurtleDemoState.h
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 11/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TurtleBezierPath.h"

@interface TurtleDemoState : NSObject

@property( nonatomic, readonly ) NSInteger index;
@property( nonatomic, strong, readonly ) TurtleBezierPath *path;
@property( nonatomic, strong, readonly ) TurtleBezierPath *previewPath;
@property( nonatomic, readonly ) CGFloat value0;
@property( nonatomic, readonly ) CGFloat value1;

-(instancetype)initWithIndex:(NSInteger)index path:(TurtleBezierPath *)path previewPath:(TurtleBezierPath *)previewPath value0:(NSInteger)value0 value1:(NSInteger)value1;

@end
