# ZCDebug
### Swift lightweight debug library.
Сonvenient library for debug purposes. Main focus is minimize developer time for debug. It's easy to use and understand.
Version 0.0.2 - uses Apple native Logger.

### Functions for debug:
* **_$c()** - log without message, it shows caller info.
* **_$l(obj)** - regular log, it should be used for all inconsiderable logs (response from API)
* **_$lw(obj)** - warning log, it should be used for situation when data is incorrect but app handle it and can work further
* **_$le(obj)** - error los, something is going wrong and should be fixed.
* **_$tf(obj)** - trace function(should be used on main thread only), it shows how much time system elapse to call this function
* **_$fail(\_ condition: Bool = true, reason: String)** - crash the application(works in debug mode only), it should be used for situation when application cann't start or work futher e.g. app failed to create a Data Base.

### Usage
Loggin function usage:
```Swift
func application(_ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {	
  _$l("This is regular debug")
  _$lw("This is warning debug")
  _$le("This is error debug")
  return true
}
```
xCode console will show:
```
💬 17:34:43.560 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 26   ~~ This is regular debug
❗ 17:34:43.561 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 27   ~~ This is warning debug
❌ 17:34:43.561 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 28   ~~ This is warning debug
```

Trace function usage:
```Swift
func application(_ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {	
  _$tf()
  sleep(2)
  return true
}
```
xCode console will show:
```
💬 17:42:43.224 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 26   ~~ Start application(_:didFinishLaunchingWithOptions:)
💬 17:42:45.580 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 26   ~~ Finished application(_:didFinishLaunchingWithOptions:) in 2.35600805282593
```

Assert function usage:
Assert function works only in Debug mode.
```Swift
func application(_ application: UIApplication, 
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {	
   var x = 0, y = 1
  _$fail(x < y, reason: "X should be less than Y")// or just _$fail(reason: "Data Base can not be migrated")
  return true
}
```
xCode console will show:
```
❌ 17:46:03.708 AppDelegate [application(_:didFinishLaunchingWithOptions:)] : 27   ~~ ❗❗❗ fail: X should be less than Y❗❗❗

0   TestApplication                     0x000000010aab49f7 _T011TestApplication6_$failySb_SS6reasonS2SSitF + 231
1   TestApplication                     0x000000010ac116dc _T011TestApplication11AppDelegateC11applicationSbSo13UIApplicationC_s10DictionaryVySC0F16LaunchOptionsKeyVypGSg022didFinishLaunchingWithI0tF + 348
2   TestApplication                     0x000000010ac133ba _T011TestApplication11AppDelegateC11applicationSbSo13UIApplicationC_s10DictionaryVySC0F16LaunchOptionsKeyVypGSg022didFinishLaunchingWithI0tFTo + 186
3   UIKit                               0x000000010d3db75b -[UIApplication _handleDelegateCallbacksWithOptions:isSuspended:restoreState:] + 278
4   UIKit                               0x000000010d3dd1d2 -[UIApplication _callInitializationDelegatesForMainScene:transitionContext:] + 4123
5   UIKit                               0x000000010d3e262b -[UIApplication _runWithMainScene:transitionContext:completion:] + 1677
6   UIKit                               0x000000010d7a4e4a __111-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:]_block_invoke + 866
7   UIKit                               0x000000010db77909 +[_UICanvas _enqueuePostSettingUpdateTransactionBlock:] + 153
8   UIKit                               0x000000010d7a4a86 -[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:] + 236
9   UIKit                               0x000000010d7a52a7 -[__UICanvasLifecycleMonitor_Compatability activateEventsOnly:withContext:completion:] + 675
10  UIKit                               0x000000010e1164d4 __82-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:]_block_invoke + 299
11  UIKit                               0x000000010e11636e -[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:] + 433
12  UIKit                               0x000000010ddfa62d __125-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:]_block_invoke + 221
13  UIKit                               0x000000010dff5387 _performActionsWithDelayForTransitionContext + 100
14  UIKit                               0x000000010ddfa4f7 -[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:] + 223
15  UIKit                               0x000000010db76fb0 -[_UICanvas scene:didUpdateWithDiff:transitionContext:completion:] + 392
16  UIKit                               0x000000010d3e0f0c -[UIApplication workspace:didCreateScene:withTransitionContext:completion:] + 515
17  UIKit                               0x000000010d9b3a97 -[UIApplicationSceneClientAgent scene:didInitializeWithEvent:completion:] + 361
18  FrontBoardServices                  0x0000000116e7e2f3 -[FBSSceneImpl _didCreateWithTransitionContext:completion:] + 331
19  FrontBoardServices                  0x0000000116e86cfa __56-[FBSWorkspace client:handleCreateScene:withCompletion:]_block_invoke_2 + 225
20  libdispatch.dylib                   0x00000001129e7848 _dispatch_client_callout + 8
21  libdispatch.dylib                   0x00000001129ece14 _dispatch_block_invoke_direct + 592
22  FrontBoardServices                  0x0000000116eb2470 __FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 24
23  FrontBoardServices                  0x0000000116eb212e -[FBSSerialQueue _performNext] + 439
24  FrontBoardServices                  0x0000000116eb268e -[FBSSerialQueue _performNextFromRunLoopSource] + 45
25  CoreFoundation                      0x0000000110bc0bb1 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
26  CoreFoundation                      0x0000000110ba54af __CFRunLoopDoSources0 + 271
27  CoreFoundation                      0x0000000110ba4a6f __CFRunLoopRun + 1263
28  CoreFoundation                      0x0000000110ba430b CFRunLoopRunSpecific + 635
29  GraphicsServices                    0x0000000113feaa73 GSEventRunModal + 62
30  UIKit                               0x000000010d3e40b7 UIApplicationMain + 159
31  TestApplication                     0x000000010ac19927 main + 55
32  libdyld.dylib                       0x0000000112a64955 start + 1
```

### P.S. I will be happy to extend and improve library. Let me know if you have any questions.
