//
//  LvkAnimate.m
//  LvkSpriteProject
//
//  Copyright (c) 2012 LVK. All rights reserved.
//

#import "LvkAnimate.h"

@implementation LvkAnimate

-(void) stop 
{
	// Bypass CCAnimate::stop because produces flickering. CCAnimate bug?
	[[[self superclass] superclass] instanceMethodForSelector:@selector(stop)];
}

@end
