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
    NSArray *words;
    int numberOfWords;
}

@property (nonatomic, retain) NSArray* words;
@property (nonatomic) int numberOfWords;

- (void) shuffle;

@end
