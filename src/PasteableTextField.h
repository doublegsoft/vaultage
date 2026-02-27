//
//  PastableTextField.h
//  VideoMetadataEditor
//
//  支持粘贴操作的自定义 NSTextField
//

#import <Cocoa/Cocoa.h>

@interface PasteableTextField : NSTextField

// 是否启用粘贴（默认为 YES）
@property (nonatomic, assign) BOOL enablePaste;

// 粘贴完成回调
@property (nonatomic, copy) void (^onPaste)(NSString *pastedText);

@end
