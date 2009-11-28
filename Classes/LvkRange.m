//
//  LvkRange.m
//  display_bin2image
//
//  Created by Gonzalo Buteler on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LvkRange.h"


@implementation LvkRange

@synthesize range;

-(id) initWithRange:(NSRange)r
{
	if ((self = [super init])){
		range= NSMakeRange(r.location, r.length);
	}
	return self;
}

@end
