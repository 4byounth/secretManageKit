//
//  AppDelegate.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

