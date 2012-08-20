/*
 *  LvkRepeatAction.h
 *  LvkSpriteProject
 *
 *  Copyright 2010, 2011, 2012 LVK. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LvkRepeatAction : CCRepeat
{
	
}

+(id) actionWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times;

-(id) initWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times;

@end
