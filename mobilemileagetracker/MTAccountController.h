//
//  MTAccountController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAccountController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *accountTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginPressed:(id)sender;

@property BOOL isModal;

@end
