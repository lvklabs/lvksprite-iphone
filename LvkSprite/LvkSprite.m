//
//  LvkSprite.m
//

#import <Foundation/NSData.h>
#import "LvkSprite.h"
#import "LvkRepeatAction.h"
#import "common.h"

@implementation LvkSprite

- (id) initWithBinary: (NSString*)binFile andInfo: (NSString*)infoFile andError:(NSError**)error
{
	if(!(self = [super init]))
		return self;
	
	[self loadBinary: binFile andInfo: infoFile andError:error];

	animation = nil;
	aniAction = nil;
	px = &(position_.x);
	py = &(position_.y);
	pw = &(contentSize_.width);
	ph = &(contentSize_.height);
	collisionThreshold = 0;
	
	self.anchorPoint = CGPointMake(0, 0);
	
	[self schedule:@selector(tick:)];
	
	return self;
}

- (void) dealloc {
	[lvkAnimations release];
	[super dealloc];
}

- (void) tick: (ccTime) dt
{
}

-(void) draw
{
	[super draw];

#ifdef LVK_SPRITE_SHOW_FRAME_RECT
	CGFloat x;
	CGFloat y;
	CGFloat w;
	CGFloat h;
	
	glColor4ub(255, 0, 255, 255);
	glLineWidth(1);
	x = rect_.origin.x;
	y = rect_.origin.y;
	w = rect_.size.width;
	h = rect_.size.height;
	CGPoint v1[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v1, 4, YES);

	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	glColor4ub(128, 0, 128, 255);
	glLineWidth(1);
	x = rect_.origin.x - collisionThreshold;
	y = rect_.origin.y - collisionThreshold;
	w = rect_.size.width + collisionThreshold;
	h = rect_.size.height + collisionThreshold;
	CGPoint v3[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v3, 4, YES);
	
	glColor4ub(0, 255, 0, 255);
	glLineWidth(1);
	x = position_.x;
	y = position_.y;
	w = contentSize_.width;
	h = contentSize_.height;
	CGPoint v2[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v2, 4, YES);

	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	glColor4ub(0, 128, 0, 255);
	glLineWidth(1);
	x = position_.x - collisionThreshold;
	y = position_.y - collisionThreshold;
	w = contentSize_.width + collisionThreshold;
	h = contentSize_.height + collisionThreshold;
	CGPoint v4[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v4, 4, YES);
	
#endif //LVK_SPRITE_SHOW_FRAME_RECT	
}

////////////////////////////////////////////////////////////////////////////////

// Returns the next line of data in file that we are currently parsing 
- (NSString *) nextLine
{
	NSString *line;
	
	// Ommit empty lines and comments
	do {
		line = [linesIterator nextObject];
				
		// TODO check what happens if the iterator has reached the end
		if (!line) {
			return line;
		}
		line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	} while ([line length] == 0 || [line hasPrefix:@"#"]);
	
	return line;	
}

- (BOOL) loadBinary: (NSString*)binFile andInfo: (NSString*)infoFile andError:(NSError**)error
{
	LKLOG(@"LvkSprite: === Sprite parsing started ===");
	LKLOG(@"LvkSprite: %@,%@", binFile, infoFile);

	[lvkAnimations removeAllObjects];
	
	const float fps = 1.0/24.0;
	
	NSData *binData = [NSData dataWithContentsOfFile:binFile options:0 error:error];
	if (*error != nil) {
		LKLOG(@"Error opening binary file: %@", [*error localizedDescription]);
		return NO;
	}else {
		*error = nil;
	}

	
	NSStringEncoding encoding;
	NSString *infoData = [NSString stringWithContentsOfFile:infoFile usedEncoding:&encoding error:error];
	if (*error != nil) {
		LKLOG(@"Error opening info file: %@", [*error localizedDescription]);
		return NO;
	}else {
		*error = nil;
	}
	NSArray *lines = [infoData componentsSeparatedByString:@"\n"];
	linesIterator = [lines objectEnumerator]; 

	NSMutableDictionary *frames = [[NSMutableDictionary alloc] initWithCapacity:10];
	NSArray *lineInfo;
	NSString* line;
	
	CCAnimation *nullAnim = [[CCAnimation alloc] initWithName:@"NullAnimation" delay:fps];
	[lvkAnimations setObject:nullAnim forKey:@"NullAnimation"];
		
	while ( (line = [self nextLine]) ) {	
				
		// parsing frames
		if ([line hasPrefix:@"fpixmaps("]) {
			for (line = [self nextLine]; ![line hasPrefix:@")"]; line = [self nextLine]) {

				// line format "frameId,offset,length"
				lineInfo = [line componentsSeparatedByString:@","];
				NSString *frameId = [lineInfo objectAtIndex: 0];
				NSUInteger offset = [[lineInfo objectAtIndex: 1] intValue];
				NSUInteger length = [[lineInfo objectAtIndex: 2] intValue];
				LKLOG(@"LvkSprite: Parsing frame: %@,%i,%i", frameId, offset, length);
				
				NSRange range = NSMakeRange(offset, length);
				NSString *CCFrameId = [NSString stringWithFormat:@"%@_%@", infoFile, frameId];
				[frames setObject:[binData subdataWithRange: range] forKey: CCFrameId];
			}
		}
		
		// parsing animations
		if ([line hasPrefix:@"animations("]){
						
			lvkAnimations = [[NSMutableDictionary alloc] init];
			
			for (line = [self nextLine]; ![line hasPrefix:@")"]; line = [self nextLine]) {
				
				// line format "animId,animName"
				//             "aframes("
				//             "    aframeId,frameId,delay,ox,oy"
				//             ")"
				lineInfo = [line componentsSeparatedByString:@","];
				NSString *animationId = [lineInfo objectAtIndex:0];
				NSString *animationName = [lineInfo objectAtIndex: 1];
				LKLOG(@"LvkSprite: Parsing animation: %@ %@", animationId, animationName);
				
				NSString *CCAnimationId = [NSString stringWithFormat:@"%@_%@", infoFile, animationId];
				CCAnimation *anim = [[CCAnimation alloc] initWithName:CCAnimationId delay:fps];
				
				line = [self nextLine];
				if (![line hasPrefix:@"aframes("]) {  
					LKLOG(@"LvkSprite: Error: Ill-formed sprite file: aframes(...) section expected, found '%@'", line);
				}
				
				NSInteger frameCount = 1; // it counts the number of the next frame to load
				float timeCount = 0; // holds the sum of the delays of all the sprites loaded so far
				
				// aframes parsing
				for (line = [self nextLine]; ![line hasPrefix:@")"]; line = [self nextLine]) {

					// line format "aframeId,frameId,delay,ox,oy"
					lineInfo = [line componentsSeparatedByString:@","];
					NSString* frameId = [lineInfo objectAtIndex: 1];					
					float duration = [[lineInfo objectAtIndex: 2] floatValue];
					//TODO use this values!
					//int ox = [[lineInfo objectAtIndex:3] intValue];
					//int oy = [[lineInfo objectAtIndex:4] intValue];
					
					//Delays in miliseconds
					timeCount += duration*0.001;
					
					while (frameCount*fps < timeCount) {
						NSString *CCFrameId = [NSString stringWithFormat:@"%@_%@", infoFile, frameId];
						[anim addFrameContent:[frames objectForKey:CCFrameId] withKey:CCFrameId];
						frameCount++;
					}
				}
				
				[lvkAnimations setObject:anim forKey:animationName];
								
				[anim release];
			}
		}
	}	
	[frames release];

	LKLOG(@"LvkSprite: === Sprite parsing ended ===");

	return TRUE;
}

////////////////////////////////////////////////////////////////////////////////

- (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n
{
	LKLOG(@"LvkSprite: Playing animation '%@' at (%f,%f) %i times", name, x, y, n);
	
	[self setPosition:ccp(x, y)];
	[self stopAnimation];
	
	CCAnimation *anim = [lvkAnimations objectForKey:name];

	if (anim != nil) {
		if (n > 0) {
			aniAction = [[LvkRepeatAction alloc] initWithAction:[CCAnimate actionWithAnimation:anim] times:n];
		} else if (n == -1) {
			aniAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:anim]];
		} else {
			aniAction = nil;
		}
		if (aniAction != nil) {
			[self runAction:aniAction];
		}
		animation = name;
	} else {
		LKLOG(@"LvkSprite: animation '%@' does not exist", name);
	}
}

- (void) playAnimation: (NSString *)name repeat:(int)n
{
	[self playAnimation:name atX:self.position.x atY:self.position.y repeat:n];
}


- (void) playAnimation: (NSString *)name
{
	[self playAnimation:name repeat:-1];
}

- (void) stopAnimation
{
	if (aniAction != nil && ![aniAction isDone]) {
		[self stopAction:aniAction];
		[aniAction release];
		aniAction = nil;
	}
}

- (BOOL) animationHasEnded
{
	if (aniAction == nil) {
		return YES;
	} else {
		return [aniAction isDone];
	}
}

@synthesize animation;
@synthesize lvkAnimations;

////////////////////////////////////////////////////////////////////////////////

#define COCOS_DIRTY_YES isTransformDirty_ = isInverseDirty_ = YES;

- (void) setX:(CGFloat)x
{
	COCOS_DIRTY_YES
	*px = x;
}

- (CGFloat) x
{
	return *px;
}

- (void) setY:(CGFloat)y
{
	COCOS_DIRTY_YES
	*py = y; 
}

- (CGFloat) y
{
	return *py;
}

- (void) setDx: (CGFloat)dx
{
	COCOS_DIRTY_YES
	*px += dx;
}

- (void) setDy: (CGFloat)dy
{
	COCOS_DIRTY_YES
	*py += dy; 
}

- (void) setDx: (CGFloat)dx andDy:(CGFloat)dy
{
	COCOS_DIRTY_YES
	*px += dx; 
	*py += dy; 
}

////////////////////////////////////////////////////////////////////////////////

- (void) moveX: (CGFloat)x withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveY: (CGFloat)y withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveX: (CGFloat)x andY:(CGFloat)y withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDx: (CGFloat)dx withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDy: (CGFloat)dy withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDy: (CGFloat)dx andDy:(CGFloat)dy withVelocity:(CGFloat)vel
{
	//TODO
}

- (BOOL) moveHasEnded
{
	//TODO
	return NO;
}

////////////////////////////////////////////////////////////////////////////////

- (CGRect) rect
{
	return CGRectMake(*px, *py, *pw, *ph);
}

@synthesize collisionThreshold;

- (CGRect) collisionRect
{
	return CGRectMake(*px - collisionThreshold, 
					  *py - collisionThreshold, 
					  *pw + collisionThreshold, 
					  *ph + collisionThreshold);
}

- (BOOL) collidesWithSprite:(LvkSprite *)spr
{
	return CGRectIntersectsRect(self.collisionRect, spr.collisionRect);
}

- (BOOL) collidesWithPoint:(CGPoint)point
{
	return CGRectContainsPoint(self.collisionRect, point);
}

- (BOOL) collidesWithRect:(CGRect)rect
{
	return CGRectIntersectsRect(self.collisionRect, rect);
}

@end
