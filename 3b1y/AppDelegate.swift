//
//  AppDelegate.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/16/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
	{
		// Override point for customization after application launch.
		/*
		Parse.enableLocalDatastore()
		
		// Initialize Parse.
		Parse.setApplicationId("UWmbYVob4Fsvh8HuIMRJdZohqTBZGqo0KCH3wdir", clientKey: "iVNhdAS3VHrX5XDpumTyp07mlsJg3ftVADCjCh1A")
		
		// [Optional] Track statistics around application opens.
		PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: {(completed, error) in })
		*/
		var userNotifcationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
		// Register for Push Notitications
		var settings = UIUserNotificationSettings(forTypes: userNotifcationTypes, categories: nil)
		application.registerUserNotificationSettings(settings)
		application.registerForRemoteNotifications()
		return true
	}

	func applicationWillResignActive(application: UIApplication)
	{
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication)
	{
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	func applicationWillEnterForeground(application: UIApplication)
	{
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication)
	{
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
	{
		//PFPush.handlePush(userInfo)
	}
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
	{
		// Store the deviceToken in the current installation and save it to Parse.
		/*var currentInstallation = PFInstallation.currentInstallation()
		currentInstallation.setDeviceTokenFromData(deviceToken)
		currentInstallation.channels = ["global"]
		currentInstallation.saveInBackgroundWithBlock({(completed, error) in })*/
	}
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
	{
		// Ask SPTAuth if the URL given is a Spotify authentication callback
		println(url)
		if (SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: "m3b1y://")))
		{
			// Call the token swap service to get a logged in session
			SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: hostingURL, callback: {(error, session) in
				if (error != nil)
				{
					log("Authentication Error! HELP!!!: \(error)")
					return
				}
				println(session)
				//[self playUsingSession:session];
			})
			return true
		}
		return false
	}
}

