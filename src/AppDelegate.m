//
//  AppDelegate.m
//  VideoMetadataEditor
//
//  应用程序委托实现
//

#import "AppDelegate.h"
#import "VideoMetadataEditor.h"
#import "MenuManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // 创建主窗口
    NSRect frame = NSMakeRect(0, 0, 900, 700);
    NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | 
                                   NSWindowStyleMaskClosable | 
                                   NSWindowStyleMaskMiniaturizable | 
                                   NSWindowStyleMaskResizable;
    
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                              styleMask:styleMask
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    
    self.window.title = @"Video Metadata Editor";
    [self.window center];
    
    // 加载视图控制器
    VideoMetadataEditor *editorVC = [[VideoMetadataEditor alloc] initWithNibName:nil bundle:nil];
    self.window.contentViewController = editorVC;

    MenuManager *menuManager = [MenuManager sharedManager];
    menuManager.viewController = editorVC;
    NSMenu* mainMenu = [menuManager createMainMenu];
    [NSApp setMainMenu:mainMenu];
    
    // 显示窗口
    [self.window makeKeyAndOrderFront:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // 清理代码
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
