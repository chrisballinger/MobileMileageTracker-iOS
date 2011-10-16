//
//  MTMapViewController.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MTMapViewController : UIViewController <MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *locationMapView;

@end
