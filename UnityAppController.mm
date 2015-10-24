
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	::printf("-> applicationDidFinishLaunching()\n");

	// send notfications
	if(UILocalNotification* notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey])
		UnitySendLocalNotification(notification);

	if(NSDictionary* notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
		UnitySendRemoteNotification(notification);

	if ([UIDevice currentDevice].generatesDeviceOrientationNotifications == NO)
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

	UnityInitApplicationNoGraphics([[[NSBundle mainBundle] bundlePath] UTF8String]);

	[self selectRenderingAPI];
	[UnityRenderingView InitializeForAPI:self.renderingAPI];

	_window			= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_unityView		= [self createUnityView];

	[DisplayManager Initialize];
	_mainDisplay	= [DisplayManager Instance].mainDisplay;
	[_mainDisplay createWithWindow:_window andView:_unityView];

	[self createUI];
	[self preStartUnity];

	// if you wont use keyboard you may comment it out at save some memory
	[KeyboardDelegate Initialize];

    
    BOOL launchedFromShortCut = NO;
    //Check for ShortCutItem
    if (launchOptions != nil) {
        UIApplicationShortcutItem *item = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (item != nil) {
            launchedFromShortCut = YES;
            [self handleShortCutItem:item];
        }
    }
    
    //Return false incase application was lanched from shorcut to prevent
    //application(_:performActionForShortcutItem:completionHandler:) from being called
    return !launchedFromShortCut;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler {
    BOOL bHandledShortCutItem = [self handleShortCutItem:shortcutItem];
    completionHandler(bHandledShortCutItem);
}
