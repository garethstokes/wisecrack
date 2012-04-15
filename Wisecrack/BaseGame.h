//
//  BaseGame.h
//  Wisecrack
//
//  Created by Gareth Stokes on 15/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
#import "GameItem.h"

@interface BaseGame : NSObject {
    NSMutableArray *words;
    int numberOfWords;
    int wisecrackLength;
}

@property (nonatomic, retain) NSMutableArray* words;
@property (nonatomic) int numberOfWords;
@property (nonatomic) int wisecrackLength;

- (void) shuffle;

@end
