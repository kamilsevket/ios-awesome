import SwiftUI

// MARK: - SFSymbol

/// Type-safe wrapper for SF Symbols providing compile-time safety and autocomplete.
///
/// ## Usage
/// ```swift
/// // SwiftUI Image
/// Image(sfSymbol: .chevronRight)
///
/// // Icon view with customization
/// Icon.system(.heart)
///     .foregroundStyle(.red)
///
/// // UIKit
/// UIImage(sfSymbol: .star)
/// ```
public enum SFSymbol: String, CaseIterable, Sendable {

    // MARK: - Navigation

    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronLeftCircle = "chevron.left.circle"
    case chevronRightCircle = "chevron.right.circle"
    case chevronLeftCircleFill = "chevron.left.circle.fill"
    case chevronRightCircleFill = "chevron.right.circle.fill"
    case arrowLeft = "arrow.left"
    case arrowRight = "arrow.right"
    case arrowUp = "arrow.up"
    case arrowDown = "arrow.down"
    case arrowUturnLeft = "arrow.uturn.left"
    case arrowUturnRight = "arrow.uturn.right"
    case arrowClockwise = "arrow.clockwise"
    case arrowCounterclockwise = "arrow.counterclockwise"

    // MARK: - Actions

    case plus = "plus"
    case plusCircle = "plus.circle"
    case plusCircleFill = "plus.circle.fill"
    case minus = "minus"
    case minusCircle = "minus.circle"
    case minusCircleFill = "minus.circle.fill"
    case xmark = "xmark"
    case xmarkCircle = "xmark.circle"
    case xmarkCircleFill = "xmark.circle.fill"
    case checkmark = "checkmark"
    case checkmarkCircle = "checkmark.circle"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case trash = "trash"
    case trashFill = "trash.fill"
    case pencil = "pencil"
    case pencilCircle = "pencil.circle"
    case square = "square"
    case squareFill = "square.fill"
    case squareAndPencil = "square.and.pencil"
    case docOnDoc = "doc.on.doc"
    case docOnDocFill = "doc.on.doc.fill"

    // MARK: - Communication

    case envelope = "envelope"
    case envelopeFill = "envelope.fill"
    case envelopeBadge = "envelope.badge"
    case envelopeBadgeFill = "envelope.badge.fill"
    case phone = "phone"
    case phoneFill = "phone.fill"
    case message = "message"
    case messageFill = "message.fill"
    case bubble = "bubble.left"
    case bubbleFill = "bubble.left.fill"
    case ellipsisMessage = "ellipsis.message"
    case ellipsisMessageFill = "ellipsis.message.fill"

    // MARK: - Media

    case play = "play"
    case playFill = "play.fill"
    case playCircle = "play.circle"
    case playCircleFill = "play.circle.fill"
    case pause = "pause"
    case pauseFill = "pause.fill"
    case pauseCircle = "pause.circle"
    case pauseCircleFill = "pause.circle.fill"
    case stop = "stop"
    case stopFill = "stop.fill"
    case backward = "backward"
    case backwardFill = "backward.fill"
    case forward = "forward"
    case forwardFill = "forward.fill"
    case speakerWave2 = "speaker.wave.2"
    case speakerWave2Fill = "speaker.wave.2.fill"
    case speakerSlash = "speaker.slash"
    case speakerSlashFill = "speaker.slash.fill"
    case mic = "mic"
    case micFill = "mic.fill"
    case micSlash = "mic.slash"
    case micSlashFill = "mic.slash.fill"

    // MARK: - Objects

    case heart = "heart"
    case heartFill = "heart.fill"
    case star = "star"
    case starFill = "star.fill"
    case starLeadinghalfFilled = "star.leadinghalf.filled"
    case bookmark = "bookmark"
    case bookmarkFill = "bookmark.fill"
    case flag = "flag"
    case flagFill = "flag.fill"
    case tag = "tag"
    case tagFill = "tag.fill"
    case bell = "bell"
    case bellFill = "bell.fill"
    case bellBadge = "bell.badge"
    case bellBadgeFill = "bell.badge.fill"
    case bolt = "bolt"
    case boltFill = "bolt.fill"
    case eye = "eye"
    case eyeFill = "eye.fill"
    case eyeSlash = "eye.slash"
    case eyeSlashFill = "eye.slash.fill"

    // MARK: - People

    case person = "person"
    case personFill = "person.fill"
    case personCircle = "person.circle"
    case personCircleFill = "person.circle.fill"
    case personCropCircle = "person.crop.circle"
    case personCropCircleFill = "person.crop.circle.fill"
    case person2 = "person.2"
    case person2Fill = "person.2.fill"
    case person3 = "person.3"
    case person3Fill = "person.3.fill"
    case personBadgePlus = "person.badge.plus"
    case personBadgeMinus = "person.badge.minus"

    // MARK: - Devices

    case iphone = "iphone"
    case ipad = "ipad"
    case laptopcomputer = "laptopcomputer"
    case desktopcomputer = "desktopcomputer"
    case applewatch = "applewatch"
    case airpods = "airpods"
    case keyboard = "keyboard"
    case printer = "printer"
    case camera = "camera"
    case cameraFill = "camera.fill"
    case photo = "photo"
    case photoFill = "photo.fill"
    case photoOnRectangle = "photo.on.rectangle"
    case photoOnRectangleAngled = "photo.on.rectangle.angled"

    // MARK: - Weather

    case sunMax = "sun.max"
    case sunMaxFill = "sun.max.fill"
    case moon = "moon"
    case moonFill = "moon.fill"
    case moonStars = "moon.stars"
    case moonStarsFill = "moon.stars.fill"
    case cloud = "cloud"
    case cloudFill = "cloud.fill"
    case cloudRain = "cloud.rain"
    case cloudRainFill = "cloud.rain.fill"
    case cloudSun = "cloud.sun"
    case cloudSunFill = "cloud.sun.fill"
    case cloudMoon = "cloud.moon"
    case cloudMoonFill = "cloud.moon.fill"
    case snowflake = "snowflake"
    case thermometerMedium = "thermometer.medium"

    // MARK: - Connectivity

    case wifi = "wifi"
    case wifiSlash = "wifi.slash"
    case wifiExclamationmark = "wifi.exclamationmark"
    case antenna = "antenna.radiowaves.left.and.right"
    case airplane = "airplane"
    case airplaneCircle = "airplane.circle"
    case airplaneCircleFill = "airplane.circle.fill"
    case link = "link"
    case linkCircle = "link.circle"
    case linkCircleFill = "link.circle.fill"

    // MARK: - Editing

    case scissors = "scissors"
    case paintbrush = "paintbrush"
    case paintbrushFill = "paintbrush.fill"
    case paintbrushPointed = "paintbrush.pointed"
    case paintbrushPointedFill = "paintbrush.pointed.fill"
    case crop = "crop"
    case cropRotate = "crop.rotate"
    case wand = "wand.and.stars"
    case wandAndRays = "wand.and.rays"
    case slider = "slider.horizontal.3"
    case tuningfork = "tuningfork"

    // MARK: - Files & Folders

    case folder = "folder"
    case folderFill = "folder.fill"
    case folderBadgePlus = "folder.badge.plus"
    case folderBadgeMinus = "folder.badge.minus"
    case doc = "doc"
    case docFill = "doc.fill"
    case docText = "doc.text"
    case docTextFill = "doc.text.fill"
    case docBadgePlus = "doc.badge.plus"
    case archivebox = "archivebox"
    case archiveboxFill = "archivebox.fill"
    case tray = "tray"
    case trayFill = "tray.fill"
    case trayAndArrowDown = "tray.and.arrow.down"
    case trayAndArrowUp = "tray.and.arrow.up"

    // MARK: - System

    case gear = "gear"
    case gearshape = "gearshape"
    case gearshapeFill = "gearshape.fill"
    case gearshape2 = "gearshape.2"
    case gearshape2Fill = "gearshape.2.fill"
    case slider3Horizontal = "slider.horizontal.3"
    case wrench = "wrench"
    case wrenchFill = "wrench.fill"
    case hammer = "hammer"
    case hammerFill = "hammer.fill"
    case ellipsis = "ellipsis"
    case ellipsisCircle = "ellipsis.circle"
    case ellipsisCircleFill = "ellipsis.circle.fill"
    case info = "info"
    case infoCircle = "info.circle"
    case infoCircleFill = "info.circle.fill"
    case questionmark = "questionmark"
    case questionmarkCircle = "questionmark.circle"
    case questionmarkCircleFill = "questionmark.circle.fill"
    case exclamationmark = "exclamationmark"
    case exclamationmarkTriangle = "exclamationmark.triangle"
    case exclamationmarkTriangleFill = "exclamationmark.triangle.fill"
    case exclamationmarkCircle = "exclamationmark.circle"
    case exclamationmarkCircleFill = "exclamationmark.circle.fill"

    // MARK: - Location

    case location = "location"
    case locationFill = "location.fill"
    case locationCircle = "location.circle"
    case locationCircleFill = "location.circle.fill"
    case locationSlash = "location.slash"
    case locationSlashFill = "location.slash.fill"
    case map = "map"
    case mapFill = "map.fill"
    case mappin = "mappin"
    case mappinCircle = "mappin.circle"
    case mappinCircleFill = "mappin.circle.fill"
    case mappinAndEllipse = "mappin.and.ellipse"

    // MARK: - Commerce

    case cart = "cart"
    case cartFill = "cart.fill"
    case cartBadgePlus = "cart.badge.plus"
    case cartBadgeMinus = "cart.badge.minus"
    case bag = "bag"
    case bagFill = "bag.fill"
    case bagBadgePlus = "bag.badge.plus"
    case bagBadgeMinus = "bag.badge.minus"
    case creditcard = "creditcard"
    case creditcardFill = "creditcard.fill"
    case giftcard = "giftcard"
    case giftcardFill = "giftcard.fill"
    case banknote = "banknote"
    case banknoteFill = "banknote.fill"

    // MARK: - Health & Fitness

    case heartTextSquare = "heart.text.square"
    case heartTextSquareFill = "heart.text.square.fill"
    case waveformPath = "waveform.path"
    case waveformPathEcg = "waveform.path.ecg"
    case staroflife = "staroflife"
    case staroflifeFill = "staroflife.fill"
    case cross = "cross"
    case crossFill = "cross.fill"
    case crossCircle = "cross.circle"
    case crossCircleFill = "cross.circle.fill"
    case pills = "pills"
    case pillsFill = "pills.fill"

    // MARK: - Time

    case clock = "clock"
    case clockFill = "clock.fill"
    case alarm = "alarm"
    case alarmFill = "alarm.fill"
    case stopwatch = "stopwatch"
    case stopwatchFill = "stopwatch.fill"
    case timer = "timer"
    case timerSquare = "timer.square"
    case calendar = "calendar"
    case calendarBadgePlus = "calendar.badge.plus"
    case calendarBadgeMinus = "calendar.badge.minus"
    case calendarCircle = "calendar.circle"
    case calendarCircleFill = "calendar.circle.fill"

    // MARK: - Sharing & Social

    case squareAndArrowUp = "square.and.arrow.up"
    case squareAndArrowUpFill = "square.and.arrow.up.fill"
    case squareAndArrowDown = "square.and.arrow.down"
    case squareAndArrowDownFill = "square.and.arrow.down.fill"
    case arrowUpDoc = "arrow.up.doc"
    case arrowUpDocFill = "arrow.up.doc.fill"
    case arrowDownDoc = "arrow.down.doc"
    case arrowDownDocFill = "arrow.down.doc.fill"

    // MARK: - Search & Filter

    case magnifyingglass = "magnifyingglass"
    case magnifyingglassCircle = "magnifyingglass.circle"
    case magnifyingglassCircleFill = "magnifyingglass.circle.fill"
    case lineHorizontal3DecreaseCircle = "line.3.horizontal.decrease.circle"
    case lineHorizontal3DecreaseCircleFill = "line.3.horizontal.decrease.circle.fill"
    case line3Horizontal = "line.3.horizontal"
    case listBullet = "list.bullet"
    case listDash = "list.dash"
    case listNumber = "list.number"
    case squareGrid2x2 = "square.grid.2x2"
    case squareGrid2x2Fill = "square.grid.2x2.fill"
    case squareGrid3x3 = "square.grid.3x3"
    case squareGrid3x3Fill = "square.grid.3x3.fill"

    // MARK: - Security

    case lock = "lock"
    case lockFill = "lock.fill"
    case lockCircle = "lock.circle"
    case lockCircleFill = "lock.circle.fill"
    case lockOpen = "lock.open"
    case lockOpenFill = "lock.open.fill"
    case key = "key"
    case keyFill = "key.fill"
    case shield = "shield"
    case shieldFill = "shield.fill"
    case shieldCheckered = "shield.checkered"
    case faceid = "faceid"
    case touchid = "touchid"

    // MARK: - Misc

    case house = "house"
    case houseFill = "house.fill"
    case building = "building"
    case buildingFill = "building.fill"
    case building2 = "building.2"
    case building2Fill = "building.2.fill"
    case book = "book"
    case bookFill = "book.fill"
    case bookClosed = "book.closed"
    case bookClosedFill = "book.closed.fill"
    case graduationcap = "graduationcap"
    case graduationcapFill = "graduationcap.fill"
    case lightbulb = "lightbulb"
    case lightbulbFill = "lightbulb.fill"
    case power = "power"
    case powerCircle = "power.circle"
    case powerCircleFill = "power.circle.fill"

    /// The raw SF Symbol name string
    public var systemName: String {
        rawValue
    }
}

// MARK: - Image Extension

public extension Image {
    /// Creates an Image from an SFSymbol
    /// - Parameter sfSymbol: The SF Symbol to display
    init(sfSymbol: SFSymbol) {
        self.init(systemName: sfSymbol.rawValue)
    }
}

// MARK: - Label Extension

public extension Label where Title == Text, Icon == Image {
    /// Creates a Label with an SF Symbol icon
    /// - Parameters:
    ///   - title: The text to display
    ///   - sfSymbol: The SF Symbol to use as the icon
    init(_ title: String, sfSymbol: SFSymbol) {
        self.init(title, systemImage: sfSymbol.rawValue)
    }

    /// Creates a Label with an SF Symbol icon
    /// - Parameters:
    ///   - titleKey: The localization key for the text
    ///   - sfSymbol: The SF Symbol to use as the icon
    init(_ titleKey: LocalizedStringKey, sfSymbol: SFSymbol) {
        self.init(titleKey, systemImage: sfSymbol.rawValue)
    }
}
