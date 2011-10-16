//
//  MTMapViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTMapViewController.h"
#import "LocationController.h"

@implementation MTMapViewController
@synthesize locationMapView;

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
    // Do any additional setup after loading the view from its nib
    
    self.title = @"Map";
    
    
    CLLocationCoordinate2D location;
    location.latitude = 37.250556;
    location.longitude = -96.358333;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 1.04*(126.766667 - 66.95) ;
    span.longitudeDelta = 1.04*(49.384472 - 24.520833) ;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location;
    
    [locationMapView setRegion:region animated:NO];
    
    [locationMapView regionThatFits:region];
    
    //PlaceAnnotation *someAnnotation = [[[PlaceAnnotation alloc] initWithLatitude:37.786521 longitude:-122.397850 ] autorelease];
    
    //[currentMapView addAnnotation:someAnnotation];
    
    /*[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationUpdate:)
     name:@"LocationUpdateNotification"
     object:nil ];*/
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
    /*if (annotation == mapView.userLocation) { 
        return nil; 
    }*/
    return nil;
}

- (void)viewDidUnload
{
    [self setLocationMapView:nil];
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
    [locationMapView release];
    [super dealloc];
}
@end
