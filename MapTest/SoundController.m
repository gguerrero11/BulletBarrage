//
//  SoundController.m
//  SoundController
//
//  Created by Caleb Hicks on 11/18/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SoundController.h"

@interface SoundController() <AVAudioPlayerDelegate>

@property (strong,nonatomic) NSMutableArray *mArrayOfAudioPlayers;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;

@property (strong, nonatomic) NSURL *lastRecordedFile;

@end

@implementation SoundController

+ (SoundController *) sharedInstance {
    static SoundController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SoundController new];
    });
    return sharedInstance;
}


- (void)recordAudioToTemporaryDirectoryWithLength:(CGFloat)length {
    
    // set up the temporary directory to save the audio file
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"file.m4a"];
    NSURL *localURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    
    // some settings (low quality)
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 11025],                    AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless],  AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                          AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMedium],          AVEncoderAudioQualityKey,
                              nil];
    
    // create a AVAudioRecorder
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:localURL settings:settings error:&error];
    
    // record for 5 seconds
    [self.recorder recordForDuration:length];
    
    self.lastRecordedFile = localURL;
}

- (void)recordAudioToURL:(NSURL *)url withLength:(CGFloat)length {
    
    // set up specific url so we can play it back later
    NSURL *localURL = url;
    self.lastRecordedFile = localURL;
    
    // some settings
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 11025],                    AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless],  AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                          AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMin],          AVEncoderAudioQualityKey,
                              nil];
    
    // create an AVAudioRecorder
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:localURL settings:settings error:&error];
    
    // record for 5 seconds
    [self.recorder recordForDuration:length];
    
}

- (void)playSoundEffect:(NSString *)string {

    NSURL *urlForSFX = [[NSBundle mainBundle] URLForResource:string withExtension:@"caf"];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlForSFX error:nil];
    player.numberOfLoops = 0;
    [player play];
    [self.mArrayOfAudioPlayers addObject:player];
    
//    [SoundController sharedInstance].player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlForSFX error:nil];
//    [SoundController sharedInstance].player.numberOfLoops = 0;
//    [[SoundController sharedInstance].player play];
}

// removes the player once its done playing its sound file.
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.mArrayOfAudioPlayers removeObject:player];
}


- (void)playLastRecordedFile {
    [self playAudioFileAtURL:self.lastRecordedFile];
}

@end
