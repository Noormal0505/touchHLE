// main.m
// touchHLE iOS port
// SDL2 on iOS requires UIApplicationMain to be called from C/ObjC,
// which then hands control to our Swift AppDelegate.

#import <UIKit/UIKit.h>

// Forward-declare SDL_main which SDL2 uses internally on iOS.
// We don't use it directly, but linking SDL2 requires this symbol.
extern int SDL_main(int argc, char *argv[]);

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
