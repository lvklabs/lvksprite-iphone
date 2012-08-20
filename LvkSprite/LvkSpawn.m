//
//  LvkSpawn.m
//  LvkSpriteProject
//
//  Copyright 2011, 2012 LVK. All rights reserved.
//

#import "LvkSpawn.h"
#import "common.h"

@implementation LvkSpawn

@synthesize nested = nested_;

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
		nested_ = NO;
		
		[one_ release];
		[two_ release];
		[child_ release];
		
		one_ = one;
		two_ = two;
		child_ = [[CCSprite alloc] init];
				
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
		child_.anchorPoint = CGPointMake(0, 1);
		child_.contentSize = [aTarget contentSize];

		if (!nested_) {
			[aTarget addChild:child_ z:1];
			child_.position = CGPointMake(0, [aTarget contentSize].height);
		} else {
			[aTarget addChild:child_ z:-1];
		}
		childAdded_ = YES;
	}
	
	[super startWithTarget:aTarget];
	
	if (!nested_) {
		[one_ startWithTarget:child_];
		[two_ startWithTarget:target_];		
	} else {
		[one_ startWithTarget:target_];
		[two_ startWithTarget:child_];				
	}
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
	// Not sure why I need this correction in the position :(
	if (!nested_) {
		child_.position = CGPointMake(0, [(CCNode*)target_ contentSize].height);
	}
	
	[one_ update:t];
	[two_ update:t];
}

- (CCActionInterval *) reverse
{
	return [[self class] actionOne: [one_ reverse] two: [two_ reverse ] ];
}

@end
