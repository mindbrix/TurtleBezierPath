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
    
    self.commandLabel = [ UILabel new ];
    self.commandLabel.font = [ UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f ];
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


-(void)layoutViews
{
    self.commandLabel.frame = CGRectMake( 0.0f, 20.0f, self.view.bounds.size.width, self.commandLabel.font.pointSize * 1.5f );
    
    self.commandControl.center = CGPointMake( self.view.bounds.size.width / 2.0f, self.view.bounds.size.height - 80.0f );
    
    CGRect valueSliderFrame = self.commandControl.frame;
    valueSliderFrame.origin.y = CGRectGetMaxY( self.commandControl.frame );
    self.valueSlider0.frame = valueSliderFrame;
    
    valueSliderFrame.origin.y = CGRectGetMaxY( self.valueSlider0.frame );
    self.valueSlider1.frame = valueSliderFrame;
}


#pragma mark - Controls

-(void)commmandSelected:(id)sender
{
    [ self selectCommmandAtIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged0:(id)sender
{
    self.value0 = floorf( self.valueSlider0.value );
    
    [ self updateCommandLabelForIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)sliderValueChanged1:(id)sender
{
    self.value1 = floorf( self.valueSlider1.value );
    
    [ self updateCommandLabelForIndex:self.commandControl.selectedSegmentIndex ];
}

-(void)selectCommmandAtIndex:(NSInteger)index
{
    self.valueSlider0.enabled = ( index >= 0 );
    self.valueSlider1.enabled = ( index > 1 );
    
    self.valueSlider0.value = self.valueSlider1.value = 0.0f;
    
    self.valueSlider0.maximumValue = ( index == 1 ) ? 360.0f : 100.0f;
    self.valueSlider1.maximumValue = 360.0f;
    
    [ self updateCommandLabelForIndex:index ];
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
        self.commandLabel.text = [ NSString stringWithFormat:@"%@:%g turn:%g", commandTitle, self.value0, self.value1 ];
    }
    else
    {
        self.commandLabel.text = [ NSString stringWithFormat:@"%@:%g", commandTitle, self.value0 ];
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
