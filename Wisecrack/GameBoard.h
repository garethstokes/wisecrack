//
//  GameBoard.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 Falling Shards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
#import "GameItem.h"
#import "PrototypeGame.h"
#import "BonusManager.h"
#import "TrueFriendsGame.h"

@interface GameBoard : CCNode {
    CGSize size;
    NSString* name;
    
    NSMutableArray* rows; 
    NSMutableArray* columns;
    
    int fillCount;
    BOOL dirty;
    BOOL chain;
    BOOL withBonus;
    
    TrueFriendsGame * game;
}

@property CGSize size;
@property BOOL dirty;
@property BOOL chain;
@property BOOL withBonus;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSMutableArray* rows;
@property (nonatomic, retain) NSMutableArray* columns;

- (GameItem *) wordAtPosition:(CGPoint)p;
- (NSArray *) neighbours:(GameItem *)word;
- (BOOL) matches:(GameItem *)word resultSet:(NSMutableArray *)results matchSize:(int)matchSize;
- (void) matchingColours:(GameItem *)item result:(NSMutableDictionary *)d;
- (void) matchingWords:(GameItem *)item result:(NSMutableDictionary *)d;
- (BOOL) fits:(GameItem* )word offset:(int)offset row:(int)row;
- (void) fill;

- (bool) hasUnactivatedBonus:(Bonus *)bonus;
- (void) enablePowerUps;
- (void) disablePowerUps;
@end
