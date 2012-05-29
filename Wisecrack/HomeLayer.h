//
//  HomeLayer.h
//  Wisecrack
//
//  Created by Gareth Stokes on 9/03/12.
//  Copyright (c) 2012 digital five. All rights reserved.
//

#import "CCLayer.h"
#import "SpriteHelperLoader.h"
#import "GameKitHelper.h"
#import "SettingsManager.h"

@interface HomeLayer : CCLayer<GameKitHelperProtocol> {
    SpriteHelperLoader *loader;
    SpriteHelperLoader *backgroundLoader;
}

@end
