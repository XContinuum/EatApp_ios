//
//  ViewController.h
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
#import "UserSettings.h"
#import "MapView.h"

@interface ViewController : UIViewController
{
    IBOutlet UIScrollView* primaryScroller;
    IBOutlet UIScrollView* secondaryScroller;
}
@end

