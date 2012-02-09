//
//  PrototypeGame.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoard.h"
#import "GameConfig.h"
#import "GameItem.h"

@interface PrototypeGame : NSObject {
    NSArray *words;
    int numberOfWords;
}

@property (nonatomic, retain) NSArray* words;

- (void) fill:(GameBoard *)board;
- (GameItem *) randomWord;

@end
