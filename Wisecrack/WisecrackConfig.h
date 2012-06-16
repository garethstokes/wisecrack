//
//  WisecrackConfig.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WisecrackConfig : NSObject {
    NSMutableData *_receivedData;
}

@property (nonatomic) int order;
@property (nonatomic) int version;

@property (nonatomic) int waveLength;
@property (nonatomic) int gameWords;
@property (nonatomic) int gameColours;

@property (nonatomic) int bonusRespawn;
@property (nonatomic) int chanceBonus;
@property (nonatomic) int chanceBrick;

@property (nonatomic) float buttonLoadDelay;
@property (nonatomic) float buttonLoadDuration;

@property (nonatomic) float buttonRemoveDelay;
@property (nonatomic) float buttonRemoveDuration;

- (id) init:(int)o;
- (void) parse:(NSData *)data;
- (void) persist;

+ (WisecrackConfig *) config;
@end

@interface WisecrackConfigSet : NSObject {
    NSMutableData * _receivedData;
}

@property (nonatomic) int wave;
@property (nonatomic) int version;

@property (nonatomic, retain) WisecrackConfig * one;
@property (nonatomic, retain) WisecrackConfig * two;
@property (nonatomic, retain) WisecrackConfig * three;

- (WisecrackConfig *) current;
- (void) updateFromServer;
- (void) incrementWave;
- (void) resetWave;

+ (WisecrackConfigSet *) configSet;

@end
