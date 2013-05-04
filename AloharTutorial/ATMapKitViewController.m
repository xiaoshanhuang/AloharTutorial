//
//  ATMapKitViewController.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/3/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATMapKitViewController.h"

@interface ATMapKitViewController ()

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

@implementation ATMapKitViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.callBackTimer =
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(updateStatesAndLocation)
                                   userInfo:nil repeats:YES];
    [self updateStatesAndLocation];
}

- (void)updateStatesAndLocation
{
    ALMotionState * motionState = [Alohar currentMotionState];
    ALMobileState * mobileState = [Alohar currentMobileState];
    ALUserStay * userStay = [Alohar currentUserStay];
    self.currentLocation = [Alohar currentLocation];
    self.motionStateLabel.text = [motionState stateDescription];
    self.mobileStateLabel.text = [mobileState stateDescription];
    self.currentPlaceNameLabel.text = userStay.selectedPlace.name;
    self.currentPlaceAddressLabel.text = userStay.selectedPlace.address;
    self.currentLocationLatitude.text =
    [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    self.currentLocationLongitude.text =
    [[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.longitude];
}

- (void)didUpdateToMobileState:(ALMobileState *)newMobileState fromMobileState:(ALMobileState *)oldMobileState
{
    
}

- (void)didUpdateToMotionState:(ALMotionState *)newMotionState fromMotionState:(ALMotionState *)oldMotionState
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
