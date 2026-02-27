# Video Metadata Editor - macOS 应用程序

## 项目简介

这是一个基于 Objective-C 和 Cocoa 框架开发的 macOS 桌面应用程序，用于编辑视频文件的元数据信息。

## 功能特性

- ✅ 视频文件选择和预览
- ✅ 编辑视频元数据（标题、作者、时长等）
- ✅ 自动检测视频分辨率和时长
- ✅ 多语言标签支持
- ✅ 元数据保存为 JSON 格式
- ✅ 视频删除功能
- ✅ 暗色主题界面

## 系统要求

- macOS 10.15 (Catalina) 或更高版本
- Xcode 11.0 或更高版本
- AVFoundation 框架支持

## 项目文件说明

```
VideoMetadataEditor/
├── VideoMetadataEditor.h          # 主视图控制器头文件
├── VideoMetadataEditor.m          # 主视图控制器实现
├── VideoMetadataEditor+UI.m       # 界面布局的编程式实现
├── AppDelegate.h                  # 应用程序委托头文件
├── AppDelegate.m                  # 应用程序委托实现
├── main.m                         # 程序入口
├── Info.plist                     # 应用配置文件
└── README.md                      # 项目说明文档
```

## 编译步骤

### 方法一：使用 Xcode（推荐）

1. 打开 Xcode，选择 "Create a new Xcode project"
2. 选择 "macOS" > "App"
3. 项目名称设为 "VideoMetadataEditor"
4. 语言选择 "Objective-C"
5. 将所有 `.h` 和 `.m` 文件添加到项目中
6. 将 `Info.plist` 文件替换默认的 Info.plist
7. 在项目设置中添加以下框架：
   - AVFoundation.framework
   - AVKit.framework
   - Cocoa.framework
8. 点击 Run 按钮编译运行

### 方法二：使用命令行

```bash
# 编译所有 Objective-C 文件
clang -framework Cocoa -framework AVFoundation -framework AVKit \
      main.m AppDelegate.m VideoMetadataEditor.m VideoMetadataEditor+UI.m \
      -o VideoMetadataEditor

# 运行应用程序
./VideoMetadataEditor
```

## 使用说明

### 1. 加载视频

- 点击 "Reselect" 按钮选择视频文件
- 支持的格式：MP4, MOV, M4V, AVI, MKV
- 视频将在左侧预览窗口显示

### 2. 编辑元数据

- **ID**: 自动生成的唯一标识符（不可编辑）
- **File Path/URL**: 视频文件路径
- **Title**: 视频标题（自动从文件名提取）
- **Author**: 作者名称
- **Duration**: 视频时长（自动检测）
- **Title Notes**: 标题备注
- **Resolution**: 视频分辨率（自动检测）
- **Language**: 语言选择（下拉菜单）
- **Language Tags**: 多语言标签（en/es/fr）
- **Year**: 年份
- **Location**: 位置信息（支持多行文本）

### 3. 保存和删除

- **Save**: 保存元数据到 JSON 文件
  - 保存位置：`~/Documents/VideoMetadata/`
  - 文件格式：`{VideoID}.json`

- **Cancel**: 取消编辑并清空表单

- **Delete Video**: 删除视频文件（需确认）

## 数据存储

元数据以 JSON 格式保存，示例：

```json
{
  "id": "a1b2c3d4",
  "filePath": "/Users/username/Videos/example.mp4",
  "title": "Example Video",
  "author": "John Doe",
  "duration": "5:30",
  "titleNotes": "Sample video notes",
  "resolution": "1920x1080",
  "language": "English",
  "selectedLanguages": ["en", "es"],
  "year": "2025",
  "location": "San Francisco, CA"
}
```

## 界面截图功能

### 视频预览区域
- 尺寸：320x180
- 位置：窗口左上方
- 支持播放控制

### 元数据表单区域
- 暗色主题设计
- 自动布局
- 输入验证

### 操作按钮
- Cancel：灰色按钮
- Save：蓝色按钮
- Delete Video：红色按钮

## 技术特点

### 1. AVFoundation 集成
```objective-c
// 加载视频
AVAsset *asset = [AVAsset assetWithURL:url];
AVPlayer *player = [AVPlayer playerWithURL:url];
```

### 2. 自动元数据提取
```objective-c
// 获取视频时长
CMTime duration = asset.duration;

// 获取视频分辨率
AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
CGSize size = videoTrack.naturalSize;
```

### 3. 数据持久化
```objective-c
// JSON 序列化
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:metadata 
                                                   options:NSJSONWritingPrettyPrinted 
                                                     error:&error];
```

## 扩展功能建议

1. **批量处理**：支持同时编辑多个视频
2. **导出功能**：导出元数据到 CSV/XML
3. **云同步**：支持 iCloud 同步
4. **视频编辑**：集成简单的视频剪辑功能
5. **标签管理**：可自定义标签系统
6. **搜索功能**：根据元数据搜索视频

## 常见问题

### Q: 无法加载视频？
A: 确保视频格式被支持，并且应用有文件访问权限。

### Q: 元数据保存在哪里？
A: 默认保存在 `~/Documents/VideoMetadata/` 目录。

### Q: 如何修改界面颜色？
A: 在 `VideoMetadataEditor+UI.m` 中修改颜色设置。

## 许可证

MIT License

## 联系方式

如有问题或建议，请联系开发者。

## 更新日志

### v1.0 (2025-02-25)
- 初始版本发布
- 基础元数据编辑功能
- 视频预览支持
- JSON 数据存储
