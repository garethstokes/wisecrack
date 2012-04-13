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
        loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"hall_of_legends"];
        SpriteHelperLoader *bgloader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"] autorelease];
        buttons = [[NSMutableArray array] retain];
        
        // background
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [bgloader spriteWithUniqueName:@"level_1_bg" atPosition:CGPointMake((size.width /2) -1, size.height /2) inLayer:nil];
        
        [self addChild:background z:0];
        
        //[loader spriteWithUniqueName:@"green_words_1_unit_test" atPosition:CGPointMake(100, 100) inLayer:self];
        //CCSprite *medium = [loader spriteWithUniqueName:@"green_words_2_unit_test" atPosition:CGPointMake(100, 130) inLayer:self];
        //[medium setAnchorPoint:CGPointMake(0.27, 0.5)];
        //CCSprite *large = [loader spriteWithUniqueName:@"green_words_3_unit_test" atPosition:CGPointMake(100, 160) inLayer:nil];
        //[large setAnchorPoint:CGPointMake(0.19, 0.5)];
        
        menu = [CCMenu menuWithItems: nil];
        [menu setPosition:CGPointMake(-8, -12)];
        
        // init score
        score = 0;

        [self drawButtons];
        [self addChild:menu z:10];
        
        [self schedule:@selector(step:) interval:3.0];
        ready = YES;
        delta_ = 0;
    }
    
    return self;
}

- (void) step:(ccTime) delta
{
    //NSLog(@"stepping");
    
    // refill the board;
    [board fill];
    //[self clearButtons];
    [self drawButtons];
    
    // check to see if there are any valid moves
    if ((delta_ - delta) > 30) // check every 5 seconds
    {
        NSLog(@"checking for valid moves");
        BOOL valid = NO;
        if (ready)
        {
            for (CCMenuItemImage *button in buttons)
            {
                NSMutableDictionary *matches = [NSMutableDictionary dictionary];
                GameItem *word = [button word];
            
                // initial word
                [matches setValue:word forKey:[word hash]];
            
                // ask the board for all the matching colours 
                [board matchingColours:word result:matches];
            
                // ask the board for all the matching words 
                [board matchingWords:word result:matches];
            
                // we need more than 2 matches to continue. 
                if ([matches.allKeys count] <= kGroupMinSize) 
                {
                    valid = YES;
                    break;
                }
            }
        }
        
        if (!valid)
        {
            NSLog(@"INVALID BOARD DUDE");
            ScoreCard * scoreCard = [[[ScoreCard alloc] init] autorelease];
            [scoreCard updateScore:score];
            //[[[GameObjectCache sharedGameObjectCache] gameScene] addChild:scoreCard z:200];
        }
        delta_ = 0;
    }
    
    ready = YES;
    delta_ += delta;
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
    
    //[self clearButtons];
    
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
            
            NSString *key_up = [NSString stringWithFormat:@"%@_%d_up", 
                             [word colour], 
                             (int)word.size.width];
            
            NSString *key_down = [NSString stringWithFormat:@"%@_%d_down", 
                                [word colour], 
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
        }
        
        count++;
    }
}

- (void) wordClick:(id) sender
{
    if (!ready) return;
    
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
    //[board matchingWords:word result:matches];
    
    // we need more than 2 matches to continue. 
    if ([matches.allKeys count] <= kGroupMinSize) 
    {
        // remove 50 points;
        score -= 50;
        if (score < 0) score = 0;
        
        [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score];
        
        id myShake = [CCShaky3D actionWithRange:5 shakeZ:NO grid:ccg(2,2) duration:0.1];
        [self runAction: [CCSequence actions: myShake, [myShake reverse], [CCStopGrid action], nil]];
        
        SpriteHelperLoader *bgloader = [[[SpriteHelperLoader alloc] initWithContentOfFile:@"backgrounds"] autorelease];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite * minus = [bgloader spriteWithUniqueName:@"minus50" atPosition:CGPointMake((size.width /2) + 5, size.height /2) inLayer:nil];
        
        [self addChild:minus z:100];
        
        [minus runAction:[CCFadeOut actionWithDuration:1.5]];
        
        return;
    }
    
    // remove all the matched words. 
    for (GameItem *w in [matches allValues]) 
    {
        for (CCMenuItemImage *button in [menu children]) 
        {
            if ([[button.word hash] isEqualToString:[w hash]])
            {
                NSLog(@"fading out... %@", [word hash]);
                
                CCParticleSystemQuad *sparkle = [CCParticleSystemQuad particleWithFile:@"starburst.plist"];
                
                [sparkle setPosition:[button position]];
                [self addChild:sparkle z:101];
                
                NSString *key_down = [NSString stringWithFormat:@"%@_%d_down", 
                                      [button.word colour], 
                                      (int)button.word.size.width];
                CCSprite *sprite2 = [loader spriteWithUniqueName:key_down atPosition:CGPointMake(0,0) inLayer:nil];
                
                [button setNormalImage:sprite2];
                [button runAction:[CCSequence actions:
                                   [CCFadeOut actionWithDuration:0.5],
                                   [CCCallFuncO actionWithTarget:self selector:@selector(removeButton:) object:button], 
                                   nil]];
            }
        }
    }
    
    // find score;
    ScoreCalculator *scoreCalculator = [[[ScoreCalculator alloc] init] autorelease];
    score += [scoreCalculator calculate:[matches allValues]];
    
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score];
    
    ready = NO;
}

- (void) removeButton:(id)sender
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
