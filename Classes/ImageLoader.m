//
//  LvkBin2ImageHelper.m
//  display_bin2image
//
//  Created by Gonzalo Buteler on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageLoader.h"


@implementation LvkBin2ImageHelper

@synthesize images;

-(id) initWithPath:(NSString *)path ranges:(NSArray*)rangesarray
{
	if ((self = [super init])){
		NSData *raw = [NSData dataWithContentsOfFile:path];
		images = [[NSMutableArray alloc] initWithCapacity:[rangesarray count]];
		for(LvkRange *range in rangesarray)
		{
			[images addObject:[[UIImage alloc] initWithData: [raw subdataWithRange:range.range]]];
		}
	}
	return self;
}  

@end
