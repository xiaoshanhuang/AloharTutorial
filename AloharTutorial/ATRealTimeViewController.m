//
//  ATRealTimeViewController.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/8/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATRealTimeViewController.h"
#import <Alohar/Alohar.h>
#import <AVFoundation/AVFoundation.h>
#import "CMMotionManager+Shared.h"

@interface ATRealTimeViewController () <ALMobileStateDelegegate, ALMotionDelegate, ALUserStayDelegate>

@property (strong, nonatomic) NSTimer * callBackTimer;
@property (weak, nonatomic) IBOutlet UILabel *motionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerZLabel;
@property(strong, nonatomic) NSString *wordToSpeech;
@property(strong, nonatomic) AVAudioPlayer *player;
@property(nonatomic,assign) int totalCountPlayed;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
    [self updateStates];
    [self startMotionUpdate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
    [self stopMotionUpdate];
}

#pragma mark - NSTimer

- (void)startTimer
{
    self.callBackTimer =
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(updateStates)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)stopTimer
{
    [self.callBackTimer invalidate];
    self.callBackTimer = nil;
}

- (void)updateStates
{
//    [self speechUsingGoogleTTS:@"test"];
    ALMotionState * motionState = [Alohar currentMotionState];
    self.motionStateLabel.text = [motionState stateDescription];
    [self speechUsingGoogleTTS:[motionState stateDescription]];
}

#pragma mark - Core Motion
#define ACC_FS 10.0

- (void)startMotionUpdate
{
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    if ([motionManager isAccelerometerAvailable]) {
        [motionManager setAccelerometerUpdateInterval:1/ACC_FS];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
            self.accelerometerXLabel.text =
            [NSString stringWithFormat:@"%f", data.acceleration.x];
            self.accelerometerYLabel.text =
            [NSString stringWithFormat:@"%f", data.acceleration.y];
            self.accelerometerZLabel.text =
            [NSString stringWithFormat:@"%f", data.acceleration.z];
        }];
    }
}

- (void)stopMotionUpdate
{
    [[CMMotionManager sharedMotionManager] stopAccelerometerUpdates];
}

#pragma mark - Alohar state update

- (void)didUpdateToMotionState:(ALMotionState *)newMotionState fromMotionState:(ALMotionState *)oldMotionState
{
    ALMotionState * motionState = [Alohar currentMotionState];
    self.motionStateLabel.text = [motionState stateDescription];
    [self speechUsingGoogleTTS:[motionState stateDescription]];
}

- (void)didUpdateToMobileState:(ALMobileState *)newMobileState fromMobileState:(ALMobileState *)oldMobileState
{
    ALMobileState * mobileState = [Alohar currentMobileState];
    self.mobileStateLabel.text = [mobileState stateDescription];
    [self speechUsingGoogleTTS:[mobileState stateDescription]];
}

#pragma mark - Gogole TTS

- (void)speechUsingGoogleTTS:(NSString *)sentenceToSpeeh
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"file.mp3"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=en&q=%@",sentenceToSpeeh];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    [data writeToFile:path atomically:YES];
    NSError *err;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
        [self.player prepareToPlay];
        [self.player setNumberOfLoops:0];
        [self.player play];
    }
}

@end


