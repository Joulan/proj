//
//  AppDelegate.m
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Base64.h"
#import "ViewController.h"

@interface AppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate> 

@end

@implementation AppDelegate

@synthesize window;// = _window;
@synthesize viewController;// = _viewController;
@synthesize navigationController;
@synthesize restClient;
@synthesize toSending;
@synthesize listOfPathsNFilesDLD;
@synthesize listOfPathsNFilesULD;
@synthesize nowUDLDpath;
@synthesize nowUDLDdest;
@synthesize openedFolder;
@synthesize opFolderIOS;
@synthesize opFolderDB;
@synthesize netStatus;
@synthesize hostReach;


- (void)dealloc {
    [window release];
    [viewController release];
    [navigationController release];
    [restClient release];
    [toSending release];
    [listOfPathsNFilesDLD release];
    [listOfPathsNFilesULD release];
    [nowUDLDpath release];
    [nowUDLDdest release];
    [openedFolder release];
    [opFolderIOS release];
    [opFolderDB release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    isFolIOS = TRUE;
    self.opFolderIOS = [[NSString alloc] initWithString:@"/"];
    self.openedFolder = [self.opFolderIOS copy];
    self.opFolderDB = [[NSString alloc] initWithString:@"/"];
    // Set these variables before launching the app
    NSString* appKey = @"mrfhg7sf5xdtqkf";
	NSString* appSecret = @"dxi2efn7rs2swcj";
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps 
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist = 
        [NSPropertyListSerialization 
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in endbox-Info.plist";
		}
	}
	
	DBSession* session = 
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    [session release];
	
	[DBRequest setNetworkRequestDelegate:self];
    
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
    
    //viewController.photoViewController = [[PhotoViewController new] autorelease];
    //if ([[DBSession sharedSession] isLinked]) {
    //    navigationController.viewControllers = 
    //    [NSArray arrayWithObjects: viewController, nil];
    //}
    
    // Add the navigation controller's view to the window and display.
    //[self.window addSubview:navigationController.view];
    //[self.window makeKeyAndVisible];
	
	NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSInteger majorVersion = 
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
	if (launchURL && majorVersion < 4) {
		// Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
		// iOS versions 3.2 or below
		[self application:application handleOpenURL:launchURL];
		return NO;
	}
    
    self.listOfPathsNFilesULD = [NSMutableDictionary dictionaryWithCapacity:3];
    self.listOfPathsNFilesDLD = [NSMutableDictionary dictionaryWithCapacity:3];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    [self updateInterfaceWithReachability: hostReach];
    
    isSelFolderProc = FALSE;
    isfree = TRUE;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (TRUE) {
            if (self.netStatus != NotReachable) {
                if([self.listOfPathsNFilesULD count] > 0 && isfree) {
                    isfree = FALSE;
                    NSString *path = [[[self.listOfPathsNFilesULD allKeys] objectAtIndex:0] copy];
                    NSString *dest = [[self.listOfPathsNFilesULD objectForKey:path] copy];
                    self.nowUDLDpath = path;
                    self.nowUDLDdest = dest;
                    [self.listOfPathsNFilesULD removeObjectForKey:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[self restClient] uploadFile:[self.nowUDLDpath lastPathComponent] toPath:self.nowUDLDdest
                            withParentRev:nil fromPath:self.nowUDLDpath];
                    });
                } 
                if([self.listOfPathsNFilesDLD count] > 0 && isfree) {
                    isfree = FALSE;
                    NSString *path = [[[self.listOfPathsNFilesDLD allKeys] objectAtIndex:0] copy];
                    NSString *dest = [[self.listOfPathsNFilesDLD objectForKey:path] copy];
                    dest = [dest stringByAppendingPathComponent:[path lastPathComponent]];
                    [self.listOfPathsNFilesDLD removeObjectForKey:path];        
                    self.nowUDLDpath = path;
                    self.nowUDLDdest = dest;
                    [self.listOfPathsNFilesDLD removeObjectForKey:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[self restClient] loadFile:self.nowUDLDpath intoPath:self.nowUDLDdest];
                    });
                }
                self.viewController.changeBarButton1.enabled = self.viewController.changeBarButton2.enabled = TRUE;
                self.viewController.sendBarButton1.enabled = self.viewController.sendBarButton2.enabled = TRUE;
                self.viewController.linkBarButton1.enabled = self.viewController.linkBarButton2.enabled = TRUE;
            } else {
                if(!isFolIOS)
                    [self ChangeFileSystem];
                self.viewController.changeBarButton1.enabled = self.viewController.changeBarButton2.enabled = FALSE;
                self.viewController.sendBarButton1.enabled = self.viewController.sendBarButton2.enabled = FALSE;
                self.viewController.linkBarButton1.enabled = self.viewController.linkBarButton2.enabled = FALSE;
            }
        }
    });
    
    return YES;
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    self.netStatus = [curReach currentReachabilityStatus];
}

- (void) reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		if ([[DBSession sharedSession] isLinked]) {
			[navigationController pushViewController:viewController animated:YES];
		}
		return YES;
	}
	return NO;
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}



//////////////////////////////////////////////////////////////////////////////////////////
/*      UPLOAD        */
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:srcPath error:&error];
    [self.nowUDLDpath retain];
    [self.nowUDLDdest retain];
    isfree = TRUE;
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    //NSLog(@"File upload failed with error - %@", error);
    /*[[[[UIAlertView alloc] 
	   initWithTitle:@"File didn't uploaded" message:@"Sorry, but try again" delegate:self
	   cancelButtonTitle:@"Okay" otherButtonTitles:nil]
	  autorelease]
	 show];*/
    [[self restClient] uploadFile:[self.nowUDLDpath lastPathComponent] toPath:self.nowUDLDdest
                    withParentRev:nil fromPath:self.nowUDLDpath];
}
//////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////
/*      DOWNLOAD        */
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
//    NSLog(@"File loaded into path: %@", localPath);
    NSString *pth = localPath;
    NSString *content = [self GetContentOfFile:pth];
    NSData *datacontent = [Base64 decode:content];
    pth = [pth substringToIndex:([pth length] - 3)];
    [datacontent writeToFile:pth atomically:YES];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:localPath error:&error];
    isfree = TRUE;
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    //NSLog(@"There was an error loading the file - %@", error);
    [[self restClient] loadFile:self.nowUDLDpath intoPath:self.nowUDLDdest];
}
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
- (void)GetList:(NSString *)path {
    [[self restClient] loadMetadata:path];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        self.openedFolder = metadata.path;
        NSMutableArray *ld1 = [[NSMutableArray alloc] init];
        NSMutableArray *ld2 = [[NSMutableArray alloc] init];
        for (DBMetadata *file in metadata.contents) {
            if(file.isDirectory)
                [ld1 addObject:file.filename];
            else
                [ld2 addObject:file.filename];
        }
        self.viewController.listDataOfDirectories = [ld1 copy];
        self.viewController.listDataOfFiles = ld2;
        [ld1 addObjectsFromArray:ld2];
        [ld2 release];
        self.viewController.listDataOfAll = ld1;
        [ld1 release];
        [self.viewController.tableView1 reloadData];
        [self.viewController.tableView2 reloadData];
        [self.viewController.tableView3 reloadData];
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

- (NSArray*) GetListOfDirectories:(NSString*)path {
    NSMutableArray *lod = [self GetList:path Mode:1];
    NSArray *reslod = [lod copy];
    [lod release];
    return reslod;
}

- (NSArray*) GetListOfFiles:(NSString*)path {
    NSMutableArray *lof = [self GetList:path Mode:2];
    NSArray *reslof = [lof copy];
    [lof release];
    return reslof;
}

- (NSArray*) GetListOfAll:(NSString*)path {
    NSMutableArray *loa = [self GetList:path Mode:3];
    NSArray *resloa = [loa copy];
    [loa release];
    return resloa;
}

//mode : 1-directoeies, 2-files, other-all
- (NSMutableArray*) GetList:(NSString*)path Mode:(NSInteger)mode {
    NSError * error;
    NSURL * url = [[NSURL alloc] initWithString:self.openedFolder];
    if(url == nil)
        return nil;
    NSArray * directoryContents = [ [NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys: [NSArray arrayWithObjects: NSURLCreationDateKey, NSURLNameKey, nil] options:0 error:&error ];
    NSMutableArray *ld1 = [[NSMutableArray alloc] init];
    NSMutableArray *ld2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [directoryContents count]; i++) {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[[directoryContents objectAtIndex:i] path] isDirectory:&isDir];
        if(isDir)
            [ld1 addObject:[[directoryContents objectAtIndex:i] lastPathComponent]];
        else
            [ld2 addObject:[[directoryContents objectAtIndex:i] lastPathComponent]];
    }
    [url release];
    switch (mode) {
        case 1:
            [ld2 release];
            return ld1;
        case 2:
            [ld1 release];
            return ld2;
    }
    [ld1 addObjectsFromArray:ld2];
    [ld2 release];
    return ld1;
}
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)GetContentOfFile:(NSString *)path {
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return text;
}

- (void)SetContentOfFile:(NSString *)path Text:(NSString *)txt {
    NSError *error;
    [txt writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
/////////////////////////////////////////////////////////////////////////////////////////


- (void)reloadTables {
    if (isFolIOS) {
        self.viewController.listDataOfDirectories = [self GetListOfDirectories:openedFolder];
        self.viewController.listDataOfFiles = [self GetListOfFiles:openedFolder];
        self.viewController.listDataOfAll = [self GetListOfAll:openedFolder];
        [self.viewController.tableView1 reloadData];
        [self.viewController.tableView2 reloadData];
        [self.viewController.tableView3 reloadData];
    } else {
        [self GetList:openedFolder];
    }
}

- (void)RowSelected:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.viewController.tableView2) {
        self.openedFolder = [openedFolder stringByAppendingPathComponent:[self.viewController.listDataOfDirectories objectAtIndex:row]];
        if (!isSelFolderProc) {
            [self.toSending release];
            self.toSending = nil;
        }
    } else {
        if([self.viewController.listDataOfDirectories containsObject:[self.viewController.listDataOfAll objectAtIndex:row]]) {
            self.openedFolder = [openedFolder stringByAppendingPathComponent:[self.viewController.listDataOfAll objectAtIndex:row]];
            if (!isSelFolderProc) {
                [self.toSending release];
                self.toSending = nil;
            }
        } else {              
            if ([self.toSending containsObject:[self.viewController.listDataOfAll objectAtIndex:row]]) {
                NSString *filename = [self.viewController.listDataOfAll objectAtIndex:row];
                [self.toSending removeObject:filename];
            } else {
                if(self.toSending == nil) {
                    self.toSending = [[NSMutableArray alloc] initWithCapacity:1];
                }
                NSString *filename = [self.viewController.listDataOfAll objectAtIndex:row];
                [self.toSending insertObject:filename atIndex:0];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self reloadTables];
}

- (void)BackSelected {
    self.openedFolder = [openedFolder stringByDeletingLastPathComponent];
    [self reloadTables];
}

- (void)ChangeFileSystem {
    if (self.netStatus == NotReachable && isFolIOS)
        return;
    if (![[DBSession sharedSession] isLinked] && isFolIOS)
        return;
    isFolIOS = !isFolIOS;
    if(isFolIOS)
        self.opFolderDB = [self.openedFolder copy];
    else
        self.opFolderIOS = [self.openedFolder copy];
    [self.openedFolder release];
    self.openedFolder = (isFolIOS) ? [opFolderIOS copy] : [opFolderDB copy];
    [self reloadTables];
    if(isFolIOS)
        self.viewController.changeBarButton1.title = self.viewController.changeBarButton2.title = @"To DB";
    else
        self.viewController.changeBarButton1.title = self.viewController.changeBarButton2.title = @"To IOS";
}

- (void)SendFiles {
    if(isSelFolderProc) {
        for (int i = 0; i < [self.toSending count]; i++) {
            NSString *filename = [self.toSending objectAtIndex:i];
            NSString *path = [(isFolIOS) ? opFolderDB : opFolderIOS stringByAppendingPathComponent:filename];
            NSString *dest = self.openedFolder;
        
            if(isFolIOS) {
                [self.listOfPathsNFilesDLD setObject:dest forKey:path];
            }
            else {
                NSData *datacontent = [[NSData alloc] initWithContentsOfFile:path];
                NSString *result = [Base64 encode:datacontent];
                path = [path stringByAppendingString:@"dbx"];
                [self SetContentOfFile:path Text:result];
                
                [self.listOfPathsNFilesULD setObject:dest forKey:path];
            }
        }
        isSelFolderProc = FALSE;
        self.viewController.changeBarButton1.enabled = self.viewController.changeBarButton2.enabled = TRUE;
        self.viewController.linkBarButton1.enabled = self.viewController.linkBarButton2.enabled = TRUE;
    } else {
        [self ChangeFileSystem];
        isSelFolderProc = TRUE;
        self.viewController.changeBarButton1.enabled = self.viewController.changeBarButton2.enabled = FALSE;
        self.viewController.linkBarButton1.enabled = self.viewController.linkBarButton2.enabled = FALSE;
    }
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = [userId retain];
	[[[[UIAlertView alloc] 
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self 
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
	  autorelease]
	 show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:relinkUserId fromController:viewController];
	}
	[relinkUserId release];
	relinkUserId = nil;
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
