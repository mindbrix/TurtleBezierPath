//
//  TurtleViewController.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleViewController.h"

#import "RoundedUISlider.h"

#import "TurtleCanvasView.h"
#import "TurtleDemoPatternView.h"
#import "TurtleDemoPointerView.h"
#import "TurtleDemoState.h"
#import "TurtleBezierPath.h"


@interface TurtleViewController ()

@property( nonatomic, strong ) UISegmentedControl *commandControl;
@property( nonatomic, strong ) UILabel *commandLabel;
@property( nonatomic, strong ) TurtleCanvasView *canvasView;
@property( nonatomic, strong ) TurtleDemoPointerView *pointerView;

@property( nonatomic, strong ) TurtleBezierPath *path;
@property( nonatomic, strong ) TurtleBezierPath *previewPath;

@property( nonatomic, strong ) RoundedUISlider *valueSlider0;
@property( nonatomic, strong ) RoundedUISlider *valueSlider1;

@end


@implementation TurtleViewController

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [ self initDemoApp ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    //[ self becomeFirstResponder ];
    
    [ self layoutViews ];
}

- (void)viewWillDisappear:(BOOL)animated {
    // No longer need to receive the shake gesture event since the view is gone
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [ self layoutViews ];
}

#pragma mark - Init

-(void)initDemoApp
{
    self.canvasView = [[ TurtleCanvasView alloc ] initWithFrame:self.view.bounds ];
    self.canvasView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [ self.view addSubview:self.canvasView ];
    
    self.pointerView = [[ TurtleDemoPointerView alloc ] initWithFrame:CGRectMake( 0.0f, 0.0f, 40.0f, 40.0f )];
    [ self.view addSubview:self.pointerView ];
    
    self.commandLabel = [ UILabel new ];
    self.commandLabel.backgroundColor = [ UIColor clearColor ];
    self.commandLabel.font = [ UIFont fontWithName:@"Menlo-Regular" size:18.0f ];
    self.commandLabel.textAlignment = NSTextAlignmentCenter;
    self.commandLabel.textColor = [ UIColor blackColor ];
    self.commandLabel.text = @"commandLabel";
    [ self.view addSubview:self.commandLabel ];
    
    self.commandControl = [[ UISegmentedControl alloc ] initWithItems:@[ @"forward", @"turn", @"leftArc", @"rightArc", @"up" ]];
    self.commandControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [ self.commandControl addTarget:self action:@selector(commmandSelected:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.commandControl ];
    
    self.valueSlider0 = [ RoundedUISlider new ];
    [ self.valueSlider0 addTarget:self action:@selector(sliderValueChanged0:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.valueSlider0 ];
    
    self.valueSlider1 = [ RoundedUISlider new ];
    [ self.valueSlider1 addTarget:self action:@selector(sliderValueChanged1:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.valueSlider1 ];
    
    [ self selectCommmandAtIndex: -1 ];
    
    [ self initPath ];
}


-(void)initPath
{
    self.path = [ TurtleBezierPath new ];
    [ self.path home ];
    self.path.lineWidth = 2.0f;
    self.path.lineCapStyle = kCGLineCapRound;
    self.previewPath = [ self.path copy ];
}

#pragma mark - Layout

-(void)layoutViews
{
    self.commandLabel.frame = CGRectMake( 0.0f, 20.0f, self.view.bounds.size.width, self.commandLabel.font.pointSize * 1.5f );
    
    self.valueSlider0.frame  = self.valueSlider1.frame = CGRectMake( 0.0, 0.0, self.commandControl.bounds.size.width, self.valueSlider0.bounds.size.height );
    
    CGFloat originY = self.view.bounds.size.height;
    
    for( UIView *view in @[ self.valueSlider1, self.valueSlider0, self.commandControl ])
    {
        view.frame = CGRectMake(( self.view.bounds.size.width - view.bounds.size.width ) / 2.0f, originY - view.bounds.size.height, view.bounds.size.width, view.bounds.size.height );
        
        originY = view.frame.origin.y;
    }
    
    [ self positionPointer ];
}

/*
#pragma mark - UIResponder

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"Shaking!!!");
        
        [ self initPath ];
        
        self.commandControl.selectedSegmentIndex = -1;
        
        [ self selectCommmandAtIndex:-1 ];
    }
}
*/


#pragma mark - Controls

-(void)commmandSelected:(id)sender
{
    [ self selectCommmandAtIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged0:(id)sender
{
    [ self updateCommandForIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged1:(id)sender
{
   [ self updateCommandForIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)setupSlidersForIndex:(NSInteger)index
{
    self.valueSlider0.hidden = !( index >= 0 && index < 4 );
    self.valueSlider1.hidden = !( index > 1 && index < 4 );
    
    self.valueSlider0.value = 0.0f;
    self.valueSlider1.value = ( index > 1 ) ? 90.0f : 0.0f;
    self.valueSlider0.maximumValue = ( index == 1 ) ? 360.0f : 100.0f;
    self.valueSlider1.maximumValue = 360.0f;
    
    self.valueSlider0.rounding = ( index == 1 ) ? 5.0f : 1.0f;
    self.valueSlider1.rounding = 5.0f;
}

#pragma mark - Undo

-(void)performUndo:(id)object
{
    self.canvasView.path = (TurtleBezierPath *)object;
}


#pragma mark - Pointer

-(void)positionPointer
{
    TurtleBezierPath *pointerPath = [ self.previewPath copy ];
    [ pointerPath centreInBounds:self.view.bounds ];
    [ self.pointerView positionPointerOnPath:pointerPath ];
}

-(void)selectCommmandAtIndex:(NSInteger)index
{
    //[ self.undoManager registerUndoWithTarget:self selector:@selector(performUndo:) object:self.previewPath ];
    
    self.path = self.previewPath;
    
    [ self setupSlidersForIndex:index ];
    
    [ self updateCommandForIndex:index ];
}


-(TurtleDemoState *)currentState
{
    return [[ TurtleDemoState alloc ] initWithIndex:self.commandControl.selectedSegmentIndex path:self.previewPath value0:self.valueSlider0.value value1:self.valueSlider1.value ];
}

-(void)setState:(TurtleDemoState *)state
{
    
}


-(void)updateCommandForIndex:(NSInteger)index
{
    if( index >= 0 )
    {
        NSString *commandTitle = [ self.commandControl titleForSegmentAtIndex:index ];
        self.commandLabel.text = [ self commandStringForIndex:index title:commandTitle value0:self.valueSlider0.value value1:self.valueSlider1.value ];
    }
    
    self.previewPath = [ self.path copy ];
    
    [ self drawCommandForIndex:index value0:self.valueSlider0.value value1:self.valueSlider1.value ontoPath:self.previewPath ];
    
    self.canvasView.path = self.previewPath;
    
    [ self positionPointer ];
    
    NSString *downUp = ( self.previewPath.penUp ) ? @"down" : @"up";
    [ self.commandControl setTitle:downUp forSegmentAtIndex:4 ];
}


#pragma mark - Turtle Commands

-(NSString *)commandStringForIndex:(NSInteger)index title:(NSString *)title value0:(CGFloat)value0 value1:(CGFloat)value1
{
    if( index < 0 )
    {
        return nil;
    }
    else if( index < 2 )
    {
        return [ NSString stringWithFormat:@"[ path %@:%g ]", title, value0 ];
    }
    else if( index < 4 )
    {
        return [ NSString stringWithFormat:@"[ path %@:%g turn:%g ]", title, value0, value1 ];
    }
    else
    {
        return [ NSString stringWithFormat:@"[ path %@ ]", title ];
    }
}

-(void)drawCommandForIndex:(NSInteger)index value0:(CGFloat)value0 value1:(CGFloat)value1 ontoPath:(TurtleBezierPath *)path
{
    if( index == 0 && value0 > 0.0f )
    {
        [ path forward:value0 ];
    }
    else if( index == 1 && value0 > 0.0f )
    {
        [ path turn:value0 ];
    }
    else if( index == 2 && value0 > 0.0f && value1 > 0.0f )
    {
        [ path leftArc:value0 turn:value1 ];
    }
    else if( index == 3 && value0 > 0.0f && value1 > 0.0f )
    {
        [ path rightArc:value0 turn:value1 ];
    }
    else if( index == 4 )
    {
        if( path.penUp )
        {
            [ path down ];
        }
        else
        {
            [ path up ];
        }
    }
}

@end
