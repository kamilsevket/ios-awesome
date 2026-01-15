.PHONY: build test test-unit test-snapshot test-accessibility test-ui lint clean coverage help \
       xcode-build xcode-build-ios xcode-build-macos xcode-build-tvos xcode-build-watchos \
       xcode-test xcode-test-ios xcode-archive xcode-clean xcode-info

# Default target
all: build test

# Build the package
build:
	@echo "Building package..."
	swift build

# Run all tests
test:
	@echo "Running all tests..."
	swift test

# Run unit tests only
test-unit:
	@echo "Running unit tests..."
	swift test --filter UnitTests

# Run snapshot tests only
test-snapshot:
	@echo "Running snapshot tests..."
	swift test --filter SnapshotTests

# Run accessibility tests only
test-accessibility:
	@echo "Running accessibility tests..."
	swift test --filter AccessibilityTests

# Run UI tests only
test-ui:
	@echo "Running UI tests..."
	swift test --filter UITests

# Run tests with code coverage
coverage:
	@echo "Running tests with coverage..."
	swift test --enable-code-coverage
	@echo "Coverage report generated"

# Run SwiftLint
lint:
	@echo "Running SwiftLint..."
	swiftlint lint

# Fix SwiftLint issues
lint-fix:
	@echo "Fixing SwiftLint issues..."
	swiftlint lint --fix

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	swift package clean
	rm -rf .build
	rm -rf *.xcodeproj

# Generate Xcode project
xcode:
	@echo "Generating Xcode project..."
	swift package generate-xcodeproj

# Update dependencies
update:
	@echo "Updating dependencies..."
	swift package update

# Resolve dependencies
resolve:
	@echo "Resolving dependencies..."
	swift package resolve

# Record snapshots (set isRecording = true in tests first)
record-snapshots:
	@echo "Recording snapshots..."
	@echo "Make sure to set isRecording = true in SnapshotTestCase.swift"
	swift test --filter SnapshotTests

# =============================================================================
# XCODE BUILD COMMANDS (xcodebuild)
# =============================================================================

# Configuration variables
SCHEME ?= DesignSystem
CONFIGURATION ?= Debug
DERIVED_DATA_PATH ?= .build/DerivedData
IOS_DESTINATION ?= platform=iOS Simulator,name=iPhone 15,OS=latest
MACOS_DESTINATION ?= platform=macOS
TVOS_DESTINATION ?= platform=tvOS Simulator,name=Apple TV,OS=latest
WATCHOS_DESTINATION ?= platform=watchOS Simulator,name=Apple Watch Series 9 (45mm),OS=latest

# Build using xcodebuild (auto-detects platform)
xcode-build:
	@echo "Building with xcodebuild..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		| xcpretty || xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION)

# Build for iOS Simulator
xcode-build-ios:
	@echo "Building for iOS Simulator..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(IOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		| xcpretty || xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(IOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION)

# Build for macOS
xcode-build-macos:
	@echo "Building for macOS..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		| xcpretty || xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION)

# Build for tvOS Simulator
xcode-build-tvos:
	@echo "Building for tvOS Simulator..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(TVOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		| xcpretty || xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(TVOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION)

# Build for watchOS Simulator
xcode-build-watchos:
	@echo "Building for watchOS Simulator..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(WATCHOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		| xcpretty || xcodebuild build \
		-scheme $(SCHEME) \
		-destination "$(WATCHOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION)

# Run tests using xcodebuild
xcode-test:
	@echo "Running tests with xcodebuild..."
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		-enableCodeCoverage YES \
		| xcpretty || xcodebuild test \
		-scheme $(SCHEME) \
		-destination "$(MACOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		-enableCodeCoverage YES

# Run tests for iOS Simulator using xcodebuild
xcode-test-ios:
	@echo "Running tests for iOS Simulator..."
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination "$(IOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		-enableCodeCoverage YES \
		| xcpretty || xcodebuild test \
		-scheme $(SCHEME) \
		-destination "$(IOS_DESTINATION)" \
		-derivedDataPath $(DERIVED_DATA_PATH) \
		-configuration $(CONFIGURATION) \
		-enableCodeCoverage YES

# Archive the framework (for release)
xcode-archive:
	@echo "Creating archive..."
	xcodebuild archive \
		-scheme $(SCHEME) \
		-destination "generic/platform=iOS" \
		-archivePath .build/$(SCHEME).xcarchive \
		-configuration Release \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Clean xcodebuild artifacts
xcode-clean:
	@echo "Cleaning xcodebuild artifacts..."
	xcodebuild clean \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		2>/dev/null || true
	rm -rf $(DERIVED_DATA_PATH)
	rm -rf .build/*.xcarchive

# Show available schemes and destinations
xcode-info:
	@echo "=== Available Schemes ==="
	@xcodebuild -list 2>/dev/null || echo "Run 'swift package generate-xcodeproj' first or use Package.swift directly"
	@echo ""
	@echo "=== Available Simulators ==="
	@xcrun simctl list devices available 2>/dev/null | head -30 || echo "Xcode command line tools not available"

# =============================================================================
# HELP
# =============================================================================

# Help
help:
	@echo "Available targets:"
	@echo ""
	@echo "  Swift Package Manager Commands:"
	@echo "  --------------------------------"
	@echo "  build             - Build the package"
	@echo "  test              - Run all tests"
	@echo "  test-unit         - Run unit tests only"
	@echo "  test-snapshot     - Run snapshot tests only"
	@echo "  test-accessibility- Run accessibility tests only"
	@echo "  test-ui           - Run UI tests only"
	@echo "  coverage          - Run tests with code coverage"
	@echo "  lint              - Run SwiftLint"
	@echo "  lint-fix          - Fix SwiftLint issues"
	@echo "  clean             - Clean build artifacts"
	@echo "  xcode             - Generate Xcode project"
	@echo "  update            - Update dependencies"
	@echo "  resolve           - Resolve dependencies"
	@echo "  record-snapshots  - Record new snapshots"
	@echo ""
	@echo "  Xcode Build Commands (xcodebuild):"
	@echo "  -----------------------------------"
	@echo "  xcode-build       - Build using xcodebuild (macOS)"
	@echo "  xcode-build-ios   - Build for iOS Simulator"
	@echo "  xcode-build-macos - Build for macOS"
	@echo "  xcode-build-tvos  - Build for tvOS Simulator"
	@echo "  xcode-build-watchos - Build for watchOS Simulator"
	@echo "  xcode-test        - Run tests with xcodebuild (macOS)"
	@echo "  xcode-test-ios    - Run tests for iOS Simulator"
	@echo "  xcode-archive     - Create release archive"
	@echo "  xcode-clean       - Clean xcodebuild artifacts"
	@echo "  xcode-info        - Show available schemes/destinations"
	@echo ""
	@echo "  Configuration Variables:"
	@echo "  -------------------------"
	@echo "  SCHEME=<name>       - Target scheme (default: DesignSystem)"
	@echo "  CONFIGURATION=<cfg> - Build config (default: Debug)"
	@echo ""
	@echo "  Example: make xcode-build-ios SCHEME=IOSComponents CONFIGURATION=Release"
	@echo ""
	@echo "  help              - Show this help message"
