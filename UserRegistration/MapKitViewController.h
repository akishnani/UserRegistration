//
//  MapKitViewController.h
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/22/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapKitViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapKitView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) CLLocationCoordinate2D userLocation;

@end
