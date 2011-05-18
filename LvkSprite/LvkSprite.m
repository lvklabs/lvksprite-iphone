//
//  LvkSprite.m
//

#import <Foundation/NSData.h>
#import "LvkSprite.h"
#import "LvkRepeatAction.h"
#import "common.h"

////////////////////////////////////////////////////////////////////////////////
// free_mem()
//
// TODO move this to another file

#import <mach/mach.h>      // freemem
#import <mach/mach_host.h> // freemem

natural_t free_mem() {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

////////////////////////////////////////////////////////////////////////////////

@interface LvkSprite ()

@property (readwrite, retain) NSString* animation;
@property (readwrite, retain) NSMutableDictionary* lvkAnimationsInternal;
@property (readwrite, retain) NSEnumerator* linesIterator;
@property (readwrite, retain) CCAction* aniAction;
@end

@implementation LvkSprite

@synthesize animation = _animation;
@synthesize lvkAnimationsInternal = _lvkAnimations;
@synthesize linesIterator = _linesIterator;
@synthesize aniAction = _aniAction;
@synthesize collisionThreshold;

- (NSDictionary*) lvkAnimations{
    return _lvkAnimations;
}

+ (id) spriteWithBinary: (NSString*)bin format:(LkobFormat)format andInfo: (NSString*)info andError:(NSError**)error{
    return [[[LvkSprite alloc] initWithBinary:bin format:format andInfo:info andError:error] autorelease];
}

- (id)init{
	if((self = [super init])){
        _lkobFormat = LkobStandar;
		_animation = nil;
		_aniAction = nil;
		px = &(position_.x);
		py = &(position_.y);
		pw = &(contentSize_.width);
		ph = &(contentSize_.height);
		collisionThreshold = 0;
		
		self.anchorPoint = CGPointMake(0, 0);
	}
	return self;
}

- (id) initWithBinary: (NSString*)binFile format:(LkobFormat)format andInfo: (NSString*)infoFile andError:(NSError**)error
{
	if((self = [super init])){
        _lkobFormat = format;
        
		[self loadBinary: binFile format:format andInfo: infoFile andError:error];

		_animation = nil;
		_aniAction = nil;
		px = &(position_.x);
		py = &(position_.y);
		pw = &(contentSize_.width);
		ph = &(contentSize_.height);
		collisionThreshold = 0;
		
		self.anchorPoint = CGPointMake(0, 0);
		
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
	SecureRelease(_animation);
	SecureRelease(_lvkAnimations);
	SecureRelease(_linesIterator);
	SecureRelease(_aniAction);
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
	
	//Color:magenta
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

	//Color:red
	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	//Color:purple
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
	
	//Color:green
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

	//Color:magenta
	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	//Color:dark green
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
		line = [self.linesIterator nextObject];
				
		// TODO check what happens if the iterator has reached the end
		if (!line) {
			return line;
		}
		line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	} while ([line length] == 0 || [line hasPrefix:@"#"]);
	
	return line;	
}

- (BOOL) loadBinary: (NSString*)binFile format:(LkobFormat)format andInfo: (NSString*)infoFile andError:(NSError**)error
{
	LKLOG(@"LvkSprite: === Sprite parsing started ===");
	LKLOG(@"LvkSprite: %@,%@", binFile, infoFile);
    LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);

	[self.lvkAnimationsInternal removeAllObjects];
	
	const float fps = 1.0/24.0;
	
	*error = nil;
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
	self.linesIterator = [lines objectEnumerator]; 

	NSMutableDictionary *frames = [NSMutableDictionary dictionaryWithCapacity:10];
	NSArray *lineInfo = nil;
	NSString* line = nil;
	
	CCAnimation *nullAnim = [[CCAnimation alloc] initWithName:@"NullAnimation" delay:fps];
	[self.lvkAnimationsInternal setObject:nullAnim forKey:@"NullAnimation"];
    [nullAnim release];
    
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
                LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
				
				NSRange range = NSMakeRange(offset, length);
				NSString *CCFrameId = [NSString stringWithFormat:@"%@_%@", infoFile, frameId];
				[frames setObject:[binData subdataWithRange: range] forKey: CCFrameId];
			}
		}
		
		// parsing animations
		if ([line hasPrefix:@"animations("]){
						
			self.lvkAnimationsInternal = [NSMutableDictionary dictionary];
			
			for (line = [self nextLine]; ![line hasPrefix:@")"]; line = [self nextLine]) {
				
				// line format "animId,animName"
				//             "aframes("
				//             "    aframeId,frameId,delay,ox,oy"
				//             ")"
				lineInfo = [line componentsSeparatedByString:@","];
				NSString *animationId = [lineInfo objectAtIndex:0];
				NSString *animationName = [lineInfo objectAtIndex: 1];
				LKLOG(@"LvkSprite: Parsing animation: %@ %@", animationId, animationName);
                LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
				
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
                        if (format == LkobStandar) {
                            [anim addFrameContent:[frames objectForKey:CCFrameId] withKey:CCFrameId];                            
                        } else {
                            [anim addFramePVRTCContent:[frames objectForKey:CCFrameId] withKey:CCFrameId];
                        }
						frameCount++;
					}
				}
				
				[self.lvkAnimationsInternal setObject:anim forKey:animationName];
				[anim release];
                
                // TODO check release frames???
			}
		}
	}

	LKLOG(@"LvkSprite: === Sprite parsing ended ===");

	return TRUE;
}

////////////////////////////////////////////////////////////////////////////////

- (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n
{
	LKLOG(@"LvkSprite: Playing animation '%@' at (%f,%f) %i times", name, x, y, n);
	
	[self setPosition:ccp(x, y)];
	[self stopAnimation];
	
	CCAnimation *anim = [self.lvkAnimations objectForKey:name];

	self.animation = nil;
	if (anim != nil) {
		if (n > 0) {
            self.aniAction = [[LvkRepeatAction alloc] initWithAction:[CCAnimate actionWithAnimation:anim] times:n];
		} else if (n == -1) {
			self.aniAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:anim]];
		} else {
			self.aniAction = nil;
		}
		if (self.aniAction != nil) {
			[self runAction:self.aniAction];
			self.animation = name;
		}
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
	if (self.aniAction != nil && ![self.aniAction isDone]) {
		[self stopAction:self.aniAction];
		self.aniAction = nil;
	}
}

- (BOOL) animationHasEnded
{
	if (self.aniAction == nil) {
		return YES;
	} else {
		return [self.aniAction isDone];
	}
}

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
