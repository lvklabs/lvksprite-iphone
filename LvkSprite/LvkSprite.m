//
//  LvkSprite.m
//

#import "LvkSprite.h"
#import "LvkRepeatAction.h"

@implementation LvkSprite

- (id) initWithBinary: (NSString*)binFile andInfo: (NSString*)infoFile 
{
	if(!(self = [super init]))
		return self;
	
	[self loadBinary: binFile andInfo: infoFile];

	animation = nil;
	aniAction = nil;
	px = &(position_.x);
	py = &(position_.y);
	
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
	glColor4ub(255, 0, 255, 255);
	glLineWidth(1);
	int x = rect_.origin.x;
	int y = rect_.origin.y;
	int w = rect_.size.width;
	int h = rect_.size.height;
	CGPoint v[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v, 4, YES);

	//glColor4ub(0, 255, 0, 255);
	//ccDrawPoint(ccp(*px, *py));
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

- (BOOL) loadBinary: (NSString*)binFile andInfo: (NSString*)infoFile
{
	CCLOG(@"Debug: === Sprite parsing started ===");
	CCLOG(@"Debug: %@,%@", binFile, infoFile);
	
	[lvkAnimations removeAllObjects];
	
	const float fps = 1.0/24.0;
	
	NSData *binData = [NSData dataWithContentsOfFile: binFile];

	NSString *infoData = [NSString stringWithContentsOfFile: infoFile];
	NSArray *lines = [infoData componentsSeparatedByString:@"\n"];
	linesIterator = [lines objectEnumerator]; 

	NSMutableDictionary *frames = [[NSMutableDictionary alloc] initWithCapacity:0];
	NSArray *lineInfo;
	NSString* line;
		
	while ( (line = [self nextLine]) ) {	
				
		// parsing frames
		if ([line hasPrefix:@"fpixmaps("]) {
			for (line = [self nextLine]; ![line hasPrefix:@")"]; line = [self nextLine]) {

				// line format "frameId,offset,length"
				lineInfo = [line componentsSeparatedByString:@","];
				NSString *frameId = [lineInfo objectAtIndex: 0];
				NSUInteger offset = [[lineInfo objectAtIndex: 1] intValue];
				NSUInteger length = [[lineInfo objectAtIndex: 2] intValue];
				CCLOG(@"Debug: Parsing frame: %@,%i,%i", frameId, offset, length);
				
				NSRange range = NSMakeRange(offset, length);
				
				[frames setObject:[binData subdataWithRange: range] forKey: frameId];
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
				CCLOG(@"Debug: Parsing animation: %@ %@", animationId, animationName);
				
				CCAnimation *anim = [[CCAnimation alloc] initWithName:animationId delay:fps];
				
				line = [self nextLine];
				if (![line hasPrefix:@"aframes("]) {  
					CCLOG(@"Error: Ill-formed sprite file: aframes(...) section expected, found '%@'", line);
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
					[anim addFrameContent:[frames objectForKey:frameId] withKey:frameId];
						frameCount++;
					}
				}
				
				[lvkAnimations setObject:anim forKey:animationName];
								
				[anim release];
			}
		}
	}	
	[frames release];

	CCLOG(@"Debug: === Sprite parsing ended ===");

	return TRUE;
}

////////////////////////////////////////////////////////////////////////////////

- (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n
{
	NSLog(@"Debug: Playing animation '%@' at (%f,%f) %i times", name, x, y, n);
	
	[self setPosition:ccp(x, y)];
	
	CCAnimation *anim = [lvkAnimations objectForKey:name];
	
	if (anim != nil) {
		if (aniAction != nil && ![aniAction isDone]) {
			[self stopAction:aniAction];
			[aniAction release];
			aniAction = nil;
		}
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
		NSLog(@"Debug: animation '%@' does not exist", name);
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

- (BOOL) animationHasEnded
{
	if (aniAction == nil) {
		return YES;
	} else {
		return [aniAction isDone];
	}
}

@synthesize animation;

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

- (BOOL) collidesWithSprite:(LvkSprite *)spr
{
	//FIXME
	return CGRectIntersectsRect(rect_, spr->rect_);
/*
	CGFloat r1x = (rect_).origin.x;
	//int r1y = rect_.origin.y;
	CGFloat r1w = (rect_).size.width;
	//int r1h = rect_.size.height;
	
	CGFloat r2x = (spr->rect_).origin.x;
	//int r2y = spr->rect_.origin.y;
	CGFloat r2w = (spr->rect_).size.width;
	//int r2h = spr->rect_.size.height;
	
	if (r1x <=  r2x + r2w && 
		r1x + r1w >=  r2x) {
		NSLog(@"(%f,%f) (%f,%f) yes", r1x, r1w, r2x, r2w);
		return YES;
	} else {
		return NO;
	}
*/
}

- (BOOL) collidesWithPoint:(CGPoint)point
{
	//FIXME
	return CGRectContainsPoint(rect_, point);
}

- (BOOL) collidesWithRect:(CGRect)rect
{
	//FIXME
	return CGRectIntersectsRect(rect_, rect);
}

@end
