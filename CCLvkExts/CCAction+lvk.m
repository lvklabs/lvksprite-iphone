//
//  CCAction+lvk.m
//  LvkSpriteProject
//
//  Copyright (c) 2012 LVK. All rights reserved.
//

#import "CCAction+lvk.h"

@implementation CCRepeatForever (CCLvkExt)

-(void) stop
{
	[innerAction_ stop];
	[super stop];
}

@end


