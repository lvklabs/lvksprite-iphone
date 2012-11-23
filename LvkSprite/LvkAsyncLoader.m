//
//  LvkAsyncLoader.m
//  LvkSpriteProject
//
//  Created by Andres on 11/19/12.
//
//

#import "LvkAsyncLoader.h"
#import "common.h"

static LvkAsyncLoader *_sharedLoader;

//----------------------------------------------------------------------------
// LvkAsyncLoader
//----------------------------------------------------------------------------

@implementation LvkAsyncLoader

+ (LvkAsyncLoader *) sharedLoader
{
    if (_sharedLoader == nil) {
        //@synchronized([LvkAsyncLoader class])
        {
            if (_sharedLoader == nil) {
                _sharedLoader = [[LvkAsyncLoader alloc] init];
            }
        }
    }
    
    return _sharedLoader;
}

- (LvkAsyncLoader *) init
{
    return [super init];
}

- (void) preloadTexturesForSprite:(NSString *)baseName
{
    [self preloadTexturesForSprite:baseName animationIds:nil];
}

- (void) preloadTexturesForSprite:(NSString *)baseName animationIds:(NSArray *)ids
{
    NSString *lkobFile = [[NSBundle mainBundle] pathForResource:baseName ofType:@"lkob"];
    NSString *lkotFile = [[NSBundle mainBundle] pathForResource:baseName ofType:@"lkot"];
    
    [self preloadTexturesForBinary:lkobFile info:lkotFile animationIds:ids];
}

- (void) preloadTexturesForBinary:(NSString *)binFile info:(NSString *)infoFile
{
    [self preloadTexturesForBinary:binFile info:infoFile animationIds:nil];
}

- (void) preloadTexturesForBinary:(NSString *)binFile info:(NSString *)infoFile animationIds:(NSArray *)ids
{
    NSMutableArray *ctx = [NSMutableArray arrayWithObjects:binFile, infoFile, nil];
    
    if (ids != nil) {
        [ctx addObject:ids];
    }
    
    [self performSelectorInBackground:@selector(_preloadTexturesWithContext:) withObject:ctx];
}

- (void) _preloadTexturesWithContext:(NSArray*)ctx
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EAGLContext *auxGLcontext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1
                                                      sharegroup:[[[[CCDirector sharedDirector] openGLView] context] sharegroup]];
    [EAGLContext setCurrentContext:auxGLcontext];

    //LKLOG(@"LvkAsyncLoader - ctx %@", ctx);

    NSString *binFile = [ctx objectAtIndex:0];
    NSString *infoFile = [ctx objectAtIndex:1];
    NSArray *ids = nil;
    
    if (ctx.count > 2) {
        ids = [ctx objectAtIndex:2];
    }

    LKLOG(@"LvkAsyncLoader - Preloading textures for file %@", binFile);
    
    [LvkSprite preloadTextures:binFile info:infoFile animationIds:ids];
    
    LKLOG(@"LvkAsyncLoader - Preload end for file %@", binFile);

    [EAGLContext setCurrentContext:nil];
    [auxGLcontext release];
    
    [pool release];
}

@end
