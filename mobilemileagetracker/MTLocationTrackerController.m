//
//  MTLocationTrackerController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTLocationTrackerController.h"
#import "MTLocation.h"
#import "MTTripViewController.h"
#import "LocationController.h"
#import "APIUtil.h"

@implementation MTLocationTrackerController
@synthesize trackerTableView;
@synthesize tripButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Track";
        //self.tabBarItem.image = [UIImage imageNamed:@"08-chat.png"];
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
    objectStore = [MTObjectStore sharedInstance];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(tripChosen:) name:@"TripChosenNotification" object:nil];
    [center addObserver:self selector:@selector(locationUpdated:) name:@"LocationUpdateNotification" object:nil];
    
    trackButton = [[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(trackPressed)] retain];
    stopButton = [[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(stopPressed)] retain];
    [self.navigationItem setRightBarButtonItem: trackButton];
}

-(void)trackPressed
{
    if(trip)
    {
        LocationController *locController = [LocationController sharedInstance];
        locController.delegate = self;
        [locController.locationManager startUpdatingLocation];
        [self.navigationItem setRightBarButtonItem: stopButton];
        tripButton.enabled = NO;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trip Not Selected" message:@"Please select a trip to begin tracking." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

}

-(void)stopPressed
{
    LocationController *locController = [LocationController sharedInstance];
    [locController.locationManager stopUpdatingLocation];
    [self.navigationItem setRightBarButtonItem: trackButton];
    tripButton.enabled = YES;
}

-(void)locationUpdated:(NSNotification *)notification
{
    if(trip)
    {
        NSLog(@"background listener");
        CLLocation *location = [[notification userInfo] objectForKey:@"location"];
        [self locationUpdate:location];
    }

}

- (void)locationUpdate:(CLLocation*)location
{
    if(location)
    {
        if(location.horizontalAccuracy <= kCLLocationAccuracyHundredMeters && location.horizontalAccuracy >= 0)
        {
            MTLocation *newLocation = [MTLocation locationWithLocation:location];
            newLocation.trip = trip;
            
            
            [objectStore.objectManager postObject:newLocation delegate:objectStore];
            
            /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[APIUtil RESTurlString],kAPIURLLocationSuffix]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request appendPostData:[newLocation toJSON]];
            [request setDelegate:self];
            [request startAsynchronous];*/
            
            [objectStore.objectManager.objectStore.managedObjectContext deleteObject:newLocation];
            
            NSLog(@"Location update: %f, %f",location.coordinate.latitude, location.coordinate.longitude);
        }
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%d: %@", [request responseStatusCode], [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%d: %@", [request responseStatusCode], [request responseString]);
}

- (void)locationError:(NSError *)error
{
    NSLog(@"Location error: %@",[error description]);
}

-(void)tripChosen:(NSNotification*)notification
{
    trip = [[notification userInfo] objectForKey:@"trip"];
    [tripButton setTitle:trip.name forState: UIControlStateNormal];
    
    locations = [objectStore locationsForTrip:trip];
    
    if(!locations)
        locations = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    
    [trackerTableView reloadData];
}

- (IBAction)selectTripPressed:(id)sender 
{
    
    MTTripViewController *tripController = [[MTTripViewController alloc] init];
    tripController.isChoosingTrip = YES;
    [self.navigationController pushViewController:tripController animated:YES];
}


- (void)viewDidUnload
{
    [self setTrackerTableView:nil];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    [self setTripButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
    MTLocation *location = [locations objectAtIndex:indexPath.row];
    
    NSString *textLabel = [NSString stringWithFormat:@"%f, %f",[location.latitude floatValue], [location.longitude floatValue]];
    
    cell.textLabel.text = textLabel;
    cell.detailTextLabel.text = [location.timestamp description];
    
	return cell;
}

- (void)dealloc {
    [trackerTableView release];
    [tripButton release];
    [super dealloc];
}
@end
