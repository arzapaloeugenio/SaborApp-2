//
//  SaborTheme.swift
//  SaborApp
//
//  Design system for "Sabor" — a warm, food-first hospitality aesthetic.
//  Light  : "Warm Culinary Modern"  (terracotta on sun-baked ivory)
//  Dark   : "Haute Gastronomie Dark" (charcoal tasting-room with ember accents)
//

import SwiftUI

// MARK: - Dynamic color helper

func dynamicColor(light: String, dark: String) -> Color {
    Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
    })
}

extension UIColor {
    convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") { hex.removeFirst() }
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        let r = CGFloat((value >> 16) & 0xFF) / 255
        let g = CGFloat((value >> 8) & 0xFF) / 255
        let b = CGFloat(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

// MARK: - Palette

enum SaborColor {
    // Surfaces
    static let background        = dynamicColor(light: "#FCF9F4", dark: "#121110")
    static let surface           = dynamicColor(light: "#FCF9F4", dark: "#121110")
    static let surfaceDim        = dynamicColor(light: "#DCDAD5", dark: "#151311")
    static let containerLowest   = dynamicColor(light: "#FFFFFF", dark: "#100E0C")
    static let containerLow      = dynamicColor(light: "#F6F3EE", dark: "#181614")
    static let container         = dynamicColor(light: "#F0EDE9", dark: "#201D1B")
    static let containerHigh     = dynamicColor(light: "#EBE8E3", dark: "#262320")
    static let containerHighest  = dynamicColor(light: "#E5E2DD", dark: "#2E2A27")

    // Content
    static let onSurface         = dynamicColor(light: "#1C1C19", dark: "#F5F2EB")
    static let onSurfaceVariant  = dynamicColor(light: "#58413C", dark: "#BBB5A8")
    static let inverseSurface    = dynamicColor(light: "#31302D", dark: "#E7E1DE")
    static let inverseOnSurface  = dynamicColor(light: "#F3F0EB", dark: "#32302E")

    // Accents
    static let primary           = dynamicColor(light: "#A6331B", dark: "#E05A3D")
    static let onPrimary         = dynamicColor(light: "#FFFFFF", dark: "#FFFFFF")
    static let primaryContainer  = dynamicColor(light: "#C84B31", dark: "#D95338")
    static let secondary         = dynamicColor(light: "#466557", dark: "#9DD2BA")
    static let onSecondary       = dynamicColor(light: "#FFFFFF", dark: "#003828")
    static let secondaryContainer = dynamicColor(light: "#C5E7D6", dark: "#1F5240")
    static let onSecondaryContainer = dynamicColor(light: "#4A695B", dark: "#8FC3AD")
    static let tertiary          = dynamicColor(light: "#7C5400", dark: "#FFB4A4")
    static let tertiaryFixed     = dynamicColor(light: "#FFDEAE", dark: "#FFDAD3")

    // Lines
    static let outline           = dynamicColor(light: "#8C716B", dark: "#8E887E")
    static let outlineVariant    = dynamicColor(light: "#E0BFB9", dark: "#38332E")
    static let sand              = dynamicColor(light: "#E8E2D8", dark: "#38332E")
    static let sandStrong        = dynamicColor(light: "#D8CFC4", dark: "#4A443E")

    // Status
    static let error             = dynamicColor(light: "#BA1A1A", dark: "#FFB4AB")
}

// MARK: - Radius

enum SaborRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Spacing

enum SaborSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let margin: CGFloat = 16
    static let gutter: CGFloat = 16
}

// MARK: - Typography

enum SaborFont {
    private static func r(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    static let displayLg   = r(34, .bold)
    static let headlineLg  = r(28, .bold)
    static let headlineMd  = r(24, .semibold)
    static let headlineSm  = r(20, .semibold)
    static let titleLg     = r(18, .semibold)
    static let titleMd     = r(16, .semibold)
    static let titleSm     = r(14, .semibold)
    static let bodyLg      = r(16, .regular)
    static let bodyMd      = r(14, .regular)
    static let bodySm      = r(12, .regular)
    static let labelLg     = r(14, .semibold)
    static let labelMd     = r(12, .semibold)
    static let labelSm     = r(11, .bold)
}

// MARK: - Elevation

struct SaborShadow: ViewModifier {
    enum Level { case resting, raised, floating, sheet }
    let level: Level
    func body(content: Content) -> some View {
        switch level {
        case .resting:  content.shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        case .raised:   content.shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 6)
        case .floating: content.shadow(color: .black.opacity(0.10), radius: 14, x: 0, y: -4)
        case .sheet:    content.shadow(color: .black.opacity(0.16), radius: 22, x: 0, y: 10)
        }
    }
}

extension View {
    func saborElevation(_ level: SaborShadow.Level = .resting) -> some View {
        modifier(SaborShadow(level: level))
    }
    func saborCard(radius: CGFloat = SaborRadius.lg) -> some View {
        self.background(SaborColor.containerLowest)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(SaborColor.sand, lineWidth: 1))
            .saborElevation(.resting)
    }
}

// MARK: - Canvas

struct SaborCanvas: View {
    var body: some View {
        ZStack {
            SaborColor.background.ignoresSafeArea()
            RadialGradient(colors: [SaborColor.primary.opacity(0.05), .clear],
                           center: .topLeading, startRadius: 8, endRadius: 420)
                .ignoresSafeArea()
        }
    }
}
