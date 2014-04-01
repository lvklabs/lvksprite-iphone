//
//  LvkSpriteCache.h
//  LvkSpriteProject
//
//  Created by Andres on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LvkSpriteCache : NSObject
{
    NSMutableDictionary *_cache;
}

+ (LvkSpriteCache *) sharedCache;

- (void) setSprite:(CCSprite *)spr forKey:(NSString *)key;

- (CCSprite *) spriteForKey:(NSString *)key;

- (void) removeSpriteForKey:(NSString *)key;

- (void) purge;

@end
