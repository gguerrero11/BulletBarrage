//
//  SoundController.h
//  SoundController
//
//  Created by Caleb Hicks on 11/18/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString * const bombExplosion = @"bombExplosion";
static NSString * const missleImpact = @"missleImpact";

@interface SoundController : NSObject

+ (SoundController *) sharedInstance;

- (void)recordAudioToTemporaryDirectoryWithLength:(CGFloat)length;
- (void)recordAudioToURL:(NSURL *)url withLength:(CGFloat)length;

- (void)playSoundEffect:(NSString *)string;

- (void)playAudioFileAtURL:(NSURL *)url;
- (void)playLastRecordedFile;


@end
