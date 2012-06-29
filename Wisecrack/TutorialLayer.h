//
//  TutorialLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 22/06/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"

@interface TutorialLayer : CCLayer {
    SpriteHelperLoader * _buttons;
    CCSprite * _tut;
    CCMenu * _menu;
    
    CCAction * _currentAnimation;
    
    int _step;
}

- (void) addMenu;
- (void) stepZero;
- (void) stepOne;
- (void) stepTwo;
- (void) stepTwoAndAHalf;
- (void) stepThree;
- (void) stepFour;
- (void) stepFive;
- (void) stepSix;
- (void) stepSeven;
- (void) playGameScene;
@end
