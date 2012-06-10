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

@property (nonatomic) int version;

@property (nonatomic) int gameWords;
@property (nonatomic) int gameColours;

@property (nonatomic) int chanceBonus;
@property (nonatomic) int chanceBrick;

@property (nonatomic) float buttonLoadDelay;
@property (nonatomic) float buttonLoadDuration;

@property (nonatomic) float buttonRemoveDelay;
@property (nonatomic) float buttonRemoveDuration;

- (void) parse:(NSData *)data;
- (void) update;
- (void) persist;

+ (WisecrackConfig *) config;

@end
