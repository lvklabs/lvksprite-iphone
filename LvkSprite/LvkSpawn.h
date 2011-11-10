//
//  LvkSpawn.h
//  LvkSpriteProject
//
//  Created by Andres on 11/9/11.
//  Copyright 2011 LavandaInk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// CCSpawn does not support running two CCAnimations at the same time
// This class does a trick to do it.
@interface LvkSpawn : CCActionInterval //<NSCopying>
{
	BOOL childAdded_;
    CCSprite *child_;
	CCFiniteTimeAction *one_;
	CCFiniteTimeAction *two_;
}

+(id) actionOne: (CCFiniteTimeAction*) one two:(CCFiniteTimeAction*) two;
-(id) initOne: (CCFiniteTimeAction*) one two:(CCFiniteTimeAction*) two;

@end
