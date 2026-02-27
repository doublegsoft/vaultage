//  VideoMetadataEditor.m
//  VideoMetadataEditor
//
//  视频元数据编辑器实现
//
#import <AVFoundation/AVFoundation.h>

#import "VideoMetadataEditor.h"
#import "sqlite3.h"

@implementation VideoMetadataEditor

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 初始化选中的语言集合
  self.selectedLanguages = [NSMutableSet set];
  
  // 设置界面样式
  [self setupUI];
  
  // 生成视频ID
  self.videoID = [self generateVideoID];
  
  // 设置占位符文本
  [self setupPlaceholders];
  
  // 配置分辨率选项
  [self setupResolutionPopup];
  
  // 配置语言选项
  [self setupLanguagePopup];
}

- (void)setupUI {
  // 设置文本框样式
  self.view.window.backgroundColor = [NSColor colorWithWhite:0.15 alpha:1.0];
  
  // 设置按钮样式
  self.saveButton.bezelStyle     = NSBezelStyleRounded;
  self.cancelButton.bezelStyle   = NSBezelStyleRounded;
  self.deleteButton.bezelStyle   = NSBezelStyleRounded;
  self.deleteButton.contentTintColor = [NSColor systemRedColor];
  
  // 设置语言按钮为切换式
  [self.englishButton setButtonType:NSButtonTypeToggle];
  [self.spanishButton setButtonType:NSButtonTypeToggle];
  [self.frenchButton setButtonType:NSButtonTypeToggle];
}

- (void)setupPlaceholders {
  
}

- (void)setupResolutionPopup {
  [self.resolutionPopup removeAllItems];
  [self.resolutionPopup addItemWithTitle:@"720"];
  [self.resolutionPopup addItemWithTitle:@"1080"];
  [self.resolutionPopup addItemWithTitle:@"1440"];
  [self.resolutionPopup addItemWithTitle:@"2160"];
  [self.resolutionPopup selectItemAtIndex:1];
}

- (void)setupLanguagePopup {
  [self.languagePopup removeAllItems];
  [self.languagePopup addItemWithTitle:@"EN"];
  [self.languagePopup addItemWithTitle:@"ZH"];
}

#pragma mark - Video Loading

- (IBAction)reselectVideo:(id)sender {
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  openPanel.canChooseFiles      = YES;
  openPanel.canChooseDirectories = NO;
  openPanel.allowsMultipleSelection = NO;
  openPanel.allowedFileTypes    = @[@"mp4", @"mov", @"m4v", @"avi", @"mkv", @"webm"];
  
  [openPanel beginWithCompletionHandler:^(NSInteger result) {
    if (result == NSModalResponseOK) {
      NSURL *selectedURL = openPanel.URL;
      [self loadVideoFromURL:selectedURL];
    }
  }];
}

- (void)loadVideoFromURL:(NSURL *)url {
  self.videoURL = url;
  
  // 设置文件路径
  self.filePathField.stringValue = url.path;
  
  // 加载视频到播放器
  self.player = [AVPlayer playerWithURL:url];
  self.playerView.player = self.player;
  
  // 获取视频元数据
  [self populateMetadataFields];
}

- (void)populateMetadataFields {
  if (!self.videoURL) return;
  
  AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
  
  // 获取时长
  CMTime duration = asset.duration;
  Float64 durationInSeconds = CMTimeGetSeconds(duration);
  int minutes = (int)durationInSeconds / 60;
  int seconds = (int)durationInSeconds % 60;
  self.durationField.stringValue = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
  
  // 获取分辨率
  NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
  if (videoTracks.count > 0) {
    AVAssetTrack *videoTrack = videoTracks[0];
    CGSize size = videoTrack.naturalSize;
    NSString *resolution = [NSString stringWithFormat:@"%.0fx%.0f", size.width, size.height];
    
    // 在下拉菜单中选择对应的分辨率
    [self.resolutionPopup selectItemWithTitle:resolution];
    if (self.resolutionPopup.indexOfSelectedItem == -1) {
      [self.resolutionPopup addItemWithTitle:resolution];
      [self.resolutionPopup selectItemWithTitle:resolution];
    }
  }
  
  // 从文件名提取标题
  NSString *fileName = self.videoURL.lastPathComponent;
  self.titleField.stringValue = [fileName stringByDeletingPathExtension];
}

#pragma mark - Language Selection

- (IBAction)toggleLanguage:(id)sender {
  NSButton* button = (NSButton *)sender;
  NSString* language = button.title;
  
  if (button.state == NSControlStateValueOn) {
    [self.selectedLanguages addObject:language];
  } else {
    [self.selectedLanguages removeObject:language];
  }
}

#pragma mark - Form Actions

- (IBAction)cancelEditing:(id)sender {
  NSAlert* alert = [[NSAlert alloc] init];
  alert.messageText = @"Cancel Editing";
  alert.informativeText = @"Are you sure you want to cancel? All unsaved changes will be lost.";
  [alert addButtonWithTitle:@"Yes"];
  [alert addButtonWithTitle:@"No"];
  
  [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      [self clearForm];
    }
  }];
}

- (IBAction)saveMetadata:(id)sender {
  // 验证必填字段
  if (self.titleField.stringValue.length == 0) {
    [self showAlert:@"Error" message:@"Please enter a title."];
    return;
  }
  
  // 创建元数据字典
  NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
  metadata[@"id"]               = self.idField.stringValue;
  metadata[@"filePath"]         = self.filePathField.stringValue;
  metadata[@"title"]            = self.titleField.stringValue;
  metadata[@"author"]           = self.authorField.stringValue;
  metadata[@"duration"]         = self.durationField.stringValue;
  metadata[@"titleNotes"]       = self.titleNotesField.stringValue;
  metadata[@"resolution"]       = self.resolutionPopup.titleOfSelectedItem;
  metadata[@"language"]         = self.languagePopup.titleOfSelectedItem;
  metadata[@"selectedLanguages"] = [self.selectedLanguages allObjects];
  metadata[@"year"]             = self.yearField.stringValue;
  metadata[@"location"]         = self.locationTextView.string;
  
  // 保存到文件（这里使用 JSON 格式）
  [self saveMetadataToFile:metadata];
  
  [self showAlert:@"Success" message:@"Metadata saved successfully!"];
}

- (IBAction)saveToDatabase:(id)sender {
  sqlite3* database;
  if (sqlite3_open("/Volumes/EXPORT/var/db/sqlite3/resources.db", &database) != SQLITE_OK) {
    [self showAlert:@"错误" message:[NSString stringWithFormat:@"Failed to open database: %s", sqlite3_errmsg(database)]];
    return;
  }
  
  // 检查记录是否已存在
  // NSString* checkSQL = @"SELECT id FROM videos WHERE id = ?";
  // sqlite3_stmt* checkStatement;
  // BOOL recordExists = NO;
  
  // if (sqlite3_prepare_v2(database, [checkSQL UTF8String], -1, &checkStatement, NULL) == SQLITE_OK) {
  //   sqlite3_bind_text(checkStatement, 1, [self.idField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  //   if (sqlite3_step(checkStatement) == SQLITE_ROW) {
  //     recordExists = YES;
  //   }
  // }
  // sqlite3_finalize(checkStatement);
  
  // // 如果记录存在，使用 UPDATE；否则使用 INSERT
  // if (recordExists) {
  //   // TODO: 提示已经存在
  //   return NO;
  // }
  
  // 准备 INSERT 语句
  const char* insertSQL = 
      "INSERT INTO youtube (id, url, title, author, duration, resolution, language, year, path, note) "
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
  
  sqlite3_stmt* statement;
  if (sqlite3_prepare_v2(database, insertSQL, -1, &statement, NULL) != SQLITE_OK) {
    [self showAlert:@"错误" message:[NSString stringWithFormat:@"Failed to prepare statement: %s", sqlite3_errmsg(database)]];
    return;
  }
  
  // 绑定参数
  sqlite3_bind_text(statement, 1,  [self.idField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 2,  [self.linkField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 3,  [self.titleField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 4,  [self.authorField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 5,  [self.durationField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 6,  [self.resolutionPopup.titleOfSelectedItem UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 7, [self.languagePopup.titleOfSelectedItem UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 8,  [self.yearField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 9,  [self.filePathField.stringValue UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(statement, 10,  [self.noteTextView.string UTF8String], -1, SQLITE_TRANSIENT);
  
  // 将选中的语言转换为 JSON 字符串
  NSError* error;
  
  // 执行语句
  BOOL success = NO;
  if (sqlite3_step(statement) == SQLITE_DONE) {
    success = YES;
    NSLog(@"Video metadata saved successfully with ID: %@", self.idField.stringValue);
  } else {
    [self showAlert:@"错误" message:[NSString stringWithFormat:@"Failed to insert data: %s", sqlite3_errmsg(database)]];
    return;
  }
  
  sqlite3_finalize(statement);
  sqlite3_close(database);
  [self clearForm];
}

- (IBAction)deleteVideo:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText     = @"Delete Video";
  alert.informativeText = @"Are you sure you want to delete this video? This action cannot be undone.";
  [alert addButtonWithTitle:@"Delete"];
  [alert addButtonWithTitle:@"Cancel"];
  alert.alertStyle      = NSAlertStyleCritical;
  
  [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      [self performVideoDeletion];
    }
  }];
}

- (void)performVideoDeletion {
  if (self.videoURL) {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:self.videoURL error:&error];
    
    if (error) {
      [self showAlert:@"Error" message:[NSString stringWithFormat:@"Failed to delete video: %@", error.localizedDescription]];
    } else {
      [self showAlert:@"Success" message:@"Video deleted successfully."];
      [self clearForm];
    }
  }
}

#pragma mark - Helper Methods

- (void)clearForm {
  self.videoID = [self generateVideoID];
  self.idField.stringValue       = @"";
  self.linkField.stringValue       = @"";
  self.filePathField.stringValue = @"";
  self.titleField.stringValue    = @"";
  self.authorField.stringValue   = @"";
  self.durationField.stringValue = @"";
  self.titleNotesField.stringValue = @"";
  self.yearField.stringValue     = @"";
  self.noteTextView.string   = @"";
  
  [self.resolutionPopup selectItemAtIndex:1];
  [self.languagePopup selectItemAtIndex:0];
  
  self.player = nil;
  self.playerView.player = nil;
  self.videoURL = nil;
}

- (NSString *)generateVideoID {
  // 生成唯一的视频ID
  NSString *uuid = [[NSUUID UUID] UUIDString];
  return [uuid substringToIndex:8];
}

- (void)saveMetadataToFile:(NSDictionary *)metadata {
  // 获取保存路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *metadataPath = [documentsDirectory stringByAppendingPathComponent:@"VideoMetadata"];
  
  // 创建目录（如果不存在）
  [[NSFileManager defaultManager] createDirectoryAtPath:metadataPath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:nil];
  
  // 保存文件
  NSString *fileName = [NSString stringWithFormat:@"%@.json", metadata[@"id"]];
  NSString *filePath = [metadataPath stringByAppendingPathComponent:fileName];
  
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:metadata
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  
  if (!error) {
    [jsonData writeToFile:filePath atomically:YES];
  }
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText     = title;
  alert.informativeText = message;
  [alert addButtonWithTitle:@"OK"];
  [alert runModal];
}

- (NSString *)extractYouTubeVideoID:(NSString *)urlString {
  if (!urlString || urlString.length == 0) {
    return nil;
  }
  
  // 去除首尾空白
  urlString = [urlString stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  // 正则表达式匹配 YouTube URL
  // 支持格式：
  // - https://www.youtube.com/watch?v=VIDEO_ID
  // - https://youtu.be/VIDEO_ID
  // - https://www.youtube.com/embed/VIDEO_ID
  NSString *pattern = @"(?:youtube\\.com/watch\\?v=|youtu\\.be/|youtube\\.com/embed/)([a-zA-Z0-9_-]{11})";
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression 
    regularExpressionWithPattern:pattern
    options:NSRegularExpressionCaseInsensitive 
    error:&error];
  
  if (error) {
    NSLog(@"正则表达式错误: %@", error);
    return nil;
  }
  
  NSTextCheckingResult *match = [regex 
    firstMatchInString:urlString 
    options:0 
    range:NSMakeRange(0, urlString.length)];
  
  if (match && match.numberOfRanges > 1) {
    NSRange videoIDRange = [match rangeAtIndex:1];
    return [urlString substringWithRange:videoIDRange];
  }
  
  // 如果没有匹配到，检查是否直接输入了 11 位 ID
  if (urlString.length == 11) {
    NSCharacterSet *validChars = [NSCharacterSet 
      characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"];
    NSCharacterSet *inputChars = [NSCharacterSet 
      characterSetWithCharactersInString:urlString];
    
    if ([validChars isSupersetOfSet:inputChars]) {
      return urlString;
    }
  }
  
  return nil;
}

@end