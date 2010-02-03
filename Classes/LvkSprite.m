//
//  LvkSprite.m
//
//  Created by arkat on 26/09/09.
//  Copyright 2009 LavandaInk. All rights reserved.
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

- (void) loadBinary: (NSString*)binFile andInfo: (NSString*)infoFile
{
	// TODO check alloc without dealloc/release! 
	
	float fps = 1.0/24.0;
	
	NSData *binData = [NSData dataWithContentsOfFile: binFile];
	
	NSMutableDictionary *frames = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	NSString *infoData = [NSString stringWithContentsOfFile: infoFile];
	NSArray *lines = [infoData componentsSeparatedByString:@"\n"];
	NSArray *lineInfo;
	NSEnumerator* linesIterator =[lines objectEnumerator]; 
	NSString* line;
	
	NSString *animationId;
	
	[lvkAnimations removeAllObjects];
	
	while ((line = [linesIterator nextObject])){	
		
		line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([line hasPrefix:@"#"]){
			continue;
		}
		
		// parsing frames
		// line format "frameId:offset:length"
		if ([line hasPrefix:@"fpixmaps("]){
			
			line = [linesIterator nextObject];
			line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			while (![line hasPrefix:@")"]){
				
				lineInfo = [line componentsSeparatedByString:@","];
				
				NSUInteger offset = [[lineInfo objectAtIndex: 1] intValue];
				NSUInteger length = [[lineInfo objectAtIndex: 2] intValue];
				
				NSRange range = NSMakeRange(offset, length);
				
				[frames setObject:[binData subdataWithRange: range] forKey: [lineInfo objectAtIndex: 0]];
				
				line = [linesIterator nextObject];
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			}
		}
		
		// parsing animations
		if ([line hasPrefix:@"animations("]){
			
			id animation;
			
			lvkAnimations = [[NSMutableDictionary alloc] init];
			
			line = [linesIterator nextObject];
			
			while (![line hasPrefix:@")"]){
				
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				if ([line hasPrefix:@"#"]){
					continue;
				}
				
				if([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
					line = [linesIterator nextObject];
					continue;
				}
				
				// We assume animId,animName
				lineInfo = [line componentsSeparatedByString:@","];
				
				animationId = [lineInfo objectAtIndex: 1];
				animation = [[Animation alloc] initWithName:[lineInfo objectAtIndex:0] delay:fps];
				
				[linesIterator nextObject]; // skip line aframes(
				
				line = [linesIterator nextObject];
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				NSInteger frameCount = 1; // it counts the number of the next frame to load
				float timeCount = 0; // holds the sum of the delays of all the sprites loaded so far
				
				// frame parsing/loading
				// each frame of the animation given by a line of the form
				// "frameName:duration"
				while(![line hasSuffix:@")"]){
					
					lineInfo = [line componentsSeparatedByString:@","];
					
					float duration = [[lineInfo objectAtIndex: 2] floatValue];
					NSString* frameName = [lineInfo objectAtIndex: 1];
					//TODO use this values!
					//int ox = [[lineInfo objectAtIndex:3] intValue];
					//int oy = [[lineInfo objectAtIndex:4] intValue];
					
					//Delays in miliseconds
					timeCount += duration*0.001;
					
					while(!(frameCount*fps > timeCount)) {
						[animation addFrameContent:[frames objectForKey:frameName] withKey:frameName];
						frameCount++;
					}
					
					line = [linesIterator nextObject];
					line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				}
				
				id temp = [[RepeatForever alloc] initWithAction:[Animate actionWithAnimation:animation]];
				
				[lvkAnimations setObject:temp forKey:animationId];
				line = [linesIterator nextObject];
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];			
			}
			
			line = [linesIterator nextObject];
			line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}
	}	
	
	[frames release];
}

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y
{
	if([lvkAnimations objectForKey:anim] != nil) {
		[self setPosition:ccp(x, y)];
		[self runAction:[lvkAnimations objectForKey:anim]];
	}
}

- (void) playAnimation: (NSString *)anim
{
	[self playAnimation:anim atX:150 atY:150];
}

@end
