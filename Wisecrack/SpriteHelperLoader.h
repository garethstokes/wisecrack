//  This file was generated with SpriteHelper
//  http://www.spritehelper.org
//
//  SpriteHelperLoader.h
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////
//
//  Version history
//  v1.0 first draft for SpriteHelper 1.7
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32 //you should only keep this here


@interface SpriteHelperLoader : NSObject {
	
	NSMutableDictionary* shSprites;
    NSMutableDictionary* shAnimations;
    
    NSMutableDictionary* batchInfo; //contains CCBatchNode;
    int batchOrder;
}

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile;

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile 
			 sceneSubfolder:(NSString*)sceneFolder;

////////////////////////////////////////////////////////////////////////////////

-(CCSprite*) spriteWithUniqueName:(NSString*)name 
                       atPosition:(CGPoint)point 
                          inLayer:(CCLayer*)layer;

////////////////////////////////////////////////////////////////////////////////

-(CCSprite*) spriteInBatchWithUniqueName:(NSString*)name 
                              atPosition:(CGPoint)point 
                                 inLayer:(CCLayer*)layer;

////////////////////////////////////////////////////////////////////////////////

//the returned CCAction* should be used to stop the animation 
//e.g: [yourSprite stopAction:returnedAction];
//and if the animation does not have Start At Launch activated it should be used
//to start the animation e.g: [yourSprite runAction:returnedAction];
//
//Notifications
//Method should look like this -(void) animationEndedOnSprite:(CCSprite*)sprite
//registration should be like this:
/*
animAction = [pLoader runAnimationWithUniqueName:@"PlayerJump" 
                                        onSprite:animSpr
                              endNotificationSEL:@selector(animationEndedOnSprite:) 
                              endNotificationObj:self]; 
*/

-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite;

-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite 
                     endNotificationSEL:(SEL)notifSEL
                     endNotificationObj:(id)notifObj;

@end

