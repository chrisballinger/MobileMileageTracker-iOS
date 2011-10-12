//
//  MTTripDetailViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTripDetailViewController.h"
#import "MTDevice.h"
#import "MTDeviceViewController.h"

@implementation MTTripDetailViewController
@synthesize nameTextField;
@synthesize chooseDeviceButton;
@synthesize trip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceChosen:) name:@"DeviceChosenNotification" object:nil];
    
    if(trip)
    {
        self.title = trip.name;
        [chooseDeviceButton setTitle:trip.device.name forState: UIControlStateNormal];
    }
    else
    {
        self.title = @"New Trip";
        trip = [[MTTrip tripWithName:@"" device:nil] retain];
    }
    
    nameTextField.text = trip.name;
}



- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setChooseDeviceButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [nameTextField release];
    [chooseDeviceButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (IBAction)chooseDevicePressed:(id)sender 
{
    MTDeviceViewController *deviceController = [[MTDeviceViewController alloc] init];
    deviceController.isChoosingDevice = YES;
    [self.navigationController pushViewController:deviceController animated:YES];
}

- (void)deviceChosen:(NSNotification *)notification
{
    NSLog(@"Device chosen");
    MTDevice *device = [notification.userInfo objectForKey:@"device"];
    trip.device = device;
    [chooseDeviceButton setTitle:trip.device.name forState: UIControlStateNormal];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
    
- (IBAction)savePressed:(id)sender
{
    if(!trip.device || [nameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Information Required" message:@"Please fill in all of the fields and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    else
    {
        trip.name = nameTextField.text;
        
        //NSError *error = [[[RKObjectManager sharedManager] objectStore] save];
        //if(error)
        //    NSLog(@"Error saving device: %@", error);
        MTObjectStore *objectStore = [MTObjectStore sharedInstance];
        
        
        [objectStore.objectManager postObject:trip delegate:objectStore];
        
        [objectStore.objectManager.objectStore.managedObjectContext deleteObject:trip];
    }
}

@end
