//
//  ATMapKitViewController.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/3/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATMapViewController.h"

@interface ATMapViewController ()

@property (strong, nonatomic) NSTimer * callBackTimer;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *motionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPlaceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPlaceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLongitude;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLatitude;

- (void)updateStatesAndLocation;

@end

@implementation ATMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [Alohar setMotionDelegate:self];
    [Alohar setMobileStateDelegate:self];
    self.mapView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.callBackTimer =
    [NSTimer scheduledTimerWithTimeInterval:60
                                     target:self
                                   selector:@selector(updateStatesAndLocation)
                                   userInfo:nil
                                    repeats:YES];
    [self updateStatesAndLocation];
}

- (void)updateStatesAndLocation
{
    ALUserStay * userStay = [Alohar currentUserStay];
    self.currentLocation = [Alohar currentLocation];
    self.currentPlaceNameLabel.text = userStay.selectedPlace.name;
    self.currentPlaceAddressLabel.text = userStay.selectedPlace.address;
    self.currentLocationLatitude.text =
    [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    self.currentLocationLongitude.text =
    [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.longitude];
}

- (void)didUpdateToMobileState:(ALMobileState *)newMobileState fromMobileState:(ALMobileState *)oldMobileState
{
    ALMobileState * mobileState = [Alohar currentMobileState];
    self.mobileStateLabel.text = [mobileState stateDescription];
}

- (void)didUpdateToMotionState:(ALMotionState *)newMotionState fromMotionState:(ALMotionState *)oldMotionState
{
    ALMotionState * motionState = [Alohar currentMotionState];
    self.motionStateLabel.text = [motionState stateDescription];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
