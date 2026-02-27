//
//  VideoMetadataEditor.h
//  VideoMetadataEditor
//
//  视频元数据编辑器
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>

#include "PasteableTextField.h"

@interface VideoMetadataEditor : NSViewController

// UI Components
@property (weak) IBOutlet PasteableTextField* linkField;
@property (weak) IBOutlet PasteableTextField* idField;
@property (weak) IBOutlet PasteableTextField* filePathField;
@property (weak) IBOutlet NSButton* reselectButton;
@property (weak) IBOutlet PasteableTextField* titleField;
@property (weak) IBOutlet PasteableTextField* authorField;
@property (weak) IBOutlet PasteableTextField* durationField;
@property (weak) IBOutlet PasteableTextField* titleNotesField;
@property (weak) IBOutlet NSTextView* noteTextView;
@property (weak) IBOutlet NSPopUpButton* resolutionPopup;
@property (weak) IBOutlet NSPopUpButton* languagePopup;
@property (weak) IBOutlet NSButton* englishButton;
@property (weak) IBOutlet NSButton* spanishButton;
@property (weak) IBOutlet NSButton* frenchButton;
@property (weak) IBOutlet PasteableTextField* yearField;
@property (weak) IBOutlet NSTextView* locationTextView;
@property (weak) IBOutlet AVPlayerView* playerView;
@property (weak) IBOutlet NSButton* cancelButton;
@property (weak) IBOutlet NSButton* saveButton;
@property (weak) IBOutlet NSButton* deleteButton;

// Properties
@property (strong, nonatomic) AVPlayer* player;
@property (strong, nonatomic) NSURL* videoURL;
@property (strong, nonatomic) NSString* videoID;
@property (strong, nonatomic) NSMutableSet* selectedLanguages;

// Actions
- (IBAction)reselectVideo:(id)sender;
- (IBAction)toggleLanguage:(id)sender;
- (IBAction)cancelEditing:(id)sender;
- (IBAction)saveMetadata:(id)sender;
- (IBAction)deleteVideo:(id)sender;
- (IBAction)saveToDatabase:(id)sender;

// Methods
- (void)loadVideoFromURL:(NSURL*)url;
- (void)populateMetadataFields;
- (void)clearForm;
- (NSString*)generateVideoID;
- (NSString *)extractYouTubeVideoID:(NSString *)urlString;

@end