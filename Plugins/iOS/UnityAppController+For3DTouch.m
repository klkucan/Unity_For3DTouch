//
//  UnityAppController+For3DTouch.m
//  Unity-iPhone
//
//  Created by Hua Cai on 15/10/10.
//
//

#import "UnityAppController+For3DTouch.h"

static BOOL isSupport3DTouch = NO;
static registTouchEventCallbackFunc callback = nil;

@implementation UnityAppController (For3DTouch)

/**
 *  注册压力变化后的处理函数
 *
 *  @param func 函数指针
 */
-(void)registTouchEventCallback:(registTouchEventCallbackFunc) func
{
    callback = func;
}

#pragma mark -
#pragma mark - about pressure sensitivity


/**
 *  检查设备是否具有3D touch功能
 *
 *  @return 结果
 */
-(BOOL)CheckForceTouchCapability
{
    if(self.rootViewController.view.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        isSupport3DTouch = YES;
        return YES;
    } else {
        isSupport3DTouch = NO;
        return NO;
    }
}

/**
 *  实时反馈压感
 *
 *  @param touches touch数据
 */
+(void)UpdateForce:(NSSet<UITouch *>*) touches
{
    if (isSupport3DTouch && callback != nil) {
        callback(touches.anyObject.force, touches.anyObject.maximumPossibleForce);
    }
    
}

/**
 *  touchesEnded或者touchesCancelled触发时的处理
 */
+(void)TouchesEndorCancelled:(NSSet<UITouch *>*) touches
{
    if (isSupport3DTouch && callback != nil) {
        callback(0, touches.anyObject.maximumPossibleForce);
    }
}

#pragma mark -
#pragma mark - about quick action


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
    extern void _registTouchEventCallback(registTouchEventCallbackFunc func);
    extern int _checkForceTouchCapability();
#ifdef __cplusplus
}
#endif

// 函数实现
#ifdef __cplusplus
extern "C" {
#endif
    
    void _registTouchEventCallback(registTouchEventCallbackFunc func)
    {
        [(UnityAppController *)[UIApplication sharedApplication].delegate registTouchEventCallback:func];
    }
    
    int _checkForceTouchCapability()
    {
        UnityAppController *uac = (UnityAppController *)[UIApplication sharedApplication].delegate;
        if ([uac CheckForceTouchCapability]) {
            isSupport3DTouch = YES;
            return 1;
        } else {
            isSupport3DTouch = NO;
            return 0;
        }
    }
#ifdef __cplusplus
}
#endif
