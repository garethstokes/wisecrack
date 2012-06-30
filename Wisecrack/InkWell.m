//
//  InkWell.m
//  Wisecrack
//
//  Created by Gareth Stokes on 24/05/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "InkWell.h"
#import "GameConfig.h"

@implementation InkWell

- (id) init:(SpriteHelperLoader *)ldr
{
    if( (self=[super init]))
    {
        loader = ldr;
        base_bg = [loader spriteWithUniqueName:@"z_1_ink_timer_base_bg" 
                                    atPosition:ccp(0,0) 
                                       inLayer:nil];
        
        bottle_bg = [loader spriteWithUniqueName:@"z_3_ink_timer_bottle_bg" 
                                      atPosition:ccp(0,0) 
                                         inLayer:nil];
        
        bottle_details = [loader spriteWithUniqueName:@"z_5_ink_timer_bottle_details" 
                                                      atPosition:ccp(0,0) 
                                                         inLayer:nil];
        
        [self addChild:base_bg z:0];
        [self addChild:bottle_bg z:2];
        [self addChild:bottle_details z:4];
        
        [self fillPot:0];
        
        danger = false;
        danger_red = false;
        _sound = -1;
    }
    
    return self;
}

- (void)fillPot:(int)level
{
    if (level >= kTimeout) return;
    
    NSString * key = [NSString stringWithFormat:@"z_4_ink_timer_ink_anim_%d", level];
    
    if (timer_ink != nil)
    {
        [self removeChild:timer_ink cleanup:YES];
        timer_ink = nil;
    }
    
    timer_ink = [loader spriteWithUniqueName:key
                                  atPosition:ccp(0,0) 
                                     inLayer:nil];
    
    [self addChild:timer_ink z:3];
    
    if (level >= 11)
    {
        if (danger_red) return;
        danger_red = YES;
        
        [self removeChild:bottle_bg cleanup:YES];
        bottle_bg = [loader spriteWithUniqueName:@"z_3_5_ink_timer_bottle_bg_red" 
                                      atPosition:ccp(0,0) 
                                         inLayer:nil];
        [bottle_bg setOpacity:1.0];
        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.2 opacity:255];
        CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.2 opacity:127];
        
        CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
        [bottle_bg runAction:repeat];
        
        [self addChild:bottle_bg z:0];
        
        return;
    }
    
    if (level >= 9)
    {
        if (danger) return;
        danger = YES;
        
        _sound = [[SimpleAudioEngine sharedEngine] playEffect:@"end_of_time_noise.m4a" pitch:1 pan:1 gain:0.2];
        
        [self removeChild:base_bg cleanup:YES];
        base_bg = [loader spriteWithUniqueName:@"z_2_ink_timer_bg_red_overlay" 
                                    atPosition:ccp(0,0) 
                                       inLayer:nil];
        
        [base_bg setOpacity:1.0];
        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.1 opacity:127];
        CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.1 opacity:255];
        
        CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
        [base_bg runAction:repeat];
        
        [self addChild:base_bg z:0];
        return;
    }
    
    if (danger)
    {
        // set the background back to normal
        danger = NO;
        
        [self removeChild:base_bg cleanup:YES];
        base_bg = [loader spriteWithUniqueName:@"z_1_ink_timer_base_bg" 
                                    atPosition:ccp(0,0) 
                                       inLayer:nil];
        [self addChild:base_bg z:0];
        
        if (_sound != -1)
        {
            [[SimpleAudioEngine sharedEngine] stopEffect:_sound];
            _sound = -1;
        }
    }
    
    if (danger_red)
    {
        // set the background back to normal
        danger_red = NO;
        
        [self removeChild:bottle_bg cleanup:YES];
        bottle_bg = [loader spriteWithUniqueName:@"z_3_ink_timer_bottle_bg" 
                                    atPosition:ccp(0,0) 
                                       inLayer:nil];
        [self addChild:bottle_bg z:0];
    }
}

- (void) dealloc
{   
    [base_bg dealloc];
    [bottle_bg dealloc];
    [timer_ink dealloc];
    [bottle_details dealloc];
    
    [super dealloc];
}

@end
