//
//  MTDeviceViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDeviceViewController.h"
#import "MTAccountController.h"
#import "ASIHTTPRequest.h"
#import "MTDevice.h"
#import "MTDeviceDetailViewController.h"
#import "APIUtil.h"

@implementation MTDeviceViewController
@synthesize deviceTableView;
@synthesize objectStore;
@synthesize isChoosingDevice;

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
    if(isChoosingDevice)
        self.title = @"Choose Device";
    else
        self.title = @"Devices";
    objectStore = [MTObjectStore sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"username"] || ![defaults objectForKey:@"password"])
    {
        MTAccountController *accountController = [[MTAccountController alloc] init];
        [self.tabBarController presentModalViewController:accountController animated:animated];
        [accountController release];
    }
    else
    {
        
        [self objectLoader:nil didLoadObjects:[MTDevice cachedObjects]];
        //[MTDevice loadObjectsWithDelegate:self];
        
        
        /*ASIFormDataRequest *request = [MTAPIObject requestWithURL:[MTDevice RESTurl] filters:nil];
        [request setDelegate:self];
        [request startAsynchronous];*/
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    [objectStore addObjects:objects];  
    [deviceTableView reloadData];
    NSLog(@"Added objects to objectstore");  
    for(MTDevice *device in objects)
    {
        NSLog(@"added %@",device.name);
    }
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}  

- (void)viewDidUnload
{
    [self setDeviceTableView:nil];
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
    [deviceTableView release];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!isChoosingDevice)
        return [[objectStore getDevices] count] + 1;
    else
        return [[objectStore getDevices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
    NSDictionary *devices = [objectStore getDevices];
    if(indexPath.row < [devices count])
    {
        NSArray *allDevices = [devices allValues];
        MTDevice *device = [allDevices objectAtIndex:indexPath.row];
        cell.textLabel.text = device.name;
        cell.detailTextLabel.text = device.deviceType;
    }
    if(indexPath.row == [devices count] && !isChoosingDevice)
    {
        cell.textLabel.text = @"Add New Device";
    }
    
    if(!isChoosingDevice)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *devices = [objectStore getDevices];
    MTDevice *device = nil;
    if(indexPath.row < [devices count])
    {
        NSArray *allDevices = [devices allValues];
        device = [allDevices objectAtIndex:indexPath.row];
    }
    
    if(isChoosingDevice)
    {
        if(!device)
            NSLog(@"device is nil!");

        NSMutableDictionary *deviceInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
        [deviceInfo setObject:device forKey:@"device"];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChosenNotification" object:nil userInfo:deviceInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    
        MTDeviceDetailViewController *deviceDetailController = [[MTDeviceDetailViewController alloc] init];
        deviceDetailController.device = device;
        [self.navigationController pushViewController:deviceDetailController animated:YES];
        [deviceDetailController release];
        

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
