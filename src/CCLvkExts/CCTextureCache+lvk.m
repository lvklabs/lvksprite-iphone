//
//  CCTextureCache+lvk.m
//  LvkSpriteProject
//
//  Copyright (c) 2012 LVK. All rights reserved.
//

#import "CCTextureCache+lvk.h"
#import "CCTexture2D+lvk.h"
#import "ccMacros.h"

@implementation CCTextureCache (CCLvkExt)

-(CCTexture2D*) addImageFromRawData: (NSData*) content withKey: (NSString*) key
{	
	CCTexture2D * tex = nil;
	
	// MUTEX:
	// Needed since addImageAsync calls this method from a different thread
	[dictLock_ lock];
	
	tex=[textures_ objectForKey: key]; 
	
	if( ! tex ) {
		// prevents overloading the autorelease pool
		UIImage *image = [[UIImage alloc] initWithData:content];
		tex = [ [CCTexture2D alloc] initWithImage: image];
		[image release];
		
		if( tex )
			[textures_ setObject: tex forKey:key];
		else
			CCLOG(@"cocos2d: Couldn't add image:%@ in CCTextureCache", key);
		
			// autorelease prevents possible crash in multithreaded environments
			[tex autorelease];
	}
	
	[dictLock_ unlock];
	
	return tex;	
}

#ifdef LVKSPRITE_PVR_ENABLED
-(CCTexture2D*) addPVRTCImageFromRawData: (NSData*)data withKey: (NSString*)key
{    
	CCTexture2D * tex;
	
	if( (tex=[textures_ objectForKey: key] ) ) {
		return tex;
	}
	
	tex = [[CCTexture2D alloc] initWithPVRTCData:data];
	if( tex )
		[textures_ setObject: tex forKey:key];
	else
		CCLOG(@"cocos2d: Couldn't add PVRTCImage in CCTextureCache");	
	
	return [tex autorelease];
}
#endif

@end