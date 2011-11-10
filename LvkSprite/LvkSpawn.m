//
//  LvkSpawn.m
//  LvkSpriteProject
//
//  Created by Andres on 11/9/11.
//  Copyright 2011 LavandaInk. All rights reserved.
//

#import "LvkSpawn.h"
#import "common.h"

@implementation LvkSpawn

+(id) actionOne: (CCFiniteTimeAction*) one two: (CCFiniteTimeAction*) two
{	
	return [[[self alloc] initOne:one two:two ] autorelease];
}

-(id) initOne: (CCFiniteTimeAction*) one two: (CCFiniteTimeAction*) two
{	
	ccTime d1 = [one duration];
	ccTime d2 = [two duration];	
	
	if( (self=[super initWithDuration: MAX(d1,d2)] ) ) {
		
		childAdded_ = NO;
		
		[one_ release];
		[two_ release];
		[child_ release];
		
		one_ = one;
		two_ = two;
		child_ = [[CCSprite alloc] init];
		
		child_.isRelativeAnchorPoint = NO;
		
		if( d1 > d2 )
			two_ = [CCSequence actionOne:two two:[CCDelayTime actionWithDuration: (d1-d2)] ];
		else if( d1 < d2)
			one_ = [CCSequence actionOne:one two: [CCDelayTime actionWithDuration: (d2-d1)] ];
		
		[one_ retain];
		[two_ retain];		
	}
	return self;
}

//-(id) copyWithZone: (NSZone*) zone
//{
//	CCAction *copy = [[[self class] allocWithZone: zone] initOne: [[one_ copy] autorelease] two: [[two_ copy] autorelease] ];
//	return copy;
//}

-(void) dealloc
{
	if (childAdded_ == YES) {
		[target_ removeChild:child_ cleanup:YES];
	}

	[one_ release];
	[two_ release];
	[child_ release];
	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	if (childAdded_ == NO) {
		[aTarget addChild:child_];
		childAdded_ = YES;
	}
	
	[super startWithTarget:aTarget];
	[one_ startWithTarget:target_];
	[two_ startWithTarget:child_];
}

-(void) stop
{
	if (childAdded_ == YES) {
		[target_ removeChild:child_ cleanup:YES];
		childAdded_ = NO;
	}

	[one_ stop];
	[two_ stop];
	[super stop];
}

-(void) update: (ccTime) t
{
	[one_ update:t];
	[two_ update:t];
}

- (CCActionInterval *) reverse
{
	return [[self class] actionOne: [one_ reverse] two: [two_ reverse ] ];
}

@end
