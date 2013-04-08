//
//  AppDelegate.h
//  endbox
//
//  Created by Mac on 05.04.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navigationController;
    ViewController *viewController;
	NSString *relinkUserId;
    DBRestClient *restClient;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) DBRestClient *restClient;

- (DBRestClient *)restClient;

- (void)uploadFile:(NSString *)path Destination:(NSString *)dest;
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata;
- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error;

- (void)downloadFile:(NSString *)path Destination:(NSString *)dest;
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath;
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error;

- (void)GetList:(NSString *)path;
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata;
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error;

@end
