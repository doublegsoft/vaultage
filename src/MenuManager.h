//
//  MenuManager.h
//  VideoMetadataEditor
//
//  菜单管理类 - 管理应用程序的所有菜单
//

#import <Cocoa/Cocoa.h>

@class VideoMetadataEditor;

@interface MenuManager : NSObject

// 单例
+ (instancetype)sharedManager;

// 主菜单栏
@property (strong, nonatomic) NSMenu *mainMenu;

// 视图控制器引用（用于菜单操作）
@property (weak, nonatomic) VideoMetadataEditor *viewController;

// 创建完整的菜单结构
- (NSMenu *)createMainMenu;

// 菜单操作方法
- (void)newDocument:(id)sender;
- (void)openDocument:(id)sender;
- (void)saveDocument:(id)sender;
- (void)exportAsJSON:(id)sender;
- (void)exportAsCSV:(id)sender;
- (void)importFromJSON:(id)sender;
- (void)closeWindow:(id)sender;

- (void)cut:(id)sender;
- (void)copy:(id)sender;
- (void)paste:(id)sender;
- (void)selectAll:(id)sender;
- (void)find:(id)sender;

- (void)showAllVideos:(id)sender;
- (void)searchVideos:(id)sender;
- (void)showStatistics:(id)sender;

- (void)showPreferences:(id)sender;
- (void)showAbout:(id)sender;
- (void)showHelp:(id)sender;

@end
