//
//  MTDeviceViewController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import "MTObjectStore.h"

@interface MTDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>
@property (retain, nonatomic) IBOutlet UITableView *deviceTableView;
@property (nonatomic, retain) MTObjectStore *objectStore;

@property BOOL isChoosingDevice;

-(void)devicesLoaded;

@end
