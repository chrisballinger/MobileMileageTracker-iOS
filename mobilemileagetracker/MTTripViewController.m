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
@synthesize isChoosingTrip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Trips";
        
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
    
    if(isChoosingTrip)
        self.title = @"Choose Trip";
    else
        self.title = @"Trips";
    
    objectStore = [MTObjectStore sharedInstance];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(tripsLoaded) name:kObjectsLoadedNotificationName object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"username"] || ![defaults objectForKey:@"password"])
    {
        MTAccountController *accountController = [[MTAccountController alloc] init];
        accountController.isModal = YES;
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

-(void)tripsLoaded
{
    [tripTableView reloadData];
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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
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
    if(!isChoosingTrip)
        return [[objectStore getTrips] count] + 1;
    else
        return [[objectStore getTrips] count];
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
    if(indexPath.row == [trips count] && !isChoosingTrip)
    {
        cell.textLabel.text = @"Add New Trip";
    }
    
    if(!isChoosingTrip)
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
    
    if(isChoosingTrip)
    {
        if(!trip)
            NSLog(@"device is nil!");
        
        NSMutableDictionary *tripInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
        [tripInfo setObject:trip forKey:@"trip"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TripChosenNotification" object:nil userInfo:tripInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        MTTripDetailViewController *tripDetailController = [[MTTripDetailViewController alloc] init];
        tripDetailController.trip = trip;
        [self.navigationController pushViewController:tripDetailController animated:YES];
        [tripDetailController release];

    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
