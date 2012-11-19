//
//  LvkSpriteCache.m
//  LvkSpriteProject
//
//  Created by Andres on 11/19/12.
//
//

#import "LvkSpriteCache.h"

static LvkSpriteCache *_sharedCache;

//----------------------------------------------------------------------------------------
// LvkSpriteCache
//----------------------------------------------------------------------------------------

@implementation LvkSpriteCache

+ (LvkSpriteCache*) sharedCache
{
    if (_sharedCache == nil) {
        @synchronized([LvkSpriteCache class])
        {
            if (_sharedCache == nil) {
                _sharedCache = [[LvkSpriteCache alloc] init];
            }
        }
    }
    return _sharedCache;
}

- (LvkSpriteCache *) init
{
    self = [super init];
    if (self != nil) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_cache release];
    
    [super dealloc];
}

- (void) setSprite:(CCSprite *)spr forKey:(NSString *)key
{
    [_cache setObject:spr forKey:key];
}

- (CCSprite *) spriteForKey:(NSString *)key
{
    return [_cache objectForKey:key];
}

- (void) removeSpriteForKey:(NSString *)key
{
    [_cache removeObjectForKey:key];
}

- (void) purge
{
    [_cache removeAllObjects];
}

@end
