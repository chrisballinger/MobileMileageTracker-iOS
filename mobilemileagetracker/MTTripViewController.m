//
//  MTDeviceViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTripViewController.h"
#import "MTAccountController.h"
#import "ASIHTTPRequest.h"
#import "MTTrip.h"
#import "MTTripDetailViewController.h"

@implementation MTTripViewController
@synthesize tripTableView;
@synthesize objectStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Trips";
        objectStore = [MTObjectStore sharedInstance];
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
        [MTTrip loadObjectsWithDelegate:self];
        [self objectLoader:nil didLoadObjects:[MTTrip cachedObjects]];
        
        /*ASIFormDataRequest *request = [MTAPIObject requestWithURL:[MTTrip RESTurl] filters:nil];
        [request setDelegate:self];
        [request startAsynchronous];*/
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    [objectStore addObjects:objects];  
    [tripTableView reloadData];
    NSLog(@"Added trips to objectstore");  
    for(MTTrip *trip in objects)
    {
        NSLog(@"added %@",trip.name);
    }
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}  


- (void)viewDidUnload
{
    [self setTripTableView:nil];
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
    [tripTableView release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[objectStore getTrips] count] + 1;   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
    NSDictionary *trips = [objectStore getTrips];
    if(indexPath.row < [trips count])
    {
        NSArray *allTrips = [trips allValues];
        MTTrip *trip = [allTrips objectAtIndex:indexPath.row];
        cell.textLabel.text = trip.name;
        cell.detailTextLabel.text = trip.device.name;
    }
    if(indexPath.row == [trips count])
    {
        cell.textLabel.text = @"Add New Trip";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *trips = [objectStore getTrips];
    MTTrip *trip = nil;
    if(indexPath.row < [trips count])
    {
        NSArray *allTrips = [trips allValues];
        trip = [allTrips objectAtIndex:indexPath.row];
    }
    MTTripDetailViewController *tripDetailController = [[MTTripDetailViewController alloc] init];
    tripDetailController.trip = trip;
    [self.navigationController pushViewController:tripDetailController animated:YES];
    [tripDetailController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
