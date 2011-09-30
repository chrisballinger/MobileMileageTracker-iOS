//
//  MTDeviceDetailViewController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTTrip.h"

@interface MTTripDetailViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) MTTrip *trip;
@property (retain, nonatomic) IBOutlet UIButton *chooseDeviceButton;

- (IBAction)chooseDevicePressed:(id)sender;
- (void)deviceChosen:(NSNotification *)notification;
- (IBAction)savePressed:(id)sender;


@end
