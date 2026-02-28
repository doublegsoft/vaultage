# Makefile for VideoMetadataEditor
# macOS Cocoa Application

# Compiler
CC = clang

# Application name
APP_NAME = Vaultage
BUNDLE_NAME = $(APP_NAME).app

# Directories
BUILD_DIR = build
CONTENTS_DIR = $(BUILD_DIR)/$(BUNDLE_NAME)/Contents
MACOS_DIR = $(CONTENTS_DIR)/MacOS
APP_ICON = res/vaultage.icns
RESOURCES_DIR = $(CONTENTS_DIR)/Resources

# Source files
SOURCES = src/main.m \
          src/PasteableTextField.m \
          src/AppDelegate.m \
					src/MenuManager.m \
          src/VideoMetadataEditor.m \
          src/VideoMetadataEditor+UI.m \
          src/sqlite3.c

# Frameworks
FRAMEWORKS = -framework Cocoa \
             -framework AVFoundation \
             -framework AVKit

# Compiler flags
CFLAGS = -fmodules \
         -fobjc-arc \
         -mmacosx-version-min=10.15 \
				 -Wno-ambiguous-macro

# Build targets
.PHONY: all clean run bundle

all: bundle

# Create application bundle structure
bundle: $(SOURCES)
	@echo "Creating application bundle structure..."
	@mkdir -p $(MACOS_DIR)
	@mkdir -p $(RESOURCES_DIR)
	
	@echo "Compiling source files..."
	$(CC) $(CFLAGS) $(FRAMEWORKS) $(SOURCES) -o $(MACOS_DIR)/$(APP_NAME)
	
	@echo "Copying resources..."
	@cp res/Info.plist $(CONTENTS_DIR)/
	@cp $(APP_ICON) $(RESOURCES_DIR)/
	
	@echo "Creating PkgInfo..."
	@echo -n "APPL????" > $(CONTENTS_DIR)/PkgInfo
	
	@echo "Bundle created at: $(BUILD_DIR)/$(BUNDLE_NAME)"
	@echo "Build complete!"

# Run the application
run: bundle
	@echo "Running $(APP_NAME)..."
	@open $(BUILD_DIR)/$(BUNDLE_NAME)

# Clean build artifacts
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete!"

# Install to Applications folder (requires sudo)
install: bundle
	@echo "Installing to /Applications..."
	@sudo cp -R $(BUILD_DIR)/$(BUNDLE_NAME) /Applications/
	@echo "Installation complete!"

# Uninstall from Applications folder (requires sudo)
uninstall:
	@echo "Uninstalling from /Applications..."
	@sudo rm -rf /Applications/$(BUNDLE_NAME)
	@echo "Uninstall complete!"

# Help target
help:
	@echo "VideoMetadataEditor - Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  all (default) - Build the application bundle"
	@echo "  bundle        - Create the .app bundle"
	@echo "  run           - Build and run the application"
	@echo "  clean         - Remove build artifacts"
	@echo "  install       - Install to /Applications (requires sudo)"
	@echo "  uninstall     - Remove from /Applications (requires sudo)"
	@echo "  help          - Show this help message"
