//
//  SearchView.h
//  EatApp
//
//  Created by Michel Balamou on 2016-02-28.
//  Copyright © 2016 EatApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "HistoryCell.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SearchView : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    //Data
    NSMutableArray* product_name;
    NSMutableArray* restaurant_name;
    NSMutableArray* prices;
    NSMutableArray* images;
    NSMutableArray* distances;

    //Coordinates
    NSString* longitude;
    NSString* latitude;
    
    float initY;
    float intiHeight;
    
    //
    NSArray* searchHistory;
    bool resultsFinalized;
}

/* Standard Controls */
@property (weak, nonatomic) IBOutlet UITextField* searchQuery;
@property (strong, nonatomic) IBOutlet UIImageView* logoImage;
@property (strong, nonatomic) IBOutlet UIView* DecorView;
@property (strong, nonatomic) IBOutlet UIView* notFound;

@property (strong, nonatomic) IBOutlet UIView* secondaryView;

@property (strong, nonatomic) IBOutlet UIView* blurView;
@property (strong, nonatomic) IBOutlet UITableView* searchOutput;
@property (strong, nonatomic) IBOutlet UITableView* historyOutput;

/**/
@property (strong, nonatomic) IBOutlet UIView* loadingView;

/* Functions */
- (BOOL)textFieldShouldReturn:(UITextField*)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event;

- (void)clearTextField:(id)sender;

/* Table */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/* Connection */
- (void)sendSearchRequest:(NSString*)search;

- (void)addToHistory:(NSString*)search;
- (NSArray*)retriveHistory;
@end
