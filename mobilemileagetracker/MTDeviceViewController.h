//
//  MTDeviceViewController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTObjectStore.h"

@interface MTDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *deviceTableView;
@property (nonatomic, retain) MTObjectStore *objectStore;

@end
