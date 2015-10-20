//  ScriptName : Test
//  PojectName : For3DTouch
//
//  Created by AE Mobile Cai Hua on 10/14/2015 15:58:07.
//
//

using UnityEngine;
//  using System.Collections;
using UnityEngine.UI;
public class Test : MonoBehaviour
{
    float maximumPossibleForce = 0.0f;
    // Use this for initialization
    void Start()
    {
        if (InterfaceFor3DTouch.CheckForceTouchCapability() == 1)
        {
            InterfaceFor3DTouch.RegistTouchEventCallback(Change);
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void Change(float v, float maximumPossibleForce)
    {
        Debug.Log("force is " + v + "   maximumPossibleForce is " + maximumPossibleForce);
        gameObject.GetComponent<Slider>().value = v / maximumPossibleForce;
    }
}