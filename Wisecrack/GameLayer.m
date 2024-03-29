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
#import "WisecrackConfig.h"
#import "SimpleAudioEngine.h"
#import "Wisecrack.h"
#import "MetricMonster.h"

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
        
        
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish
{
    // container for the buttons
    menu = [CCMenu menuWithItems: nil];
    [menu setPosition:CGPointMake(-8, -12)];
    
    // init score and multiplier
    score = 0;
    ink = kTimeout;
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
    
    [self animateButtonsIn];
    //[self drawButtons];
    [self addChild:menu z:10];
    
    self.isAccelerometerEnabled = YES;
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    
    [self schedule:@selector(step:)];
    [self schedule:@selector(stepScoreTimer:) interval:1];
    [self schedule:@selector(updateBoard:) interval:1.5];
    
    int waveLength = [[WisecrackConfig config] waveLength];
    NSLog(@"WaveLength: %d", waveLength);
    [self schedule:@selector(nextWave) interval:waveLength];
    
    NSLog(@"scheduling enabling powerups in 45 seconds");
    int bonusRespawn = [[SettingsManager sharedSettingsManager] getInt:@"config.bonusRespawn" withDefault:30];
    [self schedule:@selector(enable_power_ups) interval:bonusRespawn];
    
    [board disablePowerUps];
    
    gameTime = 0;
    ready = YES;
    shake_once = false;
    [[SettingsManager sharedSettingsManager] setValue:@"NO" newString:@"Chain"];
    
    int soundEnabled = [[SettingsManager sharedSettingsManager] getInt:@"SoundEnabled" withDefault:1];
    if (soundEnabled)
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"wisecrack_bg_music_low.m4a" loop:YES];
    
    active = YES;
}

- (void) deactiveGame
{
    menu.isTouchEnabled = NO;
}

- (void) activeGame
{
    menu.isTouchEnabled = YES;
}

- (void) animateButtonsIn
{
    int count = 1;
    float lag = 0.2;
    
    //NSLog(@"iterating through rows now: %d", [board.rows count]);
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
            
            
            CCMenuItemImage * button = [word buttonWithTarget:self selector:@selector(wordClick:)];
            
            CGPoint position;
            position.y = count * kUnitHeight;
            position.x = word.offset * kUnitWidth;
            
            //NSLog(@"word being set: %@", [word hash]);
            [button setPosition:ccp(-500,position.y)];
            [menu addChild:button];
            [buttons addObject:button];
            //[button setOpacity:0];
            
            int max = [[WisecrackConfig config] buttonLoadDelay];
            float randomNum = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * max) + 0;
            //NSLog(@"randomNum: %f", randomNum);
            [button runAction:[CCSequence actions:
                               [CCDelayTime actionWithDuration:lag + randomNum],
                               [CCMoveTo actionWithDuration:[[WisecrackConfig config] buttonLoadDuration] position:position],
                               //[CCFadeIn actionWithDuration:[[WisecrackConfig config] buttonLoadDuration]],
                               nil]];
        }
        
        count++;
        lag += 0.2;
    }
}

- (void) animateButtonsOut
{
    id myShake = [CCShaky3D actionWithRange:2 shakeZ:NO grid:ccg(2,1) duration:4];
    [self runAction: [CCSequence actions: myShake, [myShake reverse], [CCStopGrid action], nil]];
    
    for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
    {
        int max = 2; // we actually want to hardcode this :: [[WisecrackConfig config] buttonRemoveDelay];
        float randomNum = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * max) + 0;
        [button runAction:[CCSequence actions:
                           [CCDelayTime actionWithDuration:randomNum],
                           [CCFadeOut actionWithDuration:0.7],
                           nil]];
    }
}

- (void) step:(ccTime)delta
{
    gameTime += delta;
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateScoreLabel:score withAnim:YES];
    
    NSMutableArray * cache = [NSMutableArray array];
    
    BonusManager * bm = [[GameObjectCache sharedGameObjectCache] bonusManager];
    for (Bonus * bonus in [bm activeBonusItems]) 
    {
        if ( [bonus.name isEqualToString:@"multiplier"] ||
             [bonus.name isEqualToString:@"chain"] )
        {
            ccTime bonusTime = [bonus activatedTime];
            
            // warn the user that it's about to run out. 
            if ( (gameTime - bonusTime) > 50 && [bonus runningOut] == false )
            {
                [bonus setRunningOut:YES];
                [[[GameObjectCache sharedGameObjectCache] hudLayer] updateBonus];
            }
            
            // we timeout after a minute. 
            if ( (gameTime - bonusTime) > 60 )
            {
                // we can't remove directly because we're
                // looping through active bonus items. 
                [cache addObject:bonus];
            }
            
            continue;
        }
    }
    
    for ( Bonus * bonus in cache )
    {
        if ( [bonus.name isEqualToString:@"multiplier"] )
        {
            [bm removeMultipler:bonus];
        }
        else if ( [bonus.name isEqualToString:@"chain"] )
        {
            [bm removeChain:bonus];
        }
    }
}

- (void) showScoreCard
{
    [self unschedule:@selector(showScoreCard)];
    
    GameLayer *gameLayer = [[GameObjectCache sharedGameObjectCache] gameLayer];
    ScoreCard *card = [[[ScoreCard alloc] init] autorelease];
    [card updateScore:[gameLayer score]];
    [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:card z:100];
    [card runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3], nil]];
    
    [[[GameObjectCache sharedGameObjectCache] gameScene] removeChild:self cleanup:YES];
}

- (void) stepScoreTimer:(ccTime)delta
{
    ink--;
    if (ink == 0)
    {
        [self animateButtonsOut];
        [self schedule:@selector(showScoreCard) interval:3.0];
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
        //NSLog(@"clearButtons: %@", [button.word hash]);;
        [menu removeChild:button cleanup:YES];
    }
}

- (void) drawButtons
{
    int count = 1;
    
    //NSLog(@"iterating through rows now: %d", [board.rows count]);
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
            
           
            CCMenuItemImage * button = [word buttonWithTarget:self selector:@selector(wordClick:)];
            
            CGPoint position;
            position.y = count * kUnitHeight;
            position.x = word.offset * kUnitWidth;
                    
            //NSLog(@"word being set: %@", [word hash]);
            [button setPosition:position];
            [menu addChild:button];
            [buttons addObject:button];
            [button setOpacity:0];
            
            int max = [[WisecrackConfig config] buttonLoadDelay];
            float randomNum = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * max) + 0;
            //NSLog(@"randomNum: %f", randomNum);
            [button runAction:[CCSequence actions:
                               [CCDelayTime actionWithDuration:randomNum], 
                               [CCFadeIn actionWithDuration:[[WisecrackConfig config] buttonLoadDuration]],
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
    
    if ([word bonus])
    {
        // can't click on brick, douchbag
        if ( [[word name] isEqualToString:@"brick"] ) return;
     
        Bonus * bonus = (Bonus *)word;
        [bonus decreaseDurability];
        
        CCMenuItemImage * selectedButton = (CCMenuItemImage *)sender;
        CCSprite * img = [[word loader] spriteWithUniqueName:[word key_up] 
                                                  atPosition:ccp(0,0) 
                                                     inLayer:nil];
        [selectedButton setSelectedImage:img];
        
        if (bonus.durability < 0)
        {
            [self removeGameItem:word withDelay:[[WisecrackConfig config] buttonLoadDelay]];
            ink = kTimeout;
            [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
            return;
        }
    }
    
    // ask the board for all the matching colours 
    BOOL hasMatches = [board matches:word resultSet:matches matchSize:3];
    if (hasMatches == NO && [word bonus] == NO)
    {
        // remove 50 points;
        [self unsuccessfulClick];
        return;
    }
    
    // find score;
    NSMutableDictionary * uniqueWords = [NSMutableDictionary dictionary];
    for (NSMutableDictionary * words in matches)
    {
        [uniqueWords addEntriesFromDictionary:words];
    }
    
    if ( [uniqueWords count] == 3 )
    {
        for ( GameItem * word in [uniqueWords allValues] )
        {
            if ( [[word name] isEqualToString:@"brick"] )
            {
                return;
            }
        }
    }
    
    // check for wisecrack
    /*
    GameItem * one = [[GameItem alloc] init];
    GameItem * two = [[GameItem alloc] init];
    GameItem * three = [[GameItem alloc] init];
    GameItem * four = [[GameItem alloc] init];
    GameItem * five = [[GameItem alloc] init];
    
    [one setName:@"Burning"];
    [two setName:@"Ring"];
    [three setName:@"Of"];
    [four setName:@"Declare"];
    [five setName:@"Fire"];
    
    NSArray * test = [NSArray arrayWithObjects:one, two, three, four, five, nil];
    */
    
    Wisecrack * wc = [Wisecrack find:[uniqueWords allValues]];
    if (wc != nil)
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite * happy = [wc image];
        happy.position = ccp(size.width /2, size.height /2);
        
        [self addChild:happy z:100];
        [happy runAction:[CCFadeOut actionWithDuration:3.0f]];
        
        score += [wc points];
        
        [[MetricMonster monster] queue:@"Wisecrack"];
        [[MetricMonster monster] queue:[NSString stringWithFormat:@"wc:", wc.key]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"found_wisecrack_noise.m4a" pitch:1 pan:1 gain:0.2];
    }
    
    ink = kTimeout;
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
    
    mutex = true;
    
    // remove matched words
    ccTime delay = [[WisecrackConfig config] buttonLoadDelay];
    for (NSDictionary * wordMatches in matches)
    {
        for (GameItem *w in [wordMatches allValues]) // loop through all the matches
        {
            [self removeGameItem:w withDelay:delay];
        }
        
        delay += [[WisecrackConfig config] buttonLoadDelay];
    }
    
    mutex = true;
    
    ScoreCalculator * scoreCalculator = [[[ScoreCalculator alloc] init] autorelease];
    score += [scoreCalculator calculate:[uniqueWords allValues]];
    
    ready = NO;
    [board setDirty:YES];
}

- (void) removeGameItem:(GameItem *)item withDelay:(ccTime)delay
{
    for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
    {
        if ([button isDirty]) continue;
        
        // find the matching button to the matched word
        if ([[button.word hash] isEqualToString:[item hash]]) 
        {
            // and remove it. 
            [self removeButton:button withDelay:delay];
            if ([button.word bonus])
            {
                Bonus * bonus = (Bonus *)button.word;
                [bonus setActivatedTime:gameTime];
                [bonus activate];
            }
        }
    }
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
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"mistake_sound.m4a" pitch:1 pan:1 gain:0.2];
}

- (void) enable_power_ups
{
    //[self unschedule:@selector(enable_power_ups)];
    [board enablePowerUps];
}

- (void) removeButton:(CCMenuItemImage *)button withDelay:(ccTime)delay
{
    if ( [[button.word name] isEqualToString:@"brick"] )
    {
        if (!mutex) return; 
        
        Bonus * bonus = (Bonus *)[button word];
        [bonus decreaseDurability];
        CCSprite * img = [[bonus loader] spriteWithUniqueName:[bonus key_up] 
                                                   atPosition:ccp(0,0) 
                                                      inLayer:nil];
        [button setNormalImage:img];
        mutex = false;
        
        if ( [bonus durability] >= 0 ) return;
    }
    
    if ([button.word bonus] && [button.word.name isEqualToString:@"brick"] == NO)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"bonus_noise.m4a" pitch:1 pan:1 gain:0.2];
    }
    
    //NSLog(@"fading out... %@", [button.word hash]);
    [button setIsDirty:YES];
    
    CCParticleSystemQuad *sparkle = [CCParticleSystemQuad particleWithFile:@"starburst.plist"];
    
    [sparkle setPosition:[button position]];
    ccColor4F endColour = [sparkle endColor];
    endColour.r = 0;
    endColour.g = 1;
    endColour.b = 0;
    //[sparkle setEndColor:endColour];
    
    [self addChild:sparkle z:101];
    
    SpriteHelperLoader * loader = [button.word loader];
    CCSprite *sprite2 = [loader spriteWithUniqueName:[button.word key_down] 
                                          atPosition:ccp(0,0) 
                                             inLayer:nil];
    
    [button setNormalImage:sprite2];
    [button runAction:[CCSequence actions:
                       [CCDelayTime actionWithDuration:[[WisecrackConfig config] buttonRemoveDelay] ],
                       [CCFadeOut actionWithDuration:[[WisecrackConfig config] buttonRemoveDuration] ],
                       [CCCallFuncO actionWithTarget:self selector:@selector(endRemoveButton:) object:button], 
                       nil]];
}

- (void) endRemoveButton:(id)sender
{
    CCMenuItemImage * button = (CCMenuItemImage *)sender;
    //NSLog(@"removing button: %@", [button.word hash]);
    
    [button setVisible:NO];
    [buttons removeObject:button];
    [menu removeChild:button cleanup:YES];
     
    NSMutableArray *boardRow = [board.rows objectAtIndex:([button.word row] -1)];
    [boardRow removeObject:[button word]];
    
    if ([button.word.name isEqualToString:@"brick"])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"brick_diminish_effects.m4a" pitch:1 pan:1 gain:0.2];
        
        CCParticleSystemQuad *puff = [CCParticleSystemQuad particleWithFile:@"brick_puff.plist"];
        [puff setPosition:[button position]];
        
        [self addChild:puff z:102];
    }
}

- (void) shakeDelay
{
    [self unschedule:@selector(shakeDelay)];
    shake_once = false;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD || 
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        if (!shake_once) {
            //int derp = 22/7;
            shake_once = true;
            NSLog(@"HULK SMASH!");
            
            BonusManager * bm = [[GameObjectCache sharedGameObjectCache] bonusManager];
            if ( [bm removeShakeIfAvailable] )
            {
                [self wipe];
            }
            
            [self schedule:@selector(shakeDelay) interval:5];
        }
        
    }
}

- (void) wipe
{
    NSMutableArray * words = [NSMutableArray array];
    for (CCMenuItemImage *button in [menu children]) // loop through the ui buttons
    {
        if ([button.word.name isEqualToString:@"brick"]) continue;
        if ([button isDirty]) continue;
        
        [self removeButton:button withDelay:0.2];
        [words addObject:button.word];
    }
    
    ScoreCalculator *scoreCalculator = [[[ScoreCalculator alloc] init] autorelease];
    score += [scoreCalculator calculate:words];
    
    ink = kTimeout;
    [[[GameObjectCache sharedGameObjectCache] hudLayer] updateInk:ink];
}

- (void) nextWave
{
    [self unschedule:@selector(nextWave)];
    [[WisecrackConfigSet configSet] incrementWave];
    int waveLength = [[WisecrackConfig config] waveLength];
    
    NSLog(@"UPWAVE: %d  ", waveLength);
    [self schedule:@selector(nextWave) interval:waveLength];
}

- (void) onExit
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [buttons removeAllObjects];
    [buttons release];
    [self removeAllChildrenWithCleanup:YES];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [super onExit];
}

- (void) dealloc
{   
    [super dealloc];
}

@end
