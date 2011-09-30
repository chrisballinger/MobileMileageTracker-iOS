//
//  MTDeviceDetailViewController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTDevice.h"

@interface MTDeviceDetailViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *typeTextField;
@property (retain, nonatomic) IBOutlet UITextField *UUIDTextField;
@property (nonatomic, retain) MTDevice *device;


- (IBAction)savePressed:(id)sender;


@end
