//
//  LvkSprite.m
//

#import "LvkSprite.h"

@implementation LvkSprite

- (id) initWithBinary: (NSString*)binFile andInfo: (NSString*)infoFile 
{
	if(!(self = [super init]))
		return self;
	
	[self loadBinary: binFile andInfo: infoFile];
  
	return self;
}

- (void) dealloc {
	[lvkAnimations release];
	[super dealloc];
}

// Return the next line of data in file that we are currently parsing 
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
				
				id temp = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:anim]];
				[lvkAnimations setObject:temp forKey:animationName];
				
				[anim release];
				[temp release];
			}
		}
	}	
	[frames release];

	CCLOG(@"Debug: === Sprite parsing ended ===");

	return TRUE;
}

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y repeat:(int)n
{
	if ([lvkAnimations objectForKey:anim] != nil) {
		[self setPosition:ccp(x, y)];
		[self runAction:[lvkAnimations objectForKey:anim]];
	} else {
		// TODO log error
	}
}

- (void) playAnimation: (NSString *)anim repeat:(int)n
{
	[self playAnimation:anim atX:self.position.x atY:self.position.y repeat:n];
}


- (void) playAnimation: (NSString *)anim
{
	[self playAnimation:anim repeat:-1];
}

- (BOOL) animationHasEnded
{
	return FALSE;
}

@end
