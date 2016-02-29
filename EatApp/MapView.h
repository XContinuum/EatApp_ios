//
//  MapView.h
//  EatApp
//
//  Created by Michel Balamou on 2016-02-29.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapView : UIViewController <CLLocationManagerDelegate>
{    
    CLLocationManager *locationManager;
    NSString* longitude;
    NSString* latitude;
    
    bool update_once;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapViewer;
@property (strong, nonatomic) void (^onUpSwitch)(void);

- (IBAction)switchToSearch:(id)sender;
@end
