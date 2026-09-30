//
//  RootView.swift
//  SaborApp
//
//  Top-level router: onboarding → auth → main tab shell.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        Group {
            if state.showOnboarding {
                OnboardingView()
            } else if !state.isAuthenticated {
                SignInView()
            } else {
                MainTabView()
            }
        }
        .overlay(alignment: .bottom) {
            if let toast = state.toast {
                SaborToast(message: toast)
                    .padding(.bottom, 96)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: state.toast)
        .onChange(of: state.toast) { _, new in
            guard new != nil else { return }
            Task {
                try? await Task.sleep(nanoseconds: 1_800_000_000)
                await MainActor.run { state.toast = nil }
            }
        }
    }
}

// MARK: - Main tab shell

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch state.tab {
                case .home:      HomeView()
                case .menu:      MenuView()
                case .favorites: FavoritesView()
                case .orders:    OrdersView()
                case .profile:   ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            SaborTabBar(selection: $state.tab, cartBadge: state.cartCount > 0 ? state.cartCount : 0)
        }
        .background(SaborCanvas())
    }
}

// MARK: - Bottom navigation

struct SaborTabBar: View {
    @Binding var selection: AppState.Tab
    let cartBadge: Int

    var body: some View {
        HStack {
            ForEach(AppState.Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selection = tab }
                } label: {
                    VStack(spacing: 4) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: tab.icon(selected: selection == tab))
                                .font(.system(size: 20, weight: selection == tab ? .semibold : .regular))
                            if tab == .orders && cartBadge > 0 {
                                Text("\(cartBadge)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 15, height: 15)
                                    .background(SaborColor.primary)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -6)
                            }
                        }
                        Text(tab.title).font(SaborFont.labelSm)
                    }
                    .foregroundStyle(selection == tab ? SaborColor.primary : SaborColor.onSurfaceVariant)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 4)
        .padding(.horizontal, 8)
        .background(
            SaborColor.containerLowest
                .overlay(Rectangle().fill(SaborColor.sand).frame(height: 1), alignment: .top)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Tab metadata

extension AppState.Tab {
    var title: String {
        switch self {
        case .home: return "Inicio"
        case .menu: return "Menú"
        case .favorites: return "Favoritos"
        case .orders: return "Pedidos"
        case .profile: return "Perfil"
        }
    }
    func icon(selected: Bool) -> String {
        switch self {
        case .home: return selected ? "house.fill" : "house"
        case .menu: return selected ? "fork.knife.circle.fill" : "fork.knife.circle"
        case .favorites: return selected ? "heart.fill" : "heart"
        case .orders: return selected ? "list.bullet.rectangle.fill" : "list.bullet.rectangle"
        case .profile: return selected ? "person.crop.circle.fill" : "person.crop.circle"
        }
    }
}
