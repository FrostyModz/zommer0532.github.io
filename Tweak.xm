#include <substrate.h>
#include <UIKit/UIKit.h>

typedef void* CDUnknownBlockType;

@interface SpringBoard : NSObject
- (void)_relaunchSpringBoardNow;
@end

@interface SBDisplayItem : NSObject
@property(readonly, assign, nonatomic) NSString* displayIdentifier;
@end

#pragma mark iOS 8 (or legacy mode)

%hook SBAppSwitcherController

- (_Bool)switcherScroller:(id)arg1 isDisplayItemRemovable:(id)arg2 {
    return YES; /* maybe check if item == springboard first */
}

- (void)switcherScroller:(id)arg1 displayItemWantsToBeRemoved:(SBDisplayItem *)arg2 {
    if ([arg2.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
        [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
    }
    %orig;
}

%end

#pragma mark iOS 9

%hook SBDeckSwitcherViewController

- (_Bool)isDisplayItemOfContainerRemovable:(id)arg1 {
    return YES;
}

- (void)removeDisplayItem:(SBDisplayItem *)arg1 updateScrollPosition:(_Bool)arg2 forReason:(long long)arg3 completion:(CDUnknownBlockType)arg4 {
    if ([arg1.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
        [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
    }
    %orig;
}

%end
