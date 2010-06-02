/*
 *  LvkRepeatAction.h
 *  LvkSpriteProject
 *
 *  Created by Andres on 5/30/10.
 *  Copyright 2010 LavandaInk. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LvkRepeatAction : CCRepeat
{
	
}

+(id) actionWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times;

-(id) initWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times;

@end
