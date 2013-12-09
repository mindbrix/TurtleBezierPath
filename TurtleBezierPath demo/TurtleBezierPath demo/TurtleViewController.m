//
//  TurtleViewController.m
//  TurtleBezierPath demo
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//

#import "TurtleViewController.h"

#import "TurtleDemoView.h"

@interface TurtleViewController ()

@property( nonatomic, strong ) TurtleDemoView *demoView;

@end

@implementation TurtleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.demoView = [[ TurtleDemoView alloc ] initWithFrame:self.view.bounds ];
    self.demoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [ self.view addSubview:self.demoView ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
