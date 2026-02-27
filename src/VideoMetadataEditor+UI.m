//
//  VideoMetadataEditor+UI.m
//  VideoMetadataEditor
//
//  界面布局的编程式实现 - 两列式表单布局
//

#import "VideoMetadataEditor.h"

@interface VerticallyCenteredTextFieldCell : NSTextFieldCell
@end

@implementation VerticallyCenteredTextFieldCell

- (NSRect)drawingRectForBounds:(NSRect)rect {
  NSRect newRect = [super drawingRectForBounds:rect];

  // 计算文本高度
  NSSize textSize = [self cellSizeForBounds:rect];
  CGFloat heightDelta = newRect.size.height - textSize.height;

  if (heightDelta > 0) {
    newRect.origin.y += heightDelta / 2.0;
    newRect.size.height -= heightDelta;
  }

  return newRect;
}

@end

@implementation VideoMetadataEditor (UI)

- (void)loadView {
  // 创建主视图，深色背景
  NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 900, 700)];
  view.wantsLayer = YES;
  view.layer.backgroundColor = [[NSColor colorWithWhite:0.88 alpha:1.0] CGColor];

  // ==================== 左侧区域：视频预览 ====================

  AVPlayerView *playerView =
    [[AVPlayerView alloc] initWithFrame:NSMakeRect(20, 480, 220, 180)];
  playerView.controlsStyle = AVPlayerViewControlsStyleInline;
  playerView.showsFullScreenToggleButton = YES;
  playerView.wantsLayer = YES;
  playerView.layer.backgroundColor = [[NSColor blackColor] CGColor];
  [view addSubview:playerView];
  self.playerView = playerView;

  NSTextField *videoResLabel =
    [[NSTextField alloc] initWithFrame:NSMakeRect(20, 450, 220, 20)];
  videoResLabel.stringValue = @"320 x 180";
  videoResLabel.editable = NO;
  videoResLabel.bordered = NO;
  videoResLabel.backgroundColor = [NSColor clearColor];
  videoResLabel.textColor = [NSColor lightGrayColor];
  videoResLabel.font = [NSFont systemFontOfSize:11];
  videoResLabel.alignment = NSTextAlignmentLeft;
  [view addSubview:videoResLabel];

  // ==================== 右侧区域：两列式表单 ====================

  CGFloat formStartX = 270;
  CGFloat labelX = formStartX;
  CGFloat labelWidth = 110;
  CGFloat fieldX = formStartX + labelWidth + 10;
  CGFloat fieldWidth = 480;
  CGFloat rowHeight = 50;
  CGFloat currentY = 620;

  NSTextField* linkLabel = [self createLabel:@"Youtube链接"
                                     frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:linkLabel];

  NSTextField* linkField = [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  linkField.placeholderString = @"https://www.youtube.com/watch?v=SW0AcDIl4jY";
  [view addSubview:linkField];
  self.linkField = linkField;

  currentY -= rowHeight;

  NSTextField* idLabel =
    [self createLabel:@"Youtube标识"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:idLabel];

  NSTextField* idField =
    [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  idField.enabled = NO;
  idField.placeholderString = @"SW0AcDIl4jY";
  [view addSubview:idField];
  self.idField = idField;

  currentY -= rowHeight;

  NSTextField* filePathLabel =
    [self createLabel:@"本地路径"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:filePathLabel];

  NSTextField* filePathField =
    [self createTextField:NSMakeRect(fieldX, currentY, 330, 30)];
  [view addSubview:filePathField];
  self.filePathField = filePathField;

  NSButton* reselectButton =
    [[NSButton alloc] initWithFrame:
      NSMakeRect(fieldX + 340, currentY, 130, 30)];
  [reselectButton setTitle:@"选择文件"];
  reselectButton.bezelStyle = NSBezelStyleRounded;
  [reselectButton setTarget:self];
  [reselectButton setAction:@selector(reselectVideo:)];
  [view addSubview:reselectButton];
  self.reselectButton = reselectButton;

  currentY -= rowHeight;

  NSTextField* titleLabel =
    [self createLabel:@"标题"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:titleLabel];

  NSTextField* titleField =
    [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  titleField.placeholderString = @"";
  [view addSubview:titleField];
  self.titleField = titleField;

  currentY -= rowHeight;

  NSTextField* authorLabel =
    [self createLabel:@"作者"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:authorLabel];

  NSTextField* authorField =
    [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  authorField.placeholderString = @"";
  [view addSubview:authorField];
  self.authorField = authorField;

  currentY -= rowHeight;

  NSTextField* durationLabel =
    [self createLabel:@"时长"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:durationLabel];

  NSTextField* durationField =
    [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  durationField.placeholderString = @"hh:mm:ss";
  [view addSubview:durationField];
  self.durationField = durationField;

  currentY -= rowHeight;

  NSTextField* resolutionLabel =
    [self createLabel:@"分辨率"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:resolutionLabel];

  NSPopUpButton* resolutionPopup =
    [[NSPopUpButton alloc] initWithFrame:
      NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  resolutionPopup.bezelStyle = NSBezelStyleRounded;
  [view addSubview:resolutionPopup];
  self.resolutionPopup = resolutionPopup;

  currentY -= rowHeight;

  NSTextField* languageLabel1 =
    [self createLabel:@"语言"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:languageLabel1];

  NSPopUpButton* languagePopup =
    [[NSPopUpButton alloc] initWithFrame:
      NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  languagePopup.bezelStyle = NSBezelStyleRounded;
  [view addSubview:languagePopup];
  self.languagePopup = languagePopup;

  currentY -= rowHeight;

  NSTextField* yearLabel =
    [self createLabel:@"发布年份"
                frame:NSMakeRect(labelX, currentY, labelWidth, 24)];
  [view addSubview:yearLabel];

  NSTextField* yearField =
    [self createTextField:NSMakeRect(fieldX, currentY, fieldWidth, 30)];
  yearField.placeholderString = @"";
  [view addSubview:yearField];
  self.yearField = yearField;
  
  currentY -= 140;  // 为 Note 字段留空间
      
  // ========== 第12行：Note (多行文本框) ==========
  NSTextField* noteLabel = [self createLabel:@"备注"
                                       frame:NSMakeRect(labelX, currentY + 90, labelWidth, 24)];
  [view addSubview:noteLabel];
  
  // 创建 Note 带边框的滚动视图
  NSScrollView* noteScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(fieldX, currentY, fieldWidth, 120)];
  noteScrollView.hasVerticalScroller = YES;
  noteScrollView.borderType = NSBezelBorder;
  noteScrollView.wantsLayer = YES;
  
  NSTextView *noteTextView = [[NSTextView alloc] initWithFrame:noteScrollView.bounds];
  noteTextView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//  noteTextView.backgroundColor = [NSColor colorWithWhite:0.2 alpha:1.0];
//  noteTextView.textColor = [NSColor whiteColor];
  noteTextView.font = [NSFont systemFontOfSize:13];
  noteTextView.string = @"";
  noteScrollView.documentView = noteTextView;
  [view addSubview:noteScrollView];
  self.noteTextView = noteTextView;

  CGFloat buttonY = 30;
  CGFloat buttonStartX = 480;

  NSButton* saveButton =
    [[NSButton alloc] initWithFrame:
      NSMakeRect(buttonStartX + 120, buttonY, 100, 40)];
  [saveButton setTitle:@"Save"];
  saveButton.bezelStyle = NSBezelStyleRounded;
  saveButton.keyEquivalent = @"\r";
  [saveButton setTarget:self];
  [saveButton setAction:@selector(saveMetadata:)];
  [view addSubview:saveButton];
  self.saveButton = saveButton;

  NSButton* deleteButton =
    [[NSButton alloc] initWithFrame:
      NSMakeRect(buttonStartX + 240, buttonY, 140, 40)];
  [deleteButton setTitle:@"Delete Video"];
  deleteButton.bezelStyle = NSBezelStyleRounded;
  [deleteButton setTarget:self];
  [deleteButton setAction:@selector(deleteVideo:)];

  if (@available(macOS 10.14, *)) {
    deleteButton.contentTintColor = [NSColor systemRedColor];
  }

  [view addSubview:deleteButton];
  self.deleteButton = deleteButton;

  self.view = view;
}

#pragma mark - UI Helper Methods

- (NSTextField *)createLabel:(NSString *)title frame:(NSRect)frame {
  NSTextField *label = [[NSTextField alloc] initWithFrame:frame];
  label.stringValue = title;
  label.editable = NO;
  label.selectable = NO;
  label.bordered = NO;
  label.backgroundColor = [NSColor clearColor];
  label.font = [NSFont systemFontOfSize:13];
  label.alignment = NSTextAlignmentRight;
  return label;
}

- (NSTextField *)createTextField:(NSRect)frame {
  NSTextField *textField = [[NSTextField alloc] initWithFrame:frame];
  textField.bezelStyle = NSTextFieldRoundedBezel;
  textField.backgroundColor = [NSColor colorWithWhite:0.2 alpha:1.0];
//  textField.textColor = [NSColor whiteColor];
  textField.font = [NSFont systemFontOfSize:13];
  return textField;
}

@end
