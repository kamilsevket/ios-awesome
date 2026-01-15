import SwiftUI
import DesignSystem

/// Demo view showcasing all feedback components: Alerts, Toasts, Loading, and Empty States.
public struct FeedbackDemoView: View {
    public init() {}

    public var body: some View {
        List {
            NavigationLink("Alerts & Dialogs", destination: AlertsDemoView())
            NavigationLink("Toasts & Snackbars", destination: ToastsDemoView())
            NavigationLink("Loading Indicators", destination: LoadingDemoView())
            NavigationLink("Empty States", destination: EmptyStatesDemoView())
            NavigationLink("Overlays", destination: OverlaysDemoView())
        }
        .navigationTitle("Feedback")
    }
}

// MARK: - Alerts Demo

struct AlertsDemoView: View {
    @State private var showBasicAlert = false
    @State private var showConfirmDialog = false
    @State private var showCustomDialog = false
    @State private var showDestructiveAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Alert
                sectionHeader("Basic Alert")
                DSButton("Show Alert", style: .primary) {
                    showBasicAlert = true
                }
                .dsAlert(
                    isPresented: $showBasicAlert,
                    title: "Information",
                    message: "This is a basic informational alert.",
                    primaryAction: DSAlertAction(title: "OK") {
                        showBasicAlert = false
                    }
                )

                Divider()

                // Confirmation Dialog
                sectionHeader("Confirmation Dialog")
                DSButton("Show Confirmation", style: .secondary) {
                    showConfirmDialog = true
                }
                .dsConfirmationDialog(
                    isPresented: $showConfirmDialog,
                    title: "Confirm Action",
                    message: "Are you sure you want to proceed with this action?",
                    confirmAction: DSAlertAction(title: "Confirm", style: .default) {
                        print("Confirmed")
                        showConfirmDialog = false
                    },
                    cancelAction: DSAlertAction(title: "Cancel", style: .cancel) {
                        showConfirmDialog = false
                    }
                )

                Divider()

                // Destructive Alert
                sectionHeader("Destructive Alert")
                DSButton("Delete Item", style: .primary) {
                    showDestructiveAlert = true
                }
                .dsAlert(
                    isPresented: $showDestructiveAlert,
                    title: "Delete Item",
                    message: "This action cannot be undone. Are you sure you want to delete this item?",
                    primaryAction: DSAlertAction(title: "Delete", style: .destructive) {
                        print("Deleted")
                        showDestructiveAlert = false
                    },
                    secondaryAction: DSAlertAction(title: "Cancel", style: .cancel) {
                        showDestructiveAlert = false
                    }
                )

                Divider()

                // Custom Dialog
                sectionHeader("Custom Dialog")
                DSButton("Show Custom Dialog", style: .tertiary) {
                    showCustomDialog = true
                }
                .dsCustomDialog(isPresented: $showCustomDialog) {
                    VStack(spacing: DSSpacing.lg) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(DSColors.success)

                        Text("Success!")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Your changes have been saved successfully.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                            .multilineTextAlignment(.center)

                        DSButton("Continue", style: .primary, isFullWidth: true) {
                            showCustomDialog = false
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Alerts & Dialogs")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Toasts Demo

struct ToastsDemoView: View {
    @StateObject private var toastManager = DSToastManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Toast Types
                sectionHeader("Toast Types")
                VStack(spacing: DSSpacing.md) {
                    DSButton("Success Toast", style: .primary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "Operation completed successfully!",
                                type: .success
                            )
                        )
                    }

                    DSButton("Error Toast", style: .primary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "Something went wrong. Please try again.",
                                type: .error
                            )
                        )
                    }

                    DSButton("Warning Toast", style: .primary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "Your session is about to expire.",
                                type: .warning
                            )
                        )
                    }

                    DSButton("Info Toast", style: .primary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "New updates are available.",
                                type: .info
                            )
                        )
                    }
                }

                Divider()

                // Toast Positions
                sectionHeader("Toast Positions")
                VStack(spacing: DSSpacing.md) {
                    DSButton("Top Toast", style: .secondary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "Toast at the top",
                                type: .info,
                                position: .top
                            )
                        )
                    }

                    DSButton("Bottom Toast", style: .secondary, isFullWidth: true) {
                        toastManager.show(
                            DSToastItem(
                                message: "Toast at the bottom",
                                type: .info,
                                position: .bottom
                            )
                        )
                    }
                }

                Divider()

                // Snackbar
                sectionHeader("Snackbar with Action")
                DSButton("Show Snackbar", style: .tertiary, isFullWidth: true) {
                    toastManager.show(
                        DSToastItem(
                            message: "Item deleted",
                            type: .info,
                            action: DSToastItem.Action(title: "Undo") {
                                print("Undo tapped")
                            }
                        )
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Toasts & Snackbars")
        .navigationBarTitleDisplayMode(.inline)
        .dsToastContainer()
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Loading Demo

struct LoadingDemoView: View {
    @State private var progress: Double = 0.65
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Circular Progress
                sectionHeader("Circular Progress")
                HStack(spacing: DSSpacing.xl) {
                    DSCircularProgress(style: .indeterminate, size: .small)
                    DSCircularProgress(style: .indeterminate, size: .medium)
                    DSCircularProgress(style: .indeterminate, size: .large)
                }

                Divider()

                // Determinate Circular Progress
                sectionHeader("Determinate Progress")
                HStack(spacing: DSSpacing.xl) {
                    DSCircularProgress(progress: 0.25, size: .medium)
                    DSCircularProgress(progress: 0.50, size: .medium)
                    DSCircularProgress(progress: 0.75, size: .medium)
                    DSCircularProgress(progress: 1.0, size: .medium)
                }

                Divider()

                // Linear Progress
                sectionHeader("Linear Progress")
                VStack(spacing: DSSpacing.md) {
                    DSLinearProgress(style: .indeterminate)

                    DSLinearProgress(progress: progress)

                    HStack {
                        DSButton("Decrease", style: .secondary, size: .small) {
                            progress = max(0, progress - 0.1)
                        }
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.body)
                        Spacer()
                        DSButton("Increase", style: .secondary, size: .small) {
                            progress = min(1, progress + 0.1)
                        }
                    }
                }

                Divider()

                // Skeleton Loading
                sectionHeader("Skeleton Loading")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    // Card skeleton
                    HStack(spacing: DSSpacing.md) {
                        DSSkeleton(shape: .circle)
                            .frame(width: 48, height: 48)

                        VStack(alignment: .leading, spacing: DSSpacing.xs) {
                            DSSkeleton(shape: .rectangle)
                                .frame(width: 120, height: 16)
                            DSSkeleton(shape: .rectangle)
                                .frame(width: 80, height: 12)
                        }
                    }

                    DSSkeleton(shape: .rectangle)
                        .frame(height: 100)

                    HStack(spacing: DSSpacing.sm) {
                        DSSkeleton(shape: .rectangle)
                            .frame(width: 60, height: 24)
                        DSSkeleton(shape: .rectangle)
                            .frame(width: 60, height: 24)
                    }
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // Loading Overlay
                sectionHeader("Loading Overlay")
                DSButton("Simulate Loading", style: .primary, isFullWidth: true) {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }

                // Demo card with loading overlay
                VStack {
                    Text("Content Area")
                        .font(.headline)
                    Text("This content will be covered by a loading overlay")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)
                .loadingOverlay(isLoading: isLoading)
            }
            .padding()
        }
        .navigationTitle("Loading Indicators")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Empty States Demo

struct EmptyStatesDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xxl) {
                // Empty State
                sectionHeader("Empty State")
                DSEmptyState(
                    type: .empty,
                    title: "No Items",
                    message: "You haven't added any items yet.",
                    actionTitle: "Add Item"
                ) {
                    print("Add item tapped")
                }

                Divider()

                // No Results
                sectionHeader("No Search Results")
                DSEmptyState(
                    type: .noResults,
                    title: "No Results Found",
                    message: "Try adjusting your search or filters."
                )

                Divider()

                // Error State
                sectionHeader("Error State")
                DSEmptyState(
                    type: .error,
                    title: "Something Went Wrong",
                    message: "We couldn't load your data. Please try again.",
                    actionTitle: "Retry"
                ) {
                    print("Retry tapped")
                }

                Divider()

                // Offline State
                sectionHeader("Offline State")
                DSEmptyState(
                    type: .offline,
                    title: "You're Offline",
                    message: "Check your internet connection and try again.",
                    actionTitle: "Refresh"
                ) {
                    print("Refresh tapped")
                }

                Divider()

                // Custom Empty State
                sectionHeader("Custom Empty State")
                DSEmptyState(
                    type: .custom(icon: Image(systemName: "star")),
                    title: "No Favorites",
                    message: "Items you favorite will appear here.",
                    size: .small
                )
            }
            .padding()
        }
        .navigationTitle("Empty States")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Overlays Demo

struct OverlaysDemoView: View {
    @State private var showModal = false
    @State private var showBottomSheet = false
    @State private var showActionSheet = false
    @State private var showFullScreenCover = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Modal
                sectionHeader("Modal")
                DSButton("Show Modal", style: .primary, isFullWidth: true) {
                    showModal = true
                }
                .dsModal(isPresented: $showModal) {
                    VStack(spacing: DSSpacing.lg) {
                        Text("Modal Content")
                            .font(.headline)

                        Text("This is a modal dialog that appears over the current content.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                            .multilineTextAlignment(.center)

                        DSButton("Close", style: .primary) {
                            showModal = false
                        }
                    }
                    .padding()
                }

                Divider()

                // Bottom Sheet
                sectionHeader("Bottom Sheet")
                DSButton("Show Bottom Sheet", style: .secondary, isFullWidth: true) {
                    showBottomSheet = true
                }
                .dsBottomSheet(isPresented: $showBottomSheet) {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {
                        Text("Bottom Sheet")
                            .font(.headline)

                        Text("Bottom sheets slide up from the bottom of the screen and are commonly used for additional actions or content.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)

                        ForEach(["Option 1", "Option 2", "Option 3"], id: \.self) { option in
                            Button(action: {
                                print("\(option) selected")
                                showBottomSheet = false
                            }) {
                                HStack {
                                    Text(option)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(DSColors.textTertiary)
                                }
                            }
                            .foregroundColor(DSColors.textPrimary)
                        }
                    }
                    .padding()
                }

                Divider()

                // Action Sheet
                sectionHeader("Action Sheet")
                DSButton("Show Action Sheet", style: .tertiary, isFullWidth: true) {
                    showActionSheet = true
                }
                .dsActionSheet(isPresented: $showActionSheet) {
                    DSActionSheet(
                        title: "Choose an Action",
                        message: "Select one of the options below",
                        actions: [
                            DSActionSheet.Action(title: "Take Photo", icon: Image(systemName: "camera")) {
                                print("Take photo")
                            },
                            DSActionSheet.Action(title: "Choose from Library", icon: Image(systemName: "photo")) {
                                print("Choose from library")
                            },
                            DSActionSheet.Action(title: "Delete", icon: Image(systemName: "trash"), role: .destructive) {
                                print("Delete")
                            }
                        ],
                        cancelAction: DSActionSheet.Action(title: "Cancel", role: .cancel) {
                            showActionSheet = false
                        }
                    )
                }

                Divider()

                // Full Screen Cover
                sectionHeader("Full Screen Cover")
                DSButton("Show Full Screen", style: .primary, isFullWidth: true) {
                    showFullScreenCover = true
                }
                .dsFullScreenCover(isPresented: $showFullScreenCover) {
                    NavigationView {
                        VStack(spacing: DSSpacing.xl) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 80))
                                .foregroundColor(DSColors.success)

                            Text("Full Screen Content")
                                .font(.title)

                            Text("This view covers the entire screen and requires explicit dismissal.")
                                .font(.body)
                                .foregroundColor(DSColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Spacer()

                            DSButton("Dismiss", style: .primary, isFullWidth: true) {
                                showFullScreenCover = false
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .navigationTitle("Full Screen")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showFullScreenCover = false
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Overlays")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct FeedbackDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedbackDemoView()
        }
    }
}
#endif
