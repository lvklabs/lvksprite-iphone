/*
 *  LvkRepeatAction.m
 *  LvkSpriteProject
 *
 *  Created by Andres on 5/30/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "LvkRepeatAction.h"

@implementation LvkRepeatAction

+(id) actionWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times
{
	return [[[self alloc] initWithAction:action times:times] autorelease];
}

-(id) initWithAction:(CCFiniteTimeAction*)action times:(unsigned int)times
{
	if( (self = [super initWithAction:action times:times ]) ) {
//		times_ = times;
//		total_ = 0;
	}
	return self;
}

@end
