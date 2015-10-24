//
//  UnityAppController+For3DTouch.h
//  Unity-iPhone
//
//  Created by Hua Cai on 15/10/10.
//
//

#import "UnityAppController.h"
#import <UIKit/UIApplicationShortcutItem.h>

typedef void (*registTouchEventCallbackFunc)(float, float);

@interface UnityAppController (For3DTouch)

+(void)UpdateForce:(NSSet<UITouch *>*) touches;
+(void)TouchesEndorCancelled:(NSSet<UITouch *>*) touches;
-(NSInteger)CheckForceTouchCapability;
-(BOOL)handleShortCutItem:(UIApplicationShortcutItem*) shortcutItem;
@end
