//
//  AppDelegate.h
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "Reachability.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navigationController;
    ViewController *viewController;
	NSString *relinkUserId;
    DBRestClient *restClient;
    
    NSMutableArray *toSending;
    
    NSMutableDictionary *listOfPathsNFilesDLD, *listOfPathsNFilesULD;//path - key , dest - name
    
    NSString *nowUDLDpath, *nowUDLDdest;//i need in this
    NSString *openedFolder;
    NSString *opFolderIOS;
    NSString *opFolderDB;
    
    BOOL isSelFolderProc;
    BOOL isfree;
    BOOL isFolIOS;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) DBRestClient *restClient;

@property (nonatomic, retain) NSMutableArray *toSending;

@property (nonatomic, retain) NSMutableDictionary *listOfPathsNFilesDLD;
@property (nonatomic, retain) NSMutableDictionary *listOfPathsNFilesULD;

@property (nonatomic, retain) NSString *nowUDLDpath;
@property (nonatomic, retain) NSString *nowUDLDdest;
@property (nonatomic, retain) NSString *openedFolder;
@property (nonatomic, retain) NSString *opFolderIOS;
@property (nonatomic, retain) NSString *opFolderDB;

@property (assign, nonatomic) NetworkStatus netStatus;
@property (strong, nonatomic) Reachability  *hostReach;

- (void)updateInterfaceWithReachability: (Reachability*) curReach;

- (DBRestClient *)restClient;

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata;
- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error;

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath;
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error;

- (void)GetList:(NSString *)path;
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata;
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error;

- (BOOL)isNetworkConnection;
- (NSArray*) GetListOfDirectories:(NSString*)path;
- (NSArray*) GetListOfFiles:(NSString*)path;
- (NSArray*) GetListOfAll:(NSString*)path;
- (NSMutableArray*) GetList:(NSString*)path Mode:(NSInteger)mode;
- (void)reloadTables;

- (NSString *)GetContentOfFile:(NSString *)path;
- (void)SetContentOfFile:(NSString *)path Text:(NSString *)txt;

- (void)SendFiles;

//Navigation
- (void)RowSelected:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath;
- (void)BackSelected;
- (void)ChangeFileSystem;
/////////////////////////////////////////////////////////////////


@end
