//
//  ATRealTimeViewController.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/8/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATRealTimeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ATRealTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *motionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileStateLabel;

@end

@implementation ATRealTimeViewController

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
    [Alohar setMotionDelegate:self];
    [Alohar setMobileStateDelegate:self];
    AudioServicesPlaySystemSound(1005);
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
    AudioServicesPlaySystemSound(1026);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
