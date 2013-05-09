//
//  ATRealTimeViewController.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/8/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATRealTimeViewController.h"

@interface ATRealTimeViewController ()
@property (strong, nonatomic) NSTimer * callBackTimer;
@property (weak, nonatomic) IBOutlet UILabel *motionStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileStateLabel;
@property(nonatomic,retain)NSString *wordToSpeech;
@property(nonatomic,retain)AVAudioPlayer *player;
@property(nonatomic,assign)int totalCountPlayed;

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
    [self updateStates];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.callBackTimer =
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(updateStates)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateStates
{
//    [self speechUsingGoogleTTS:@"test"];
}

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
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:
                       [NSURL fileURLWithPath:path] error:&err];
        [self.player prepareToPlay];
        [self.player setNumberOfLoops:0];
        [self.player play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
