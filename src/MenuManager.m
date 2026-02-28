//
//  MenuManager.m
//  VideoMetadataEditor
//
//  菜单管理类实现
//

#import "MenuManager.h"
#import "VideoMetadataEditor.h"

@implementation MenuManager

#pragma mark - 单例

+ (instancetype)sharedManager {
  static MenuManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[self alloc] init];
  });
  return sharedManager;
}

#pragma mark - 创建菜单

- (NSMenu *)createMainMenu {
  NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"Main Menu"];
  
  // App 菜单
  [mainMenu addItem:[self createAppMenu]];
  
  // File 菜单
  [mainMenu addItem:[self createFileMenu]];
  
  // Edit 菜单
  [mainMenu addItem:[self createEditMenu]];
  
  // View 菜单
  [mainMenu addItem:[self createViewMenu]];
  
  // Video 菜单
  [mainMenu addItem:[self createVideoMenu]];
  
  // Window 菜单
  [mainMenu addItem:[self createWindowMenu]];
  
  // Help 菜单
  [mainMenu addItem:[self createHelpMenu]];
  
  self.mainMenu = mainMenu;
  return mainMenu;
}

#pragma mark - App 菜单

- (NSMenuItem *)createAppMenu {
  NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
  NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"VideoMetadataEditor"];
  
  // About
  NSMenuItem *aboutItem = [[NSMenuItem alloc] 
    initWithTitle:@"About VideoMetadataEditor"
    action:@selector(showAbout:)
    keyEquivalent:@""];
  aboutItem.target = self;
  [appMenu addItem:aboutItem];
  
  [appMenu addItem:[NSMenuItem separatorItem]];
  
  // Preferences
  NSMenuItem *prefItem = [[NSMenuItem alloc] 
    initWithTitle:@"Preferences..."
    action:@selector(showPreferences:)
    keyEquivalent:@","];
  prefItem.target = self;
  [appMenu addItem:prefItem];
  
  [appMenu addItem:[NSMenuItem separatorItem]];
  
  // Services
  NSMenuItem *servicesItem = [[NSMenuItem alloc] 
    initWithTitle:@"Services"
    action:nil
    keyEquivalent:@""];
  NSMenu *servicesMenu = [[NSMenu alloc] initWithTitle:@"Services"];
  servicesItem.submenu = servicesMenu;
  [appMenu addItem:servicesItem];
  
  [appMenu addItem:[NSMenuItem separatorItem]];
  
  // Hide
  NSMenuItem *hideItem = [[NSMenuItem alloc] 
    initWithTitle:@"Hide VideoMetadataEditor"
    action:@selector(hide:)
    keyEquivalent:@"h"];
  [appMenu addItem:hideItem];
  
  // Hide Others
  NSMenuItem *hideOthersItem = [[NSMenuItem alloc] 
    initWithTitle:@"Hide Others"
    action:@selector(hideOtherApplications:)
    keyEquivalent:@"h"];
  hideOthersItem.keyEquivalentModifierMask = NSEventModifierFlagOption | NSEventModifierFlagCommand;
  [appMenu addItem:hideOthersItem];
  
  // Show All
  NSMenuItem *showAllItem = [[NSMenuItem alloc] 
    initWithTitle:@"Show All"
    action:@selector(unhideAllApplications:)
    keyEquivalent:@""];
  [appMenu addItem:showAllItem];
  
  [appMenu addItem:[NSMenuItem separatorItem]];
  
  // Quit
  NSMenuItem *quitItem = [[NSMenuItem alloc] 
    initWithTitle:@"Quit VideoMetadataEditor"
    action:@selector(terminate:)
    keyEquivalent:@"q"];
  [appMenu addItem:quitItem];
  
  appMenuItem.submenu = appMenu;
  return appMenuItem;
}

#pragma mark - File 菜单

- (NSMenuItem *)createFileMenu {
  NSMenuItem *fileMenuItem = [[NSMenuItem alloc] init];
  NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
  
  // New
  NSMenuItem *newItem = [[NSMenuItem alloc] 
    initWithTitle:@"New"
    action:@selector(newDocument:)
    keyEquivalent:@"n"];
  newItem.target = self;
  [fileMenu addItem:newItem];
  
  // Open
  NSMenuItem *openItem = [[NSMenuItem alloc] 
    initWithTitle:@"Open..."
    action:@selector(openDocument:)
    keyEquivalent:@"o"];
  openItem.target = self;
  [fileMenu addItem:openItem];
  
  [fileMenu addItem:[NSMenuItem separatorItem]];
  
  // Save
  NSMenuItem *saveItem = [[NSMenuItem alloc] 
    initWithTitle:@"Save"
    action:@selector(saveDocument:)
    keyEquivalent:@"s"];
  saveItem.target = self;
  [fileMenu addItem:saveItem];
  
  [fileMenu addItem:[NSMenuItem separatorItem]];
  
  // Import submenu
  NSMenuItem *importItem = [[NSMenuItem alloc] 
    initWithTitle:@"Import"
    action:nil
    keyEquivalent:@""];
  NSMenu *importMenu = [[NSMenu alloc] initWithTitle:@"Import"];
  
  NSMenuItem *importJSONItem = [[NSMenuItem alloc] 
    initWithTitle:@"From JSON..."
    action:@selector(importFromJSON:)
    keyEquivalent:@""];
  importJSONItem.target = self;
  [importMenu addItem:importJSONItem];
  
  importItem.submenu = importMenu;
  [fileMenu addItem:importItem];
  
  // Export submenu
  NSMenuItem *exportItem = [[NSMenuItem alloc] 
    initWithTitle:@"Export"
    action:nil
    keyEquivalent:@""];
  NSMenu *exportMenu = [[NSMenu alloc] initWithTitle:@"Export"];
  
  NSMenuItem *exportJSONItem = [[NSMenuItem alloc] 
    initWithTitle:@"As JSON..."
    action:@selector(exportAsJSON:)
    keyEquivalent:@""];
  exportJSONItem.target = self;
  [exportMenu addItem:exportJSONItem];
  
  NSMenuItem *exportCSVItem = [[NSMenuItem alloc] 
    initWithTitle:@"As CSV..."
    action:@selector(exportAsCSV:)
    keyEquivalent:@""];
  exportCSVItem.target = self;
  [exportMenu addItem:exportCSVItem];
  
  exportItem.submenu = exportMenu;
  [fileMenu addItem:exportItem];
  
  [fileMenu addItem:[NSMenuItem separatorItem]];
  
  // Close
  NSMenuItem *closeItem = [[NSMenuItem alloc] 
    initWithTitle:@"Close Window"
    action:@selector(closeWindow:)
    keyEquivalent:@"w"];
  closeItem.target = self;
  [fileMenu addItem:closeItem];
  
  fileMenuItem.submenu = fileMenu;
  return fileMenuItem;
}

#pragma mark - Edit 菜单

- (NSMenuItem *)createEditMenu {
  NSMenuItem *editMenuItem = [[NSMenuItem alloc] init];
  NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
  
  // Undo
  NSMenuItem *undoItem = [[NSMenuItem alloc] 
    initWithTitle:@"Undo"
    action:@selector(undo:)
    keyEquivalent:@"z"];
  [editMenu addItem:undoItem];
  
  // Redo
  NSMenuItem *redoItem = [[NSMenuItem alloc] 
    initWithTitle:@"Redo"
    action:@selector(redo:)
    keyEquivalent:@"Z"];
  [editMenu addItem:redoItem];
  
  [editMenu addItem:[NSMenuItem separatorItem]];
  
  // Cut
  NSMenuItem *cutItem = [[NSMenuItem alloc] 
    initWithTitle:@"Cut"
    action:@selector(cut:)
    keyEquivalent:@"x"];
  cutItem.target = self;
  [editMenu addItem:cutItem];
  
  // Copy
  NSMenuItem *copyItem = [[NSMenuItem alloc] 
    initWithTitle:@"Copy"
    action:@selector(copy:)
    keyEquivalent:@"c"];
  copyItem.target = self;
  [editMenu addItem:copyItem];
  
  // Paste
  NSMenuItem *pasteItem = [[NSMenuItem alloc] 
    initWithTitle:@"Paste"
    action:@selector(paste:)
    keyEquivalent:@"v"];
  pasteItem.target = self;
  [editMenu addItem:pasteItem];
  
  // Delete
  NSMenuItem *deleteItem = [[NSMenuItem alloc] 
    initWithTitle:@"Delete"
    action:@selector(delete:)
    keyEquivalent:@""];
  [editMenu addItem:deleteItem];
  
  // Select All
  NSMenuItem *selectAllItem = [[NSMenuItem alloc] 
    initWithTitle:@"Select All"
    action:@selector(selectAll:)
    keyEquivalent:@"a"];
  selectAllItem.target = self;
  [editMenu addItem:selectAllItem];
  
  [editMenu addItem:[NSMenuItem separatorItem]];
  
  // Find
  NSMenuItem *findItem = [[NSMenuItem alloc] 
    initWithTitle:@"Find..."
    action:@selector(find:)
    keyEquivalent:@"f"];
  findItem.target = self;
  [editMenu addItem:findItem];
  
  editMenuItem.submenu = editMenu;
  return editMenuItem;
}

#pragma mark - View 菜单

- (NSMenuItem *)createViewMenu {
  NSMenuItem *viewMenuItem = [[NSMenuItem alloc] init];
  NSMenu *viewMenu = [[NSMenu alloc] initWithTitle:@"View"];
  
  // Show All Videos
  NSMenuItem *showAllItem = [[NSMenuItem alloc] 
    initWithTitle:@"Show All Videos"
    action:@selector(showAllVideos:)
    keyEquivalent:@"1"];
  showAllItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;
  showAllItem.target = self;
  [viewMenu addItem:showAllItem];
  
  // Show Statistics
  NSMenuItem *statsItem = [[NSMenuItem alloc] 
    initWithTitle:@"Show Statistics"
    action:@selector(showStatistics:)
    keyEquivalent:@"2"];
  statsItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;
  statsItem.target = self;
  [viewMenu addItem:statsItem];
  
  [viewMenu addItem:[NSMenuItem separatorItem]];
  
  // Refresh
  NSMenuItem *refreshItem = [[NSMenuItem alloc] 
    initWithTitle:@"Refresh"
    action:@selector(refresh:)
    keyEquivalent:@"r"];
  [viewMenu addItem:refreshItem];
  
  [viewMenu addItem:[NSMenuItem separatorItem]];
  
  // Enter Full Screen
  NSMenuItem *fullScreenItem = [[NSMenuItem alloc] 
    initWithTitle:@"Enter Full Screen"
    action:@selector(toggleFullScreen:)
    keyEquivalent:@"f"];
  fullScreenItem.keyEquivalentModifierMask = NSEventModifierFlagControl | NSEventModifierFlagCommand;
  [viewMenu addItem:fullScreenItem];
  
  viewMenuItem.submenu = viewMenu;
  return viewMenuItem;
}

#pragma mark - Video 菜单

- (NSMenuItem *)createVideoMenu {
  NSMenuItem *videoMenuItem = [[NSMenuItem alloc] init];
  NSMenu *videoMenu = [[NSMenu alloc] initWithTitle:@"Video"];
  
  // New Video
  NSMenuItem *newVideoItem = [[NSMenuItem alloc] 
    initWithTitle:@"New Video Entry"
    action:@selector(newDocument:)
    keyEquivalent:@"n"];
  newVideoItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagShift;
  newVideoItem.target = self;
  [videoMenu addItem:newVideoItem];
  
  // Load Video
  NSMenuItem *loadVideoItem = [[NSMenuItem alloc] 
    initWithTitle:@"Load Video File..."
    action:@selector(openDocument:)
    keyEquivalent:@"l"];
  loadVideoItem.target = self;
  [videoMenu addItem:loadVideoItem];
  
  [videoMenu addItem:[NSMenuItem separatorItem]];
  
  // Search Videos
  NSMenuItem *searchItem = [[NSMenuItem alloc] 
    initWithTitle:@"Search Videos..."
    action:@selector(searchVideos:)
    keyEquivalent:@"f"];
  searchItem.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagShift;
  searchItem.target = self;
  [videoMenu addItem:searchItem];
  
  [videoMenu addItem:[NSMenuItem separatorItem]];
  
  // Delete Current Video
  NSMenuItem *deleteItem = [[NSMenuItem alloc] 
    initWithTitle:@"Delete Current Video"
    action:@selector(deleteVideo:)
    keyEquivalent:@""];
  deleteItem.keyEquivalent = [NSString stringWithFormat:@"%c", NSBackspaceCharacter];
  deleteItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;
  [videoMenu addItem:deleteItem];
  
  videoMenuItem.submenu = videoMenu;
  return videoMenuItem;
}

#pragma mark - Window 菜单

- (NSMenuItem *)createWindowMenu {
  NSMenuItem *windowMenuItem = [[NSMenuItem alloc] init];
  NSMenu *windowMenu = [[NSMenu alloc] initWithTitle:@"Window"];
  
  // Minimize
  NSMenuItem *minimizeItem = [[NSMenuItem alloc] 
    initWithTitle:@"Minimize"
    action:@selector(performMiniaturize:)
    keyEquivalent:@"m"];
  [windowMenu addItem:minimizeItem];
  
  // Zoom
  NSMenuItem *zoomItem = [[NSMenuItem alloc] 
    initWithTitle:@"Zoom"
    action:@selector(performZoom:)
    keyEquivalent:@""];
  [windowMenu addItem:zoomItem];
  
  [windowMenu addItem:[NSMenuItem separatorItem]];
  
  // Bring All to Front
  NSMenuItem *frontItem = [[NSMenuItem alloc] 
    initWithTitle:@"Bring All to Front"
    action:@selector(arrangeInFront:)
    keyEquivalent:@""];
  [windowMenu addItem:frontItem];
  
  windowMenuItem.submenu = windowMenu;
  
  // 设置为应用的 windows 菜单
  [NSApp setWindowsMenu:windowMenu];
  
  return windowMenuItem;
}

#pragma mark - Help 菜单

- (NSMenuItem *)createHelpMenu {
  NSMenuItem *helpMenuItem = [[NSMenuItem alloc] init];
  NSMenu *helpMenu = [[NSMenu alloc] initWithTitle:@"Help"];
  
  // VideoMetadataEditor Help
  NSMenuItem *helpItem = [[NSMenuItem alloc] 
    initWithTitle:@"VideoMetadataEditor Help"
    action:@selector(showHelp:)
    keyEquivalent:@"?"];
  helpItem.target = self;
  [helpMenu addItem:helpItem];
  
  [helpMenu addItem:[NSMenuItem separatorItem]];
  
  // Database Guide
  NSMenuItem *dbGuideItem = [[NSMenuItem alloc] 
    initWithTitle:@"Database Guide"
    action:@selector(showDatabaseGuide:)
    keyEquivalent:@""];
  dbGuideItem.target = self;
  [helpMenu addItem:dbGuideItem];
  
  // Quick Start
  NSMenuItem *quickStartItem = [[NSMenuItem alloc] 
    initWithTitle:@"Quick Start Guide"
    action:@selector(showQuickStart:)
    keyEquivalent:@""];
  quickStartItem.target = self;
  [helpMenu addItem:quickStartItem];
  
  helpMenuItem.submenu = helpMenu;
  return helpMenuItem;
}

#pragma mark - Menu Actions

- (void)newDocument:(id)sender {
  if (self.viewController) {
    [self.viewController clearForm];
  }
}

- (void)openDocument:(id)sender {
  if (self.viewController) {
    [self.viewController reselectVideo:sender];
  }
}

- (void)saveDocument:(id)sender {
  if (self.viewController) {
    [self.viewController saveMetadata:sender];
  }
}

- (void)closeWindow:(id)sender {
  [[NSApp keyWindow] performClose:sender];
}

- (void)cut:(id)sender {
  NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
  if ([firstResponder respondsToSelector:@selector(cut:)]) {
    [firstResponder performSelector:@selector(cut:) withObject:sender];
  }
}

- (void)copy:(id)sender {
  NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
  if ([firstResponder respondsToSelector:@selector(copy:)]) {
    [firstResponder performSelector:@selector(copy:) withObject:sender];
  }
}

- (void)paste:(id)sender {
  NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
  if ([firstResponder respondsToSelector:@selector(paste:)]) {
    [firstResponder performSelector:@selector(paste:) withObject:sender];
  }
}

- (void)selectAll:(id)sender {
  NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
  if ([firstResponder respondsToSelector:@selector(selectAll:)]) {
    [firstResponder performSelector:@selector(selectAll:) withObject:sender];
  }
}

- (void)find:(id)sender {
  [self showSearchDialog];
}

- (void)showAllVideos:(id)sender {
  [self showVideoListWindow];
}

- (void)searchVideos:(id)sender {
  [self showSearchDialog];
}

- (void)showStatistics:(id)sender {
  [self showStatisticsWindow];
}

- (void)exportAsJSON:(id)sender {
  [self exportDatabase:@"json"];
}

- (void)exportAsCSV:(id)sender {
  [self exportDatabase:@"csv"];
}

- (void)importFromJSON:(id)sender {
  [self importFromFile];
}

- (void)showPreferences:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Preferences";
  alert.informativeText = @"Preferences window coming soon!";
  [alert addButtonWithTitle:@"OK"];
  [alert runModal];
}

- (void)showAbout:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"VideoMetadataEditor";
  alert.informativeText = @"Version 1.2\n\n"
    @"A powerful video metadata management application.\n\n"
    @"© 2025 VideoMetadataEditor\n"
    @"Built with Objective-C and SQLite";
  [alert addButtonWithTitle:@"OK"];
  [alert runModal];
}

- (void)showHelp:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Help";
  alert.informativeText = @"For detailed help, please refer to:\n\n"
    @"• README.md\n"
    @"• QUICKSTART.md\n"
    @"• DATABASE_GUIDE.md";
  [alert addButtonWithTitle:@"OK"];
  [alert runModal];
}

- (void)showDatabaseGuide:(id)sender {
  [self showHelp:sender];
}

- (void)showQuickStart:(id)sender {
  [self showHelp:sender];
}

#pragma mark - Helper Methods

- (void)showSearchDialog {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Search Videos";
  alert.informativeText = @"Enter search keyword:";
  
  NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
  alert.accessoryView = input;
  
  [alert addButtonWithTitle:@"Search"];
  [alert addButtonWithTitle:@"Cancel"];
  
  NSModalResponse response = [alert runModal];
  
  if (response == NSAlertFirstButtonReturn) {
    NSString *keyword = input.stringValue;
    if (keyword.length > 0) {
      [self performSearchWithKeyword:keyword];
    }
  }
}

- (void)performSearchWithKeyword:(NSString *)keyword {
  // VideoMetadataDatabase *db = [VideoMetadataDatabase sharedInstance];
  // NSError *error;
  // NSArray<VideoMetadata *> *results = [db searchVideos:keyword error:&error];
  
  // if (error) {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Search Error";
  //   alert.informativeText = error.localizedDescription;
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  //   return;
  // }
  
  // // Display results
  // NSMutableString *resultText = [NSMutableString string];
  // [resultText appendFormat:@"Found %lu video(s):\n\n", (unsigned long)results.count];
  
  // for (VideoMetadata *video in results) {
  //   [resultText appendFormat:@"• %@ (ID: %@)\n", video.title, video.videoID];
  // }
  
  // NSAlert *alert = [[NSAlert alloc] init];
  // alert.messageText = @"Search Results";
  // alert.informativeText = resultText;
  // [alert addButtonWithTitle:@"OK"];
  // [alert runModal];
}

- (void)showVideoListWindow {
  // VideoMetadataDatabase *db = [VideoMetadataDatabase sharedInstance];
  // NSError *error;
  // NSArray<VideoMetadata *> *videos = [db fetchAllVideos:&error];
  
  // if (error) {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Error";
  //   alert.informativeText = error.localizedDescription;
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  //   return;
  // }
  
  // NSMutableString *listText = [NSMutableString string];
  // [listText appendFormat:@"Total: %lu video(s)\n\n", (unsigned long)videos.count];
  
  // for (VideoMetadata *video in videos) {
  //   [listText appendFormat:@"• %@\n  Author: %@, Year: %@\n\n", 
  //     video.title, 
  //     video.author ?: @"N/A", 
  //     video.year ?: @"N/A"];
  // }
  
  // NSAlert *alert = [[NSAlert alloc] init];
  // alert.messageText = @"All Videos";
  // alert.informativeText = listText;
  // [alert addButtonWithTitle:@"OK"];
  // [alert runModal];
}

- (void)showStatisticsWindow {
  // VideoMetadataDatabase *db = [VideoMetadataDatabase sharedInstance];
  // NSError *error;
  
  // NSInteger total = [db countAllVideos:&error];
  // NSArray<NSString *> *authors = [db fetchAllAuthors:&error];
  // NSArray<NSString *> *years = [db fetchAllYears:&error];
  
  // NSString *stats = [NSString stringWithFormat:
  //   @"Database Statistics:\n\n"
  //   @"Total Videos: %ld\n"
  //   @"Unique Authors: %lu\n"
  //   @"Years Covered: %lu\n\n"
  //   @"Database: %@",
  //   (long)total,
  //   (unsigned long)authors.count,
  //   (unsigned long)years.count,
  //   db.databasePath];
  
  // NSAlert *alert = [[NSAlert alloc] init];
  // alert.messageText = @"Statistics";
  // alert.informativeText = stats;
  // [alert addButtonWithTitle:@"OK"];
  // [alert runModal];
}

- (void)exportDatabase:(NSString *)format {
  NSSavePanel *savePanel = [NSSavePanel savePanel];
  savePanel.allowedFileTypes = @[format];
  savePanel.nameFieldStringValue = [NSString stringWithFormat:@"videos_export.%@", format];
  
  [savePanel beginWithCompletionHandler:^(NSModalResponse result) {
    if (result == NSModalResponseOK) {
      NSURL *fileURL = savePanel.URL;
      [self performExport:fileURL format:format];
    }
  }];
}

- (void)performExport:(NSURL *)fileURL format:(NSString *)format {
  // VideoMetadataDatabase *db = [VideoMetadataDatabase sharedInstance];
  // NSError *error;
  // NSArray<VideoMetadata *> *videos = [db fetchAllVideos:&error];
  
  // if (error) {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Export Error";
  //   alert.informativeText = error.localizedDescription;
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  //   return;
  // }
  
  // NSMutableString *content = [NSMutableString string];
  
  // if ([format isEqualToString:@"json"]) {
  //   // JSON export
  //   NSMutableArray *jsonArray = [NSMutableArray array];
  //   for (VideoMetadata *video in videos) {
  //     [jsonArray addObject:[video toDictionary]];
  //   }
  //   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
  //   content = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  // } else if ([format isEqualToString:@"csv"]) {
  //   // CSV export
  //   [content appendString:@"ID,Title,Author,Year,Duration,Resolution,YouTube URL\n"];
  //   for (VideoMetadata *video in videos) {
  //     [content appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
  //       video.videoID ?: @"",
  //       video.title ?: @"",
  //       video.author ?: @"",
  //       video.year ?: @"",
  //       video.duration ?: @"",
  //       video.resolution ?: @"",
  //       video.youtubeURL ?: @""];
  //   }
  // }
  
  // [content writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
  
  // if (error) {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Export Error";
  //   alert.informativeText = error.localizedDescription;
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  // } else {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Export Successful";
  //   alert.informativeText = [NSString stringWithFormat:@"Exported %lu videos to %@", 
  //     (unsigned long)videos.count, fileURL.path];
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  // }
}

- (void)importFromFile {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.allowedFileTypes = @[@"json"];
  openPanel.canChooseFiles = YES;
  openPanel.canChooseDirectories = NO;
  
  [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
    if (result == NSModalResponseOK) {
      NSURL *fileURL = openPanel.URL;
      [self performImport:fileURL];
    }
  }];
}

- (void)performImport:(NSURL *)fileURL {
  // NSError *error;
  // NSData *jsonData = [NSData dataWithContentsOfURL:fileURL];
  // NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  
  // if (error) {
  //   NSAlert *alert = [[NSAlert alloc] init];
  //   alert.messageText = @"Import Error";
  //   alert.informativeText = error.localizedDescription;
  //   [alert addButtonWithTitle:@"OK"];
  //   [alert runModal];
  //   return;
  // }
  
  // VideoMetadataDatabase *db = [VideoMetadataDatabase sharedInstance];
  // NSInteger successCount = 0;
  // NSInteger failCount = 0;
  
  // for (NSDictionary *dict in jsonArray) {
  //   VideoMetadata *video = [VideoMetadata fromDictionary:dict];
  //   if ([db saveOrUpdateVideo:video error:&error]) {
  //     successCount++;
  //   } else {
  //     failCount++;
  //   }
  // }
  
  // NSAlert *alert = [[NSAlert alloc] init];
  // alert.messageText = @"Import Complete";
  // alert.informativeText = [NSString stringWithFormat:
  //   @"Successfully imported: %ld\nFailed: %ld",
  //   (long)successCount, (long)failCount];
  // [alert addButtonWithTitle:@"OK"];
  // [alert runModal];
}

@end
