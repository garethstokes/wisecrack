//
//  GameLayer.m
//  Wisecrack
//
//  Created by Gareth Stokes on 9/02/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "GameLayer.h"
#import "GameObjectCache.h"
#import "ScoreCard.h"

@implementation GameLayer
@synthesize board;
@synthesize buttons;
@synthesize score;

- (id) initWithBoard:(GameBoard *)b
{
    if( (self=[super init]))
    {
        [self setBoard:b];
        SpriteHelperLoader *bgloader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"] autorelease];
        buttons = [[NSMutableArray array] retain];
        
        // background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [bgloader spriteWithUniqueName:@"level_1_bg" atPosition:CGPointMake((size.width /2) -1, size.height /2) inLayer:nil];
        
        [self addChild:background z:0];
        
        // container for the buttons
        menu = [CCMenu menuWithItems: nil];
        [menu setPosition:CGPointMake(-8, -12)];
        
        // init score and multiplier
        score = 0;
        ink = kTimeout;
        [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];

        [self drawButtons];
        [self addChild:menu z:10];
        
        [self schedule:@selector(step:)];
        [self schedule:@selector(stepScoreTimer:) interval:1];
        [self schedule:@selector(updateBoard:) interval:3.0];
        ready = YES;
    }
    
    return self;
}

- (void) step:(ccTime)delta
{
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score withAnim:YES];
}

- (void) stepScoreTimer:(ccTime)delta
{
    ink--;
    if (ink == 0)
    {
        GameLayer *gameLayer = [[GameObjectCache sharedGameObjectCache] gameLayer];
        ScoreCard *card = [[[ScoreCard alloc] init] autorelease];
        [card updateScore:[gameLayer score]];
        [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:card z:100];
        [card runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3], nil]];
        
        [[[GameObjectCache sharedGameObjectCache] gameScene] removeChild:self cleanup:YES];
    }
    
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
}

- (void) updateBoard:(ccTime) delta
{
    if (![board dirty]) return;
    ready = NO;
    
    // refill the board;
    [board fill];
    [self drawButtons];
    
    ready = YES;
}

- (void) clearButtons
{
    // copy each item to a seperate array
    // iterate through that removing from menu.
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    for (CCMenuItemImage *button in [menu children]) 
    {
        [itemsToDelete addObject:button];
    }
    
    for (CCMenuItemImage *button in itemsToDelete) 
    {
        NSLog(@"clearButtons: %@", [button.word hash]);;
        [menu removeChild:button cleanup:YES];
    }
}

- (void) drawButtons
{
    int count = 1;
    
    NSLog(@"iterating through rows now: %d", [board.rows count]);
    for (NSArray *row in [board rows])
    {
        //NSLog(@"row number: %d", count);
        for (GameItem *word in row)
        {
            BOOL hasBeenFound = NO;
            for (CCMenuItemImage *button in buttons)
            {
                if ([[button.word hash] isEqualToString:[word hash]])
                {
                    hasBeenFound = YES;
                    break;
                }
            }
            if (hasBeenFound) continue;
            
            CCMenuItemImage * button = [CCMenuItemImage itemFromWord:word target:self selector:@selector(wordClick:)];
            
            CGPoint position;
            position.y = count * kUnitHeight;
            position.x = word.offset * kUnitWidth;
                    
            NSLog(@"word being set: %@", [word hash]);
            [button setPosition:position];
            [button retain];
            [menu addChild:button];
            [buttons addObject:button];
            [button setOpacity:0];
            
            int max = 2;
            float randomNum = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * max) + 0;
            NSLog(@"randomNum: %f", randomNum);
            [button runAction:[CCSequence actions:
                               [CCDelayTime actionWithDuration:randomNum], 
                               [CCFadeIn actionWithDuration:2.0f],
                               nil]];
        }
        
        count++;
    }
}

- (void) wordClick:(id) sender
{
    //if (!ready) return;
    
    NSLog(@"click");
    //NSMutableDictionary *matches = [NSMutableDictionary dictionary];
    NSMutableArray * matches = [NSMutableArray array];

    // map buttons to words
    
    GameItem *word = ((CCMenuItemImage *)sender).word;
    NSLog(@"word: %@", [word hash]);
    
    // initial word
    //[matches setValue:word forKey:[word hash]];
    
    // ask the board for all the matching colours 
    if (![board matches:word resultSet:matches matchSize:3])
    {
        // remove 50 points;
        [self unsuccessfulClick];
        return;
    }
    
    ink = kTimeout;
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
    
    // remove all the matched colours.
    for (GameItem *w in [[matches objectAtIndex:0] allValues]) // loop through all the matches
    {
        for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
        {
            if ([[button.word hash] isEqualToString:[w hash]]) // find the matching button to the matched word
            {
                // and remove it. 
                [self removeButton:button withDelay:1];
            }
        }
    }
    
    // remove matched words
    ccTime delay = 0.5;
    for (NSDictionary * wordMatches in matches)
    {
        for (GameItem *w in [wordMatches allValues]) // loop through all the matches
        {
            for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
            {
                if ([button isDirty]) continue;
                if ([[button.word hash] isEqualToString:[w hash]]) // find the matching button to the matched word
                {
                    // and remove it. 
                    [self removeButton:button withDelay:delay];
                }
            }
        }
        delay += 0.5;
    }
    
    // find score;
    NSMutableDictionary * uniqueWords = [NSMutableDictionary dictionary];
    for (NSMutableDictionary * words in matches)
    {
        [uniqueWords addEntriesFromDictionary:words];
    }
    
    ScoreCalculator *scoreCalculator = [[[ScoreCalculator alloc] init] autorelease];
    score += [scoreCalculator calculate:[uniqueWords allValues]];
    
    ready = NO;
    [board setDirty:YES];
}

- (void) unsuccessfulClick
{
    score -= 50;
    if (score < 0) score = 0;
    
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score withAnim:NO];
    
    id myShake = [CCShaky3D actionWithRange:5 shakeZ:NO grid:ccg(2,2) duration:0.1];
    [self runAction: [CCSequence actions: myShake, [myShake reverse], [CCStopGrid action], nil]];
    
    SpriteHelperLoader *bgloader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"] autorelease];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite * minus = [bgloader spriteWithUniqueName:@"minus50" atPosition:CGPointMake((size.width /2) + 5, size.height /2) inLayer:nil];
    
    [self addChild:minus z:100];
    [minus runAction:[CCFadeOut actionWithDuration:1.5]];
}

- (void) removeButton:(CCMenuItemImage *)button withDelay:(ccTime)delay
{
    NSLog(@"fading out... %@", [button.word hash]);
    [button setIsDirty:YES];
    
    CCParticleSystemQuad *sparkle = [CCParticleSystemQuad particleWithFile:@"starburst.plist"];
    
    [sparkle setPosition:[button position]];
    [self addChild:sparkle z:101];
    
    NSString *key_down = [NSString stringWithFormat:@"%@_%@_%d_down", 
                          [button.word colour], 
                          [button.word name],
                          (int)button.word.size.width];
    
    SpriteHelperLoader * loader = [SpriteHelperLoader loaderFromWord:[button word]];
    CCSprite *sprite2 = [loader spriteWithUniqueName:key_down atPosition:CGPointMake(0,0) inLayer:nil];
    
    [button setNormalImage:sprite2];
    [button runAction:[CCSequence actions:
                       [CCDelayTime actionWithDuration:delay],
                       [CCFadeOut actionWithDuration:1.5],
                       [CCCallFuncO actionWithTarget:self selector:@selector(endRemoveButton:) object:button], 
                       nil]];
}

- (void) endRemoveButton:(id)sender
{
    CCMenuItemImage * button = (CCMenuItemImage *)sender;
    NSLog(@"removing button: %@", [button.word hash]);
    
    [button setVisible:NO];
    [buttons removeObject:button];
    [menu removeChild:button cleanup:YES];
     
    NSMutableArray *boardRow = [board.rows objectAtIndex:([button.word row] -1)];
    [boardRow removeObject:[button word]];
}

- (void) dealloc
{   
    [super dealloc];
}

@end
