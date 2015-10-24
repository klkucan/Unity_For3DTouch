//
//  UnityAppController+For3DTouch.m
//  Unity-iPhone
//
//  Created by Hua Cai on 15/10/10.
//
//

#import "UnityAppController+For3DTouch.h"

static BOOL isSupport3DTouch = NO;
static registTouchEventCallbackFunc touchEventCallback = nil;

@implementation UnityAppController (For3DTouch)



#pragma mark -
#pragma mark - about pressure sensitivity
/**
 *  注册压力变化后的处理函数
 *
 *  @param func 函数指针
 */
-(void)registTouchEventCallback:(registTouchEventCallbackFunc) func
{
    touchEventCallback = func;
}

/**
 *  检查设备是否具有3D touch功能
 *
 *  @return 0:not support 3d touch, 1:support
 */
-(NSInteger)CheckForceTouchCapability
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        isSupport3DTouch = NO;
        return 0;
    }
    if(self.rootViewController.view.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        isSupport3DTouch = YES;
        return 1;
    } else {
        isSupport3DTouch = NO;
        return 0;
    }
}

/**
 *  实时反馈压感
 *
 *  @param touches touch数据
 */
+(void)UpdateForce:(NSSet<UITouch *>*) touches
{
    if (isSupport3DTouch && touchEventCallback != nil) {
        touchEventCallback(touches.anyObject.force, touches.anyObject.maximumPossibleForce);
    }
    
}

/**
 *  touchesEnded或者touchesCancelled触发时的处理
 */
+(void)TouchesEndorCancelled:(NSSet<UITouch *>*) touches
{
    if (isSupport3DTouch && touchEventCallback != nil) {
        touchEventCallback(0, touches.anyObject.maximumPossibleForce);
    }
}

#pragma mark -
#pragma mark - about quick action

/**
 *  处理通过quick action进入应用的情况
 *
 *  @param shortcutItem 快捷键信息
 *
 *  @return 是否进行了处理
 */
-(BOOL)handleShortCutItem:(UIApplicationShortcutItem*) shortcutItem
{
    BOOL handled = NO;
    NSString *str = (NSString *)[shortcutItem.userInfo objectForKey:@"scene"];
    if (str != nil) {
        handled = YES;
        UnitySendMessage("Interface", "ExecuteQuickAction", [str UTF8String]);
    }
    
    return handled;
}


#pragma mark -
#pragma mark - about peek pop

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint) point
{
    //        UIViewController *childVC = [[UIViewController alloc] init];
    //        childVC.preferredContentSize = CGSizeMake(0.0f,0.0f);
    //
    //        CGRect rect = CGRectMake(0,0,0,0);//10, point.y - 10, self.view.frame.size.width - 20,20);
    //        context.sourceRect = rect;
    //        return childVC;
    //    PeekViewController *peekView = [[PeekViewController alloc] init];
    //    peekView.preferredContentSize = CGSizeMake(100, 100);
    //    CGRect rect = CGRectMake(0,0,0,0);//10, point.y - 10, self.view.frame.size.width - 20,20);
    //    context.sourceRect = rect;
    return nil;
}

- (void)previewContext:(id<UIViewControllerPreviewing>)context commitViewController:(UIViewController*)vc
{
    
    NSLog(@"pop");
    //[self showViewController:vc sender:self];
}

@end

#pragma mark -
#pragma mark - C Methods Imp

// 函数定义
#ifdef __cplusplus
extern "C" {
#endif
    extern int _checkForceTouchCapability();
    extern void _registTouchEventCallback(registTouchEventCallbackFunc func);
#ifdef __cplusplus
}
#endif

// 函数实现
#ifdef __cplusplus
extern "C" {
#endif
    
    int _checkForceTouchCapability()
    {
        return (int)[(UnityAppController *)[UIApplication sharedApplication].delegate CheckForceTouchCapability];
    }
    
    void _registTouchEventCallback(registTouchEventCallbackFunc func)
    {
        [(UnityAppController *)[UIApplication sharedApplication].delegate registTouchEventCallback:func];
    }

#ifdef __cplusplus
}
#endif
