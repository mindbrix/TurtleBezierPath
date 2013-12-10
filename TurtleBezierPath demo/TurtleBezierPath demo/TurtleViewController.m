//
//  TurtleViewController.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleViewController.h"

#import "TurtleCanvasView.h"
#import "TurtleBezierPath.h"


@interface TurtleViewController ()

@property( nonatomic, strong ) UISegmentedControl *commandControl;
@property( nonatomic, strong ) UILabel *commandLabel;
@property( nonatomic, strong ) TurtleCanvasView *demoView;

@property( nonatomic, strong ) TurtleBezierPath *path;
@property( nonatomic, strong ) TurtleBezierPath *previewPath;

@property( nonatomic, strong ) UISlider *valueSlider0;
@property CGFloat value0;

@property( nonatomic, strong ) UISlider *valueSlider1;
@property CGFloat value1;

@end

@implementation TurtleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.demoView = [[ TurtleCanvasView alloc ] initWithFrame:self.view.bounds ];
    self.demoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [ self.view addSubview:self.demoView ];
    
    [ self initDemoApp ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [ self layoutViews ];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [ self layoutViews ];
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
}


#pragma mark - Controls

-(void)commmandSelected:(id)sender
{
    [ self selectCommmandAtIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged0:(id)sender
{
    self.value0 = floorf( self.valueSlider0.value );
    
    [ self updateCommandForIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged1:(id)sender
{
    self.value1 = floorf( self.valueSlider1.value );
    
    [ self updateCommandForIndex:self.commandControl.selectedSegmentIndex ];
}


#pragma mark - Demo app

-(void)initDemoApp
{
    self.commandLabel = [ UILabel new ];
    self.commandLabel.font = [ UIFont fontWithName:@"Menlo-Regular" size:18.0f ];
    self.commandLabel.textAlignment = NSTextAlignmentCenter;
    self.commandLabel.textColor = [ UIColor blackColor ];
    self.commandLabel.text = @"commandLabel";
    [ self.view addSubview:self.commandLabel ];
    
    self.commandControl = [[ UISegmentedControl alloc ] initWithItems:@[ @"forward", @"turn", @"leftArc", @"rightArc" ]];
    [ self.commandControl addTarget:self action:@selector(commmandSelected:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.commandControl ];
    
    self.valueSlider0 = [ UISlider new ];
    [ self.valueSlider0 addTarget:self action:@selector(sliderValueChanged0:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.valueSlider0 ];
    
    self.valueSlider1 = [ UISlider new ];
    [ self.valueSlider1 addTarget:self action:@selector(sliderValueChanged1:) forControlEvents:UIControlEventValueChanged ];
    [ self.view addSubview:self.valueSlider1 ];
    
    [ self selectCommmandAtIndex: -1 ];
    
    self.path = [ TurtleBezierPath new ];
    [ self.path home ];
    self.path.lineWidth = 1.0f;
    
    self.previewPath = [ self.path copy ];
    
    self.demoView.strokeColour = [ UIColor blackColor ];
}

-(void)selectCommmandAtIndex:(NSInteger)index
{
    self.path = self.previewPath;
    
    self.valueSlider0.enabled = ( index >= 0 );
    self.valueSlider1.enabled = ( index > 1 );
    
    self.value0 = self.valueSlider0.value = 0.0f;
    self.value1 = self.valueSlider1.value = ( index > 1 ) ? 90.0f : 0.0f;
    self.valueSlider0.maximumValue = ( index == 1 ) ? 360.0f : 100.0f;
    self.valueSlider1.maximumValue = 360.0f;
    
    [ self updateCommandForIndex:index ];
}


-(void)updateCommandForIndex:(NSInteger)index
{
    [ self updateCommandLabelForIndex:index ];
    
    if( index < 0 )
    {
        return;
    }
    
    self.previewPath = [ self.path copy ];
    
    if( index == 0 && self.value0 > 0.0f )
    {
        [ self.previewPath forward:self.value0 ];
    }
    else if( index == 1 && self.value0 > 0.0f )
    {
        [ self.previewPath turn:self.value0 ];
    }
    else if( index == 2 && self.value0 > 0.0f && self.value1 > 0.0f )
    {
        [ self.previewPath leftArc:self.value0 turn:self.value1 ];
    }
    else if( index == 3 && self.value0 > 0.0f && self.value1 > 0.0f )
    {
        [ self.previewPath rightArc:self.value0 turn:self.value1 ];
    }
    
    self.demoView.path = self.previewPath;
    
}

-(void)updateCommandLabelForIndex:(NSInteger)index
{
    if( index < 0 )
    {
        self.commandLabel.text = nil;
        return;
    }
    
    NSString *commandTitle = [ self.commandControl titleForSegmentAtIndex:index ];
    
    if( index > 1 )
    {
        self.commandLabel.text = [ NSString stringWithFormat:@"[ path %@:%g turn:%g ]", commandTitle, self.value0, self.value1 ];
    }
    else
    {
        self.commandLabel.text = [ NSString stringWithFormat:@"[ path %@:%g ]", commandTitle, self.value0 ];
    }
}


#pragma mark - Demo pattern

-(void)drawDemoPattern
{
    self.demoView.fillColour = [ UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f ];
    self.demoView.strokeColour = [ UIColor whiteColor ];
    self.demoView.path = [ self demoPath ];
}


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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
