//
//  MTLocationTrackerController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTObjectStore.h"
#import "MTTrip.h"
#import "LocationController.h"

@interface MTLocationTrackerController : UIViewController <UITableViewDataSource, LocationControllerDelegate, RKRequestDelegate>
{
    MTObjectStore *objectStore;
    NSMutableArray *locations;
    MTTrip *trip;
    
    UIBarButtonItem *trackButton;
    UIBarButtonItem *stopButton;
}
@property (retain, nonatomic) IBOutlet UITableView *trackerTableView;
@property (retain, nonatomic) IBOutlet UIButton *tripButton;

-(void)tripChosen:(NSNotification*)notification;
-(void)locationUpdated:(NSNotification*)notification;


- (IBAction)selectTripPressed:(id)sender;
-(void)trackPressed;
-(void)stopPressed;
- (IBAction)mapPressed:(id)sender;

@end
