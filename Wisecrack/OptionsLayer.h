//
//  OptionsLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 12/04/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"
#import "CCSlider.h"

@interface OptionsLayer : CCLayer {
    CCMenu * soundMenu;
}
- (void) soundToggle;
- (void) addSoundSlider;
- (void) cont:(id) sender;
- (void) replay:(id) sender;
- (void) playTutorial;

@end
