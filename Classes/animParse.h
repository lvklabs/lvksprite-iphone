//
//  animParse.h
//  display_bin2image
//
//  Created by arkat on 26/09/09.
//  Copyright 2009 LavandInk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//workaround "property list format"
@interface animParse : NSObject {
	
@private
	// a dictionary mapping frameNames to Frame objects
	// (En esta versión el diccionario frameName --> frame es al pedo
	// porque cada frame es un archivo, identificado por su nombre)
	NSMutableDictionary *frames;
	// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *animations;
}

@property (readonly) NSDictionary *animations;

// fps should be 1/N where N is the number of frames per second
- (id) initWithBinary: (NSString*)binPath andInfo: (NSString*)infoPath andFrameRate:(float)fps;

- (NSDictionary*) getAnimations;

- (void) dealloc;

@end
