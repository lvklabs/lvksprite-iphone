//
//  LvkSpawn.h
//  LvkSpriteProject
//
//  Copyright 2011, 2012 LVK. All rights reserved.
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
	BOOL nested_;
}

+(id) actionOne: (CCFiniteTimeAction*) one two:(CCFiniteTimeAction*) two;
-(id) initOne: (CCFiniteTimeAction*) one two:(CCFiniteTimeAction*) two;

@property (assign) BOOL nested;

@end
