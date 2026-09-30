//
//  SaborComponents.swift
//  SaborApp
//
//  Reusable UI atoms built on the design system.
//

import SwiftUI

// MARK: - Remote image

/// Loads a remote dish/photo image with a warm placeholder skeleton.
struct SaborImage: View {
    let key: String?
    var contentMode: ContentMode = .fill

    var body: some View {
        GeometryReader { geo in
            Group {
                if let key, let url = SaborImages.url(key).flatMap(URL.init) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().aspectRatio(contentMode: contentMode)
                        case .failure:
                            placeholder
                        default:
                            placeholder.overlay(ProgressView().tint(SaborColor.primary))
                        }
                    }
                } else {
                    placeholder
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }

    private var placeholder: some View {
        LinearGradient(colors: [SaborColor.container, SaborColor.containerHigh],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(
                Image(systemName: "fork.knife")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(SaborColor.onSurfaceVariant.opacity(0.4))
            )
    }
}

// MARK: - Buttons

struct SaborPrimaryButton: View {
    let title: String
    var icon: String? = "arrow.right"
    var iconLeading: String? = nil
    var enabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SaborSpacing.sm) {
                if let iconLeading { Image(systemName: iconLeading) }
                Text(title).font(SaborFont.labelLg)
                if let icon { Image(systemName: icon) }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(SaborColor.onPrimary)
            .background(enabled ? SaborColor.primaryContainer : SaborColor.sandStrong)
            .clipShape(Capsule())
        }
        .disabled(!enabled)
    }
}

struct SaborSecondaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SaborSpacing.sm) {
                if let icon { Image(systemName: icon) }
                Text(title).font(SaborFont.labelLg)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(SaborColor.secondary)
            .background(SaborColor.containerLowest)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(SaborColor.secondary, lineWidth: 1.5))
        }
    }
}

/// Small additive circular "+" trigger used on menu cards.
struct SaborAddButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(SaborColor.onPrimary)
                .frame(width: 40, height: 40)
                .background(SaborColor.primaryContainer)
                .clipShape(Circle())
        }
    }
}

// MARK: - Chips

struct SaborChip: View {
    let title: String
    var icon: String? = nil
    var selected: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            if let icon { Image(systemName: icon).font(.system(size: 13, weight: .semibold)) }
            Text(title).font(SaborFont.labelMd)
        }
        .padding(.horizontal, 14)
        .frame(height: 36)
        .foregroundStyle(selected ? SaborColor.onSecondary : SaborColor.onSurfaceVariant)
        .background(selected ? SaborColor.secondary : SaborColor.containerLowest)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(selected ? .clear : SaborColor.sand, lineWidth: 1))
    }
}

/// Small pill badge for dietary / promo attributes.
struct SaborTag: View {
    let title: String
    var icon: String? = nil
    var tint: Color = SaborColor.secondary

    var body: some View {
        HStack(spacing: 4) {
            if let icon { Image(systemName: icon).font(.system(size: 10, weight: .bold)) }
            Text(title).font(SaborFont.labelSm)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundStyle(tint)
        .background(tint.opacity(0.14))
        .clipShape(Capsule())
    }
}

// MARK: - Section header

struct SaborSectionHeader: View {
    let title: String
    var icon: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(SaborColor.primary)
                }
                Text(title).font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface)
            }
            Spacer()
            if let actionTitle {
                Button(action: { action?() }) {
                    Text(actionTitle).font(SaborFont.labelMd).foregroundStyle(SaborColor.primary)
                }
            }
        }
    }
}

// MARK: - Rating

struct SaborRating: View {
    let value: Double
    var reviews: Int? = nil
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill").font(.system(size: 11)).foregroundStyle(SaborColor.tertiary)
            Text(String(format: "%.1f", value)).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
            if let reviews {
                Text("(\(reviews))").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
            }
        }
    }
}

// MARK: - Stepper

struct SaborStepper: View {
    @Binding var value: Int
    var onChange: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            Button { if value > 1 { value -= 1; onChange?(value) } } label: {
                Image(systemName: "minus").font(.system(size: 14, weight: .bold))
                    .frame(width: 30, height: 30)
            }
            Text("\(value)").font(SaborFont.titleSm).monospacedDigit()
                .frame(minWidth: 18)
            Button { value += 1; onChange?(value) } label: {
                Image(systemName: "plus").font(.system(size: 14, weight: .bold))
                    .frame(width: 30, height: 30)
            }
        }
        .foregroundStyle(SaborColor.onSurface)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(SaborColor.container)
        .clipShape(Capsule())
    }
}

// MARK: - Toggle row

struct SaborToggleRow: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: SaborSpacing.md) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(SaborColor.primary)
                    .frame(width: 26)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                if let subtitle {
                    Text(subtitle).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn).labelsHidden().tint(SaborColor.primary)
        }
    }
}

// MARK: - Settings row

struct SaborNavRow: View {
    let title: String
    var subtitle: String? = nil
    var icon: String
    var trailingText: String? = nil
    var badgeText: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: SaborSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(SaborColor.primary)
                    .frame(width: 38, height: 38)
                    .background(SaborColor.primary.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                    if let subtitle {
                        Text(subtitle).font(SaborFont.bodySm)
                            .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(1)
                    }
                }
                Spacer()
                if let badgeText {
                    Text(badgeText).font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(SaborColor.secondary.opacity(0.14)).clipShape(Capsule())
                }
                if let trailingText {
                    Text(trailingText).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(SaborColor.onSurfaceVariant.opacity(0.6))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - App bar

struct SaborTopBar: View {
    var title: String? = nil
    var showLogo: Bool = true
    var showLocation: Bool = false
    var location: String = "Calle Mayor 24 • Centro"
    var showBack: Bool = false
    var showNotifications: Bool = true
    var notificationCount: Int = 2
    var trailingIcon: String? = nil
    var onBack: (() -> Void)? = nil
    var onTrailing: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: SaborSpacing.sm) {
            if showBack {
                Button { onBack?() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(SaborColor.onSurface)
                        .frame(width: 38, height: 38)
                        .background(SaborColor.container).clipShape(Circle())
                }
            } else if showLogo {
                SaborLogoMark(size: 30)
            }
            if let title { Text(title).font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface) }
            if showLocation {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill").font(.system(size: 11))
                        .foregroundStyle(SaborColor.primary)
                    Text(location).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                        .lineLimit(1)
                    Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold))
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
                .padding(.horizontal, 10).frame(height: 30)
                .background(SaborColor.container).clipShape(Capsule())
            }
            Spacer()
            if showNotifications {
                Button { onTrailing?() } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill").font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(SaborColor.onSurface)
                            .frame(width: 38, height: 38)
                            .background(SaborColor.container).clipShape(Circle())
                        if notificationCount > 0 {
                            Text("\(notificationCount)").font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white).frame(width: 16, height: 16)
                                .background(SaborColor.primary).clipShape(Circle())
                                .offset(x: 2, y: -2)
                        }
                    }
                }
            } else if let trailingIcon {
                Button { onTrailing?() } label: {
                    Image(systemName: trailingIcon).font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(SaborColor.onSurface)
                        .frame(width: 38, height: 38)
                        .background(SaborColor.container).clipShape(Circle())
                }
            }
            SaborAvatar(size: 36)
        }
    }
}

struct SaborAvatar: View {
    var size: CGFloat = 36
    var key: String = "profile"
    var body: some View {
        SaborImage(key: key)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(SaborColor.sand, lineWidth: 1))
    }
}

// MARK: - Logo

struct SaborLogoMark: View {
    var size: CGFloat = 30
    var showWordmark: Bool = true
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle().fill(SaborColor.primaryContainer).frame(width: size, height: size)
                Image(systemName: "flame.fill")
                    .font(.system(size: size * 0.5, weight: .bold))
                    .foregroundStyle(.white)
            }
            if showWordmark {
                Text("Sabor").font(.system(size: size * 0.72, weight: .bold, design: .rounded))
                    .foregroundStyle(SaborColor.onSurface)
            }
        }
    }
}

// MARK: - Text field

struct SaborTextField: View {
    let label: String
    var placeholder: String = ""
    var icon: String? = nil
    @Binding var text: String
    var isSecure: Bool = false
    var trailingIcon: String? = nil
    var trailingAction: (() -> Void)? = nil
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurfaceVariant)
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon).font(.system(size: 15))
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurface)
                } else {
                    TextField(placeholder, text: $text)
                        .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurface)
                        .keyboardType(keyboard)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                if let trailingIcon {
                    Button { trailingAction?() } label: {
                        Image(systemName: trailingIcon).font(.system(size: 15))
                            .foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                }
            }
            .padding(.horizontal, 14).frame(height: 50)
            .background(SaborColor.containerLowest)
            .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous)
                .stroke(SaborColor.sandStrong, lineWidth: 1))
        }
    }
}

// MARK: - Toast

struct SaborToast: View {
    let message: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(SaborColor.secondary)
            Text(message).font(SaborFont.labelMd).foregroundStyle(SaborColor.inverseOnSurface)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(SaborColor.inverseSurface)
        .clipShape(Capsule())
        .saborElevation(.raised)
    }
}

// MARK: - Screen scaffold

/// Standard screen container: canvas + scroll content + bottom safe padding.
struct SaborScreen<Content: View>: View {
    var topPadding: CGFloat = 0
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    content()
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, topPadding + SaborSpacing.sm)
                .padding(.bottom, 96)
            }
        }
    }
}
