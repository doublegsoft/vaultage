//
//  PastableTextField.m
//  VideoMetadataEditor
//
//  支持粘贴操作的自定义 NSTextField 实现
//

#import "PasteableTextField.h"

@implementation PasteableTextField

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    _enablePaste = YES;
    [self setupPasteSupport];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    _enablePaste = YES;
    [self setupPasteSupport];
  }
  return self;
}

- (void)setupPasteSupport {
  // 注册拖放类型
  [self registerForDraggedTypes:@[NSPasteboardTypeString]];
}

#pragma mark - 菜单支持

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
  if (menuItem.action == @selector(paste:)) {
    return self.enablePaste && [self canPaste];
  }
  return [super validateMenuItem:menuItem];
}

#pragma mark - 粘贴操作

- (void)paste:(id)sender {
  if (!self.enablePaste) {
    return;
  }
  
  NSPasteboard* pasteboard = [NSPasteboard generalPasteboard];
  NSString* pastedString = [pasteboard stringForType:NSPasteboardTypeString];
  
  if (pastedString) {
    // 获取当前选中范围
    NSText* fieldEditor = [self currentEditor];
    if (fieldEditor) {
      NSRange selectedRange = [fieldEditor selectedRange];
      
      // 替换选中文本
      [fieldEditor replaceCharactersInRange:selectedRange withString:pastedString];
      
      // 移动光标到粘贴文本的末尾
      NSUInteger newPosition = selectedRange.location + pastedString.length;
      [fieldEditor setSelectedRange:NSMakeRange(newPosition, 0)];
    } else {
      // 如果没有激活编辑器，直接设置值
      self.stringValue = pastedString;
    }
    
    // 触发回调
    if (self.onPaste) {
      self.onPaste(pastedString);
    }
    
    // 发送值改变通知
    [self sendAction:self.action to:self.target];
  }
}

- (BOOL)canPaste {
  NSPasteboard* pasteboard = [NSPasteboard generalPasteboard];
  return [pasteboard stringForType:NSPasteboardTypeString] != nil;
}

#pragma mark - 拖放支持

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
  if (!self.enablePaste) {
    return NSDragOperationNone;
  }
  
  NSPasteboard* pasteboard = [sender draggingPasteboard];
  if ([pasteboard stringForType:NSPasteboardTypeString]) {
    return NSDragOperationCopy;
  }
  
  return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
  if (!self.enablePaste) {
    return NO;
  }
  
  NSPasteboard* pasteboard = [sender draggingPasteboard];
  NSString* draggedString = [pasteboard stringForType:NSPasteboardTypeString];
  
  if (draggedString) {
    self.stringValue = draggedString;
    
    // 触发回调
    if (self.onPaste) {
      self.onPaste(draggedString);
    }
    
    // 发送值改变通知
    [self sendAction:self.action to:self.target];
    
    return YES;
  }
  
  return NO;
}

#pragma mark - 键盘快捷键

- (void)keyDown:(NSEvent *)event {
  // Cmd+V 粘贴
  NSLog(@"Cmd + V");
  if (event.modifierFlags & NSEventModifierFlagCommand) {
    if ([event.charactersIgnoringModifiers isEqualToString:@"v"]) {
      NSLog(@"Cmd + V Works");
      [self paste:nil];
      return;
    }
  }
  
  [super keyDown:event];
}

@end
