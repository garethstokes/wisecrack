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
@synthesize multiplier;

- (id) initWithBoard:(GameBoard *)b
{
    if( (self=[super init]))
    {
        [self setBoard:b];
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"true_friends"];
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
        multiplier = kGroupMinSize +1;
        [[[GameObjectCache sharedGameObjectCache] hudLayer] updateMultiplier:multiplier];

        [self drawButtons];
        [self addChild:menu z:10];
        
        [self schedule:@selector(step:)];
        [self schedule:@selector(updateBoard:) interval:3.0];
        [self schedule:@selector(updateMultiplier:) interval:60.0];
        ready = YES;
    }
    
    return self;
}

- (void) step:(ccTime)delta
{
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score withAnim:YES];
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

- (void) updateMultiplier:(ccTime)delta
{
    if (multiplier < 5)
    {
        multiplier++;
        [[[GameObjectCache sharedGameObjectCache] hudLayer] updateMultiplier:multiplier];
    }
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
            
            NSString *key_up = [NSString stringWithFormat:@"%@_%@_%d_up", 
                             [word colour], 
                             [word name],
                             (int)word.size.width];
            
            NSString *key_down = [NSString stringWithFormat:@"%@_%@_%d_down", 
                                [word colour], 
                                [word name],
                                (int)word.size.width];
            
            //NSLog(@"%@", key);
            //NSLog(@"x => %d, width => %d", word.offset, (int)word.size.width);
            //NSLog(@"%@", [word hash]);
            CGPoint position;
            
            position.y = count * kUnitHeight;
            position.x = word.offset * kUnitWidth;
            
            //NSLog(@"position( x=>%d, y=>%d )", (int)position.x, (int)position.y);
            CCSprite *sprite = [loader spriteWithUniqueName:key_up atPosition:CGPointMake(0,0) inLayer:nil];
            CCSprite *sprite2 = [loader spriteWithUniqueName:key_down atPosition:CGPointMake(0,0) inLayer:nil];
            
            CCMenuItemImage *button = [CCMenuItemImage 
                                       itemFromNormalSprite:sprite
                                       selectedSprite:sprite2
                                       target:self 
                                       selector:@selector(wordClick:)];
            
            if (word.size.width == 3)
            {
                //[sprite setAnchorPoint:CGPointMake(0.19, 0.5)];
                [button setAnchorPoint:CGPointMake(0.19, 0.5)];
            }
            
            if (word.size.width == 2)
            {
                //[sprite setAnchorPoint:CGPointMake(0.27, 0.5)];
                [button setAnchorPoint:CGPointMake(0.27, 0.5)];
            }
            
            //[button setWord:[word duplicate]];
            [button setWord:word];
            NSLog(@"word being set: %@", [word hash]);
            [button setPosition:position];
            [button retain];
            [menu addChild:button];
            [buttons addObject:button];
            [button setOpacity:0];
            [button runAction:[CCSequence actions:
                               [CCDelayTime actionWithDuration:arc4random() % 5], 
                               [CCFadeIn actionWithDuration:3.0f],
                               nil]];
        }
        
        count++;
    }
}

- (void) wordClick:(id) sender
{
    //if (!ready) return;
    
    NSLog(@"click");
    NSMutableDictionary *matches = [NSMutableDictionary dictionary];

    // map buttons to words
    
    GameItem *word = ((CCMenuItemImage *)sender).word;
    NSLog(@"word: %@", [word hash]);
    
    // initial word
    [matches setValue:word forKey:[word hash]];
    
    // ask the board for all the matching colours 
    [board matchingColours:word result:matches];
    
    // ask the board for all the matching words 
    NSMutableArray * matchedMatches = [NSMutableArray array];
    for (GameItem * matchedWord in [[matches copy] allValues])
    {
        NSMutableDictionary * matchedWords = [NSMutableDictionary dictionary];
        [board matchingWords:matchedWord result:matchedWords];
        if ([matchedWords.allKeys count] >= multiplier)
            [matchedMatches addObject:matchedWords];
    }
    
    // we need more than N matches to continue. 
    if ([matches.allKeys count] < multiplier && [matchedMatches count] == 0) 
    {
        // remove 50 points;
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
        
        return;
    }
    
    // remove all the matched colours. 
    for (GameItem *w in [matches allValues]) // loop through all the matches
    {
        for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
        {
            if ([[button.word hash] isEqualToString:[w hash]]) // find the matching button to the matched word
            {
                // and remove it. 
                [self removeButton:button withDelay:0];
            }
        }
    }
    
    // remove matched words
    ccTime delay = 1;
    for (NSDictionary * wordMatches in matchedMatches)
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
        delay += 1;
    }
    
    // find score;
    ScoreCalculator *scoreCalculator = [[[ScoreCalculator alloc] init] autorelease];
    score += [scoreCalculator calculate:[matches allValues]];
    
    ready = NO;
    [board setDirty:YES];
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
    [loader release];
    [super dealloc];
}

@end
