//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "StationsListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DivvyStation.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *bikes;
@property MKPointAnnotation *divvyAnnotation;
@property CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
        double longitude = self.divvyStation.longitude.doubleValue;
        double latitude = self.divvyStation.latitude.doubleValue;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = self.divvyStation.name;

        [self.mapView addAnnotation:annotation];
    
    MKMapRect zoom = MKMapRectNull;
    MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect rect = MKMapRectMake(point.x, point.y, 0.05, 0.05);
    
    zoom = MKMapRectUnion(zoom, rect);
    
    [self.mapView setVisibleMapRect:zoom animated:YES];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.showsUserLocation = YES;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pin =[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    pin.image = [UIImage imageNamed:@"bikeImage"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CLLocationCoordinate2D centercoordinate = view.annotation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    MKCoordinateRegion region;
    region.center = centercoordinate;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *anno = mapView.annotations[0];
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:anno.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placemark];
    
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = mapItem;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSArray *s = response.routes;
        MKRoute *r = s.firstObject;
        int x = 1;
        NSMutableString *direct = [NSMutableString string];
        for (MKRouteStep *step in r.steps) {
            NSLog(@"%@", step.instructions);
            [direct appendFormat:@"%d: %@\n", x, step.instructions];
            x++;
}
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Directions" message:direct delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }];
}


@end
