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

@interface GameBoard : NSObject {
    CGSize size;
    NSString* name;
    
    NSMutableArray* rows; 
    NSMutableArray* columns;
    
    int wisecrackLength;
    int fillCount;
    BOOL dirty;
}

@property CGSize size;
@property BOOL dirty;
@property int wisecrackLength;

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

@end
