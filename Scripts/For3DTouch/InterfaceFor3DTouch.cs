//  ScriptName : InterfaceFor3DTouch
//  PojectName : For3DTouch
//
//  Created by AE Mobile Cai Hua on 10/13/2015 15:01:53.
//
//

using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;

public class InterfaceFor3DTouch : MonoBehaviour
{
    private delegate void touch_event_callback_delegate(float force, float maximumPossibleForce);

    private static Action<float, float> touchEventCallback;


    #region C code
    [DllImport("__Internal")]

    private static extern void _registTouchEventCallback(touch_event_callback_delegate func);

    [DllImport("__Internal")]
    // return 1 when device is support 3d touch
    private static extern int _checkForceTouchCapability();

    #endregion

    public static void RegistTouchEventCallback(Action<float, float> func)
    {
        touchEventCallback = func;
        _registTouchEventCallback(ExecuteTouchEventCallback);
    }

    public static int CheckForceTouchCapability()
    {
        return _checkForceTouchCapability();
    }

    [MonoPInvokeCallback(typeof(touch_event_callback_delegate))]
    private static void ExecuteTouchEventCallback(float force, float maximumPossibleForce)
    {
        touchEventCallback(force, maximumPossibleForce);
    }
    
    private void ExecuteQuickAction(string para)
    {
        Application.LoadLevel(para);
    }
    
}