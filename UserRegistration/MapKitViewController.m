//
//  MapKitViewController.m
//  UserRegistration
//
//  Created by AMIT KISHNANI on 9/22/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "MapKitViewController.h"

@interface MapKitViewController ()

@end

@implementation MapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // start by locating user's current position
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mapKitView addGestureRecognizer:tapRecognizer];
}


-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.mapKitView];
    CLLocationCoordinate2D tapPoint = [self.mapKitView convertPoint:point toCoordinateFromView:self.view];
    

   
    NSString* urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=66484ecf39e6f8649b900d6015e87014&&units=imperial", tapPoint.latitude, tapPoint.longitude];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                
                NSString *jsonResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"http response=%@", jsonResponseString);
                
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];

                //get the main dictionary
                NSDictionary* main = [json objectForKey:@"main"];
                
                //get the temp
                MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
                point1.coordinate = tapPoint;
                NSNumber* tempNum = [main objectForKey:@"temp"];
                NSString* tempStr = [tempNum stringValue];
                point1.title = tempStr;
                point1.subtitle = tempStr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapKitView addAnnotation:point1];
                });
            }
        }
    }];
    [downloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    @try {
        // remember for later the user's current location
        self.userLocation = newLocation.coordinate;
        
        //set the region
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation, 800, 800);
        
        [self.mapKitView setRegion:region];
        
        //add an annotation to the map
        MKPointAnnotation* point = [[MKPointAnnotation alloc] init];
        [point setCoordinate:self.userLocation];
        [self.mapKitView addAnnotation:point];
        
        [manager stopUpdatingLocation]; // we only want one update
        
        manager.delegate = nil;         // we might be called again here, even though we
        // called "stopUpdatingLocation", remove us as the delegate to be sure
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",[exception reason]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
}

@end
