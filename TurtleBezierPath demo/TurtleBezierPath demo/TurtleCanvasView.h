//
//  TurtleCanvasView.h
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TurtleBezierPath;


@interface TurtleCanvasView : UIView

@property( nonatomic, strong ) UIColor *fillColour;
@property( nonatomic, strong ) TurtleBezierPath *path;
@property( nonatomic, strong ) UIColor *strokeColour;

@end
