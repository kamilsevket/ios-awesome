.PHONY: build test test-unit test-snapshot test-accessibility test-ui lint clean coverage help

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

# Help
help:
	@echo "Available targets:"
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
	@echo "  help              - Show this help message"
