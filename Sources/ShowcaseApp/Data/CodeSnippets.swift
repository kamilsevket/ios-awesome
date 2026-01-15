import Foundation

/// Code snippets for component documentation
public enum CodeSnippets {

    public static func snippet(for componentName: String) -> String {
        switch componentName {
        // Foundation
        case "Colors":
            return """
            import DesignSystem

            // Using semantic colors
            Text("Primary text")
                .foregroundColor(DSColors.primary)

            // Background colors
            VStack {
                // Content
            }
            .background(DSColors.backgroundPrimary)

            // Status colors
            Circle()
                .fill(DSColors.statusOnline)
            """

        case "Typography":
            return """
            import DesignSystemTypography

            // Using typography tokens
            Text("Large Title")
                .font(.dsLargeTitle)

            Text("Body text")
                .font(.dsBody)

            // With custom weight
            Text("Bold headline")
                .font(.dsHeadline)
                .fontWeight(.bold)
            """

        case "Spacing":
            return """
            import DesignSystem

            VStack(spacing: DSSpacing.md) {
                Text("Item 1")
                Text("Item 2")
            }
            .padding(DSSpacing.lg)

            // Spacing values:
            // xxs: 2, xs: 4, sm: 8, md: 12
            // lg: 16, xl: 24, xxl: 32
            """

        case "Icons":
            return """
            import FoundationIcons

            // SF Symbol
            Icon.system(.heart)
                .iconSize(.md)

            // With custom color
            Icon.system(.star)
                .iconSize(.lg)
                .foregroundColor(.yellow)

            // Custom icon
            Icon.custom(.logo)
            """

        case "Shadows":
            return """
            import DesignSystem

            // Using shadow presets
            Card {
                Text("Elevated card")
            }
            .shadow(DSShadow.small)

            // Medium shadow
            .shadow(DSShadow.medium)

            // Large shadow
            .shadow(DSShadow.large)
            """

        // Basic
        case "Button":
            return """
            import DesignSystem

            // Primary button
            DSButton("Save", style: .primary) {
                saveData()
            }

            // With icon
            DSButton("Add Item",
                     style: .secondary,
                     icon: Image(systemName: "plus")) {
                addItem()
            }

            // Loading state
            DSButton("Submit",
                     style: .primary,
                     isLoading: isSubmitting) {
                submit()
            }

            // Full width
            DSButton("Continue",
                     style: .primary,
                     isFullWidth: true) {
                continueFlow()
            }
            """

        case "IconButton":
            return """
            import DesignSystem

            // Icon button
            DSIconButton(
                icon: Image(systemName: "heart"),
                style: .primary
            ) {
                toggleFavorite()
            }

            // With size
            DSIconButton(
                icon: Image(systemName: "share"),
                size: .large
            ) {
                shareContent()
            }
            """

        case "FloatingActionButton":
            return """
            import DesignSystem

            ZStack {
                // Main content
                ContentView()

                // FAB
                DSFloatingActionButton(
                    icon: Image(systemName: "plus")
                ) {
                    createNew()
                }
            }
            """

        case "Card":
            return """
            import DesignSystem

            // Basic card
            DSCard {
                VStack(alignment: .leading) {
                    Text("Card Title")
                        .font(.headline)
                    Text("Card content")
                }
            }

            // Elevated card
            DSCard(style: .elevated) {
                Text("Elevated content")
            }

            // Interactive card
            DSInteractiveCard {
                Text("Tap me")
            } action: {
                handleTap()
            }
            """

        case "Avatar":
            return """
            import DesignSystem

            // With image URL
            DSAvatar(
                imageURL: user.avatarURL,
                size: .medium
            )

            // With initials
            DSAvatar(
                initials: "JD",
                size: .large,
                backgroundColor: .blue
            )

            // With status
            DSAvatar(
                imageURL: user.avatarURL,
                size: .medium,
                status: .online
            )

            // Avatar group
            DSAvatarGroup(
                users: users,
                maxDisplay: 4
            )
            """

        case "Badge":
            return """
            import DesignSystem

            // Basic badge
            DSBadge("New")

            // With style
            DSBadge("Sale", style: .error)

            // Status badge
            DSStatusBadge(.online)

            // Notification count
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                DSBadge("3", style: .error)
            }
            """

        case "Tag":
            return """
            import DesignSystem

            // Basic tag
            DSTag("Swift")

            // Selectable chip
            DSSelectableChip(
                "iOS",
                isSelected: $isSelected
            )

            // Filter chip
            DSFilterChip(
                "Category",
                isActive: isFiltered
            ) {
                toggleFilter()
            }
            """

        case "TextField":
            return """
            import DesignSystem

            // Basic text field
            DSTextField(
                text: $username,
                placeholder: "Username"
            )

            // With label
            DSTextField(
                text: $email,
                placeholder: "email@example.com",
                label: "Email"
            )

            // Secure field
            DSSecureTextField(
                text: $password,
                placeholder: "Password"
            )

            // With validation
            DSTextField(
                text: $input,
                placeholder: "Enter value",
                errorMessage: validationError
            )
            """

        // Navigation
        case "TabBar":
            return """
            import DesignSystem

            DSTabBar(selection: $selectedTab) {
                DSTab(
                    "Home",
                    icon: Image(systemName: "house"),
                    tag: 0
                )
                DSTab(
                    "Search",
                    icon: Image(systemName: "magnifyingglass"),
                    tag: 1
                )
                DSTab(
                    "Profile",
                    icon: Image(systemName: "person"),
                    badge: "3",
                    tag: 2
                )
            }
            """

        case "NavigationBar":
            return """
            import DesignSystem

            DSNavigationBar(
                title: "Settings",
                leadingItems: [
                    DSBackButton { goBack() }
                ],
                trailingItems: [
                    DSIconButton(icon: Image(systemName: "gear")) {
                        openSettings()
                    }
                ]
            )

            // With large title
            DSNavigationBar(
                title: "Profile",
                style: .largeTitle
            )
            """

        case "SegmentedControl":
            return """
            import DesignSystem

            DSSegmentedControl(
                selection: $selectedSegment,
                segments: [
                    DSSegment("Day", tag: 0),
                    DSSegment("Week", tag: 1),
                    DSSegment("Month", tag: 2)
                ]
            )
            """

        // Feedback
        case "Alert":
            return """
            import DesignSystem

            // Basic alert
            DSAlert(
                title: "Success",
                message: "Your changes have been saved.",
                type: .success
            )

            // With actions
            DSAlert(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                type: .warning,
                primaryAction: DSAlertAction("Delete", style: .destructive) {
                    deleteItem()
                },
                secondaryAction: DSAlertAction("Cancel") {
                    dismiss()
                }
            )
            """

        case "Toast":
            return """
            import DesignSystem

            // Show toast
            ToastManager.shared.show(
                DSToast(
                    message: "Item saved",
                    type: .success
                )
            )

            // With action
            ToastManager.shared.show(
                DSToast(
                    message: "Item deleted",
                    type: .info,
                    action: DSToastAction("Undo") {
                        undoDelete()
                    }
                )
            )
            """

        case "Snackbar":
            return """
            import DesignSystem

            DSSnackbar(
                message: "Message sent",
                action: DSSnackbarAction("Undo") {
                    undoSend()
                }
            )
            """

        case "EmptyState":
            return """
            import DesignSystem

            DSEmptyState(
                icon: Image(systemName: "doc.text"),
                title: "No Documents",
                message: "Create your first document to get started.",
                action: DSButton("Create Document") {
                    createDocument()
                }
            )
            """

        case "LoadingIndicator":
            return """
            import DesignSystem

            // Circular loading
            DSCircularProgress()

            // With custom color
            DSCircularProgress()
                .tint(.purple)

            // Linear progress
            DSLinearProgress(value: 0.7)
            """

        case "Skeleton":
            return """
            import DesignSystem

            // Skeleton loading
            DSSkeleton()
                .frame(height: 20)

            // Multiple lines
            VStack {
                DSSkeleton().frame(height: 16)
                DSSkeleton().frame(height: 16)
                DSSkeleton().frame(width: 100, height: 16)
            }

            // With shimmer
            DSSkeleton()
                .shimmer()
            """

        case "Progress":
            return """
            import DesignSystem

            // Linear progress
            DSLinearProgress(value: progress)

            // Circular progress
            DSCircularProgress(value: progress)

            // With label
            DSLinearProgress(value: progress) {
                Text("\\(Int(progress * 100))%")
            }
            """

        // Form
        case "Checkbox":
            return """
            import DesignSystem

            DSCheckbox(
                isChecked: $isAgreed,
                label: "I agree to the terms"
            )

            // Disabled state
            DSCheckbox(
                isChecked: .constant(true),
                label: "Selected",
                isDisabled: true
            )
            """

        case "RadioButton":
            return """
            import DesignSystem

            DSRadioGroup(selection: $selectedOption) {
                DSRadioButton("Option 1", tag: 0)
                DSRadioButton("Option 2", tag: 1)
                DSRadioButton("Option 3", tag: 2)
            }
            """

        case "Toggle":
            return """
            import DesignSystem

            DSToggle(
                isOn: $isEnabled,
                label: "Enable notifications"
            )

            // With custom color
            DSToggle(
                isOn: $isPremium,
                label: "Premium mode"
            )
            .tint(.purple)
            """

        case "Slider":
            return """
            import DesignSystem

            // Basic slider
            DSSlider(value: $volume, in: 0...100)

            // With labels
            DSSlider(value: $brightness, in: 0...100) {
                Image(systemName: "sun.min")
            } maximumValueLabel: {
                Image(systemName: "sun.max")
            }

            // Stepped
            DSSlider(value: $rating, in: 1...5, step: 1)
            """

        case "RangeSlider":
            return """
            import DesignSystem

            DSRangeSlider(
                lowValue: $minPrice,
                highValue: $maxPrice,
                in: 0...1000
            )
            """

        case "DatePicker":
            return """
            import DesignSystem

            // Compact style
            DSDatePicker(
                selection: $date,
                label: "Select date"
            )

            // Graphical style
            DSDatePicker(
                selection: $date,
                style: .graphical
            )

            // With range
            DSDatePicker(
                selection: $date,
                in: Date()...,
                label: "Future date"
            )
            """

        case "TimePicker":
            return """
            import DesignSystem

            DSTimePicker(
                selection: $time,
                label: "Select time"
            )

            // 24-hour format
            DSTimePicker(
                selection: $time,
                use24HourFormat: true
            )
            """

        case "Dropdown":
            return """
            import DesignSystem

            DSDropdownMenu(
                selection: $selectedOption,
                options: options,
                placeholder: "Select an option"
            )

            // Searchable
            DSSearchableDropdown(
                selection: $selectedCountry,
                options: countries,
                placeholder: "Search countries"
            )
            """

        case "MultiSelect":
            return """
            import DesignSystem

            DSMultiSelect(
                selections: $selectedTags,
                options: availableTags,
                placeholder: "Select tags"
            )
            """

        // Overlay
        case "Modal":
            return """
            import DesignSystem

            .sheet(isPresented: $showModal) {
                DSModal(
                    title: "Edit Profile",
                    onDismiss: { showModal = false }
                ) {
                    ProfileEditForm()
                }
            }
            """

        case "BottomSheet":
            return """
            import DesignSystem

            .sheet(isPresented: $showSheet) {
                DSBottomSheet(
                    detents: [.medium, .large],
                    selectedDetent: $selectedDetent
                ) {
                    SheetContent()
                }
            }
            """

        case "ActionSheet":
            return """
            import DesignSystem

            .confirmationDialog(
                "Actions",
                isPresented: $showActions
            ) {
                Button("Edit") { edit() }
                Button("Share") { share() }
                Button("Delete", role: .destructive) { delete() }
            }
            """

        case "Popover":
            return """
            import DesignSystem

            Button("Info") {
                showPopover = true
            }
            .popover(isPresented: $showPopover) {
                DSPopover {
                    Text("Additional information")
                }
            }
            """

        case "Tooltip":
            return """
            import DesignSystem

            Button("Help") {}
                .dsTooltip("Click for help")

            // With custom position
            Image(systemName: "info.circle")
                .dsTooltip(
                    "More info",
                    position: .bottom
                )
            """

        case "ContextMenu":
            return """
            import DesignSystem

            Image("photo")
                .contextMenu {
                    Button {
                        copy()
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                    Button {
                        share()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        delete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            """

        // Data Display
        case "List":
            return """
            import DesignSystem

            DSList {
                DSSection("Recent") {
                    ForEach(recentItems) { item in
                        DSListRow(item: item)
                    }
                }
            }

            // With swipe actions
            DSList {
                ForEach(items) { item in
                    DSListRow(item: item)
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                delete(item)
                            }
                        }
                }
            }
            """

        case "Grid":
            return """
            import DesignSystem

            // Basic grid
            DSGrid(columns: 3) {
                ForEach(items) { item in
                    GridItem(item: item)
                }
            }

            // Adaptive grid
            DSAdaptiveGrid(minItemWidth: 150) {
                ForEach(items) { item in
                    GridItem(item: item)
                }
            }

            // Masonry grid
            DSMasonryGrid(columns: 2) {
                ForEach(items) { item in
                    MasonryItem(item: item)
                }
            }
            """

        case "Carousel":
            return """
            import DesignSystem

            DSCarousel(items: items) { item in
                CarouselCard(item: item)
            }

            // With auto-scroll
            DSCarousel(
                items: items,
                autoScroll: true,
                interval: 3
            ) { item in
                CarouselCard(item: item)
            }

            // Card carousel
            DSCardCarousel(items: items) { item in
                CardView(item: item)
            }
            """

        case "Pagination":
            return """
            import DesignSystem

            DSPagination(
                currentPage: $currentPage,
                totalPages: totalPages
            )
            """

        // Utilities
        case "Animation":
            return """
            import DesignSystem

            // Animation preset
            .animation(.dsSpring)

            // Bounce animation
            .animation(.dsBounce)

            // Custom keyframe
            .keyframeAnimation(
                .scale(from: 1, to: 1.2)
            )
            """

        case "Gesture":
            return """
            import GestureUtilities

            // Swipe gesture
            .onSwipe(.left) {
                goNext()
            }

            // Long press with haptic
            .onLongPress {
                showContextMenu()
            }
            .withHapticFeedback(.medium)
            """

        case "Accessibility":
            return """
            import DesignSystem

            Button("Submit") {}
                .accessibilityLabel("Submit form")
                .accessibilityHint("Double tap to submit")

            // Reduced motion
            .animation(
                reduceMotion ? nil : .default
            )
            """

        default:
            return """
            import DesignSystem

            // Usage example coming soon
            """
        }
    }
}
