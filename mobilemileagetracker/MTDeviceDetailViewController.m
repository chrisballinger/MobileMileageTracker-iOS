//
//  MTDeviceDetailViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDeviceDetailViewController.h"
#import "MTObjectStore.h"

@implementation MTDeviceDetailViewController
@synthesize nameTextField;
@synthesize typeTextField;
@synthesize UUIDTextField;
@synthesize device;

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
    if(device)
    {
        self.title = device.name;
    }
    else
    {
        self.title = @"New Device";
        device = [[MTDevice deviceWithName:@""] retain];
    }
    
    nameTextField.text = device.name;
    typeTextField.text = device.deviceType;
    UUIDTextField.text = device.uuid;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setTypeTextField:nil];
    [self setUUIDTextField:nil];
    [self setDevice:nil];
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
    [typeTextField release];
    [UUIDTextField release];
    [device release];
    [super dealloc];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)savePressed:(id)sender 
{
    if([nameTextField.text isEqualToString:@""] || [typeTextField.text isEqualToString:@""] || [UUIDTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Information Required" message:@"Please fill in all of the fields and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    else
    {
        device.name = nameTextField.text;
        device.deviceType = typeTextField.text;
        device.uuid = UUIDTextField.text;
        
        //NSError *error = [[[RKObjectManager sharedManager] objectStore] save];
        //if(error)
        //    NSLog(@"Error saving device: %@", error);
        MTObjectStore *objectStore = [MTObjectStore sharedInstance];
        
        [objectStore.objectManager postObject:device delegate:objectStore];
        
        [objectStore.objectManager.objectStore.managedObjectContext deleteObject:device];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
