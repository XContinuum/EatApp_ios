//
//  ViewController.m
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SearchView* A=[[SearchView alloc] initWithNibName:@"SearchView" bundle:nil];
    UserSettings* B=[[UserSettings alloc] initWithNibName:@"UserSettings" bundle:nil];
    MapView* C=[[MapView alloc] initWithNibName:@"MapView" bundle:nil];
    
    [self addChildViewController:A];
    [self addChildViewController:B];
    [self addChildViewController:C];
   
    
    [secondaryScroller addSubview:A.view];
    [A didMoveToParentViewController:self];
    
    [primaryScroller addSubview:B.view];
    [B didMoveToParentViewController:self];
    
    [secondaryScroller addSubview:C.view];
    [C didMoveToParentViewController:self];
    
    C.onUpSwitch=^(void){
       [secondaryScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    };
    
    //+++
    CGRect adminFrame=[A.view frame];
    adminFrame.origin.x=375;//adminFrame.size.width; MOD 2018
    adminFrame.size.height=800; // MOD 2018
    B.view.frame = adminFrame;
    
    //+++
    adminFrame=[A.view frame];
    adminFrame.origin.y=adminFrame.size.height;
    adminFrame.origin.y=667; // MOD 2018
    C.view.frame=adminFrame;
    
    //Size of the scroll view that contains the frames
    NSLog([NSString stringWithFormat:@"%.20f", self.view.frame.size.width]);
    NSLog([NSString stringWithFormat:@"%.20f", self.view.frame.size.height]);
    CGFloat scrollWidth=375; //self.view.frame.size.width; MOD 2018
    CGFloat scrollHeight=667; //self.view.frame.size.height; MOD 2018
    
    primaryScroller.contentSize=CGSizeMake(scrollWidth*2, scrollHeight); //CGSizeMake(scrollWidth*2, scrollHeight); MOD 2018
    secondaryScroller.contentSize=CGSizeMake(scrollWidth, scrollHeight*2);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
