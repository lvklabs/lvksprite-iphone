//
//  LvkAsyncLoader.h
//  LvkSpriteProject
//
//  Created by Andres on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "LvkSprite.h"

@interface LvkAsyncLoader : NSObject

- (LvkAsyncLoader *) init;

+ (LvkAsyncLoader *) sharedLoader;

- (void) preloadTexturesForSprite:(NSString*)baseName;

- (void) preloadTexturesForSprite:(NSString*)baseName animationIds:(NSArray *)ids;

- (void) preloadTexturesForBinary:(NSString*)binFile info:(NSString*)infoFile;

- (void) preloadTexturesForBinary:(NSString *)binFile info:(NSString *)infoFile animationIds:(NSArray *)ids;

@end
