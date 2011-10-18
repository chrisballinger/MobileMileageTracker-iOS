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
#import "MTMapViewController.h"

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
    stopButton = [[[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopPressed)] retain];
    [self.navigationItem setRightBarButtonItem: trackButton];
}

-(void)loadLocations
{
    [self objectLoader:nil didLoadObjects:[MTLocation cachedObjects]];
    [MTLocation loadObjectsWithDelegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    /*[objectStore addObjects:objects];  

    NSLog(@"Added locations to objectstore");  
    for(MTLocation *location in objects)
    {
        NSLog(@"added %f, %f",[location.latitude doubleValue],[location.longitude doubleValue]);
    }
    locations = [objectStore locationsForTrip:trip];
    
    if(locations && [locations count] > 0)
    {
        NSLog(@"raw vs fetched locations count: %d / %d", [objects count], [locations count]);
        [trackerTableView reloadData];
    }*/
    if(locations)
        [locations release];
    locations = objects;
    [locations retain];
    [trackerTableView reloadData];
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}

-(void)trackPressed
{
    if(trip)
    {
        LocationController *locController = [LocationController sharedInstance];
        //locController.delegate = self;
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

- (IBAction)mapPressed:(id)sender {
    MTMapViewController *mapView = [[MTMapViewController alloc] init];
    [self.navigationController pushViewController:mapView animated:YES];
    [mapView release];
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
            
            
            // RESTKIT WHY DONT YOU WORK WHEN RUNNING IN THE BACKGROUND?!?!?!
            //[objectStore.objectManager postObject:newLocation delegate:objectStore];
            [objectStore.objectManager postObject:newLocation delegate:objectStore block:^(RKObjectLoader* loader) {
                loader.backgroundPolicy = RKRequestBackgroundPolicyContinue;
            }];
            
            /*
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[APIUtil RESTurlString],kAPIURLLocationSuffix]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request setUsername:[defaults objectForKey:@"username"]];
            [request setPassword:[defaults objectForKey:@"password"]];
            [request appendPostData:[newLocation toJSON]];
            [request setDelegate:self];
            [request startAsynchronous];
            */
            
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
    trip = [[[notification userInfo] objectForKey:@"trip"] retain];
    [tripButton setTitle:trip.name forState: UIControlStateNormal];
    
    [self objectLoader:nil didLoadObjects:[MTLocation cachedObjects]];
    [MTLocation loadObjectsWithDelegate:self];
    locations = [objectStore locationsForTrip:trip];
    
    //if(!locations)
    //    locations = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    
    [trackerTableView reloadData];
    

    
    // timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadLocations) userInfo:nil repeats:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView 
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(locations)
        return [locations count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
    if(locations)
    {
        MTLocation *location = [locations objectAtIndex:indexPath.row];
        
        NSString *textLabel = [NSString stringWithFormat:@"%f, %f",[location.latitude floatValue], [location.longitude floatValue]];
        
        cell.textLabel.text = textLabel;
        cell.detailTextLabel.text = [location.timestamp description];
        NSLog(@"location id: %@ trip: %@",location.resourceID,location.trip.name);
        return cell;
    }
    return nil;
}

- (void)dealloc {
    [trackerTableView release];
    [tripButton release];
    [super dealloc];
}
@end
