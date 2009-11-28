// DEPRECATED
//
//  AnimationData.h
//  display_bin2image
//
//  Created by Pablo C on 9/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AnimationData : NSObject {
	@private
	
	NSString* title;
	NSArray* framesData;
	NSEnumerator* framesDataEnumerator;
	
	
}

@property (retain) NSArray* framesData;
@property (retain) NSEnumerator* framesDataEnumerator;
@property (retain) NSString* title;

- (id) initWithNumberOfFrames: (NSInteger) f;
- (NSInteger*) nextFrameId;
- (NSInteger*) nextFrameDuration;
- (NSInteger*) hasNextFrame;

- (void) addFrameWithId:(NSInteger*) id andDuration:(NSInteger*) d;

@end
