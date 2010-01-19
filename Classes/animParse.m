//
//  animParse.m
//  display_bin2image
//
//  Created by arkat on 26/09/09.
//  Copyright 2009 LavandaInk. All rights reserved.
//

#import "animParse.h"

@implementation animParse

@synthesize animations,ourScene,ourLayer;

- (id) initWithBinary: (NSString*)binPath andInfo: (NSString*)infoPath andFrameRate:(float)fps  andScene:(Scene*)myScene andLayer:(Layer*)myLayer{

	if(!(self = [super init]))
		return self;

	ourScene = myScene;
	ourLayer = myLayer;
	
	NSData *binFile = [NSData dataWithContentsOfFile: binPath];

	NSMutableDictionary *frames = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	NSString *infoFile = [NSString stringWithContentsOfFile: infoPath];
	NSArray *lines = [infoFile componentsSeparatedByString:@"\n"];
	NSArray *lineInfo;
	NSEnumerator* linesIterator =[lines objectEnumerator]; 
	NSString* line;
	
	NSString *animationId;
	
	while ((line = [linesIterator nextObject])){	
		
		line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([line hasPrefix:@"#"]){
			continue;
		}
		
		//parseo frames
		//cada uno en una linea de la forma "frameId:offset:length"
		if ([line hasPrefix:@"fpixmaps("]){
	
			line = [linesIterator nextObject];
			line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			
			while (![line hasPrefix:@")"]){
				
				lineInfo = [line componentsSeparatedByString:@","];
				
				NSUInteger offset = [[lineInfo objectAtIndex: 1] intValue];
				NSUInteger length = [[lineInfo objectAtIndex: 2] intValue];
		
				NSRange range = NSMakeRange(offset, length);
				
				[frames setObject:[binFile subdataWithRange: range] forKey: [lineInfo objectAtIndex: 0]];

				line = [linesIterator nextObject];
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			}
		}
		
		//parseo animations
		if ([line hasPrefix:@"animations("]){
			
			id animation;

			animations = [[NSMutableDictionary alloc] init];

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
					
				[linesIterator nextObject]; // Saltamos la linea aframes(
				
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
						
					//Delays in miliseconds
					timeCount += duration*0.001;
						
					while(!(frameCount*fps > timeCount)) {
						[animation addFrameContent:[frames objectForKey:frameName] withKey:frameName];
						frameCount++;
					}
						
					line = [linesIterator nextObject];
					line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				}
				
				id temp = [[RepeatForever alloc] initWithAction:[[Animate alloc] initWithAnimation:animation]];

				[animations setObject:temp forKey:animationId];
				line = [linesIterator nextObject];
				line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];			
			}

			line = [linesIterator nextObject];
			line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}
		
	}
  
	return self;
}

- (void) dealloc {
	[animations dealloc];
	[super dealloc];
}

// I have written this method since I thought it would be convenient to
// return a static NSDictionary instead of a mutable one, but may be it´s not
// so necessary

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y{
	if([animations objectForKey:anim] != nil){
		Sprite *temp = [Sprite spriteWithFile:@"bg.png"];
		[temp setPosition:ccp(x, y)];
		[temp runAction:[animations objectForKey:anim]];
		[ourLayer addChild:temp z:1];
/*		Sprite *temp1 = [Sprite spriteWithFile:@"bg.png"];
		 Sprite *temp2 = [Sprite spriteWithFile:@"bg.png"];
		 [temp1 setPosition:ccp(0, 0)];
		 [temp1 runAction:[animations objectForKey:@"punch"]];
		 [temp2 setPosition:ccp(0, 0)];
		 [temp2 runAction:[animations objectForKey:@"kick"]];		 
		 [ourLayer addChild:temp1 z:3];
		 [ourLayer addChild:temp2 z:2];*/
	}
}

- (void) playAnimation: (NSString *)anim{
	[self playAnimation:anim atX:150 atY:150];
}

- (void) moveAnimation: (NSString *)anim fromX:(int)origX fromY:(int)origY toX:(int)destX toY:(int)destY during:(float)time {
	if([animations objectForKey:anim] != nil){
		Sprite *temp = [Sprite spriteWithFile:@"bg.png"];
		[temp setPosition:ccp(origX, origY)];		
		[temp runAction:[animations objectForKey:anim]];
		id movement = [MoveTo actionWithDuration:time position:ccp(destX,destY)];
		[temp runAction:movement];
		[ourLayer addChild:temp z:1];
	}
}

@end
