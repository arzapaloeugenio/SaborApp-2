//
//  HomeView.swift
//  SaborApp
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState
    @State private var showNotifications = false
    @State private var showCart = false

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    SaborTopBar(showLocation: true, location: state.addressLabel,
                                onTrailing: { showNotifications = true })
                    greeting
                    searchBar
                    promoBanner
                    categories
                    bestSellers
                    chefRecommendation
                    specialOffers
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 110)
            }
        }
        .sheet(isPresented: $showNotifications) { NotificationsView() }
        .sheet(isPresented: $showCart) { CartView() }
    }

    private var greeting: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("¡Hola, Valentina! 👋").font(SaborFont.headlineMd).foregroundStyle(SaborColor.onSurface)
                Text("¿Qué se te antoja degustar hoy?").font(SaborFont.bodyMd)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
            Spacer()
            Image(systemName: "flame.fill").font(.system(size: 18, weight: .bold))
                .foregroundStyle(SaborColor.primary)
                .frame(width: 38, height: 38)
                .background(SaborColor.primary.opacity(0.12), in: Circle())
        }
    }

    private var searchBar: some View {
        Button { state.tab = .menu } label: {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass").foregroundStyle(SaborColor.onSurfaceVariant)
                Text("Buscar hamburguesas, pastas, postres...")
                    .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                Spacer()
                Image(systemName: "slider.horizontal.3").foregroundStyle(SaborColor.primary)
            }
            .padding(.horizontal, 14).frame(height: 50)
            .background(SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var promoBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [SaborColor.primary, SaborColor.primaryContainer],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "sparkles").font(.system(size: 10, weight: .bold))
                    Text("EDICIÓN GOURMET").font(SaborFont.labelSm)
                }
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.white.opacity(0.22), in: Capsule())
                .foregroundStyle(.white)

                Text("Festival de Sabores de Temporada")
                    .font(SaborFont.headlineSm).foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text("25% de descuento en platos de autor usando el código ")
                    .font(SaborFont.bodySm).foregroundStyle(.white.opacity(0.92))
                + Text("SABOR25").font(SaborFont.labelMd).foregroundStyle(SaborColor.tertiaryFixed)

                Button {} label: {
                    HStack(spacing: 6) {
                        Text("Aprovechar oferta").font(SaborFont.labelMd)
                        Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold))
                    }
                    .foregroundStyle(SaborColor.primary)
                    .padding(.horizontal, 16).frame(height: 40)
                    .background(.white, in: Capsule())
                }
            }
            .padding(SaborSpacing.md)

            HStack(spacing: 6) {
                Text("🍷"); Text("🥩"); Text("🌿")
            }
            .font(.system(size: 18))
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(.white.opacity(0.18), in: Capsule())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(SaborSpacing.md)
        }
        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.xl, style: .continuous))
        .saborElevation(.raised)
    }

    private var categories: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            SaborSectionHeader(title: "Explorar Categorías", actionTitle: "Ver todo") { state.tab = .menu }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SaborSpacing.sm) {
                    ForEach(Array(MockData.categories.enumerated()), id: \.offset) { idx, cat in
                        Button { state.selectedCategory = cat; state.tab = .menu } label: {
                            SaborChip(title: cat,
                                      icon: sfCategory(MockData.categoryIcons[idx]),
                                      selected: state.selectedCategory == cat)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
            .padding(.horizontal, -SaborSpacing.margin)
            .padding(.leading, SaborSpacing.margin)
        }
    }

    private func sfCategory(_ n: String) -> String {
        switch n {
        case "dinner_dining": return "fork.knife"
        case "lunch_dining": return "takeoutbag.and.cup.and.straw.fill"
        case "ramen_dining": return "bowl.fill"
        case "local_pizza": return "triangle.fill"
        case "nutrition": return "leaf.fill"
        case "cake": return "birthday.cake.fill"
        default: return "wineglass.fill"
        }
    }

    private var bestSellers: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            SaborSectionHeader(title: "Más Vendidos", icon: "flame.fill", actionTitle: "Ver carta") {
                state.tab = .menu
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SaborSpacing.md) {
                    ForEach(state.dishes.filter { $0.badge == "Top Ventas" || $0.rating >= 4.9 }.prefix(4)) { dish in
                        DishCardCompact(dish: dish)
                    }
                }
                .padding(.horizontal, 2)
            }
            .padding(.horizontal, -SaborSpacing.margin)
            .padding(.leading, SaborSpacing.margin)
        }
    }

    private var chefRecommendation: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            SaborSectionHeader(title: "Recomendado para ti", icon: "hand.thumbsup.fill")
            if let dish = state.dishes.first(where: { $0.badge == "Recomendado del Chef" }) {
                HStack(spacing: SaborSpacing.md) {
                    SaborImage(key: dish.imageKey)
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
                        .overlay(alignment: .bottomLeading) {
                            Text("Chef").font(SaborFont.labelSm).foregroundStyle(.white)
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .background(SaborColor.primary.opacity(0.9), in: Capsule())
                                .padding(6)
                        }
                    VStack(alignment: .leading, spacing: 6) {
                        SaborTag(title: "Recomendado del Chef", icon: "checkmark.seal.fill")
                        Text(dish.name).font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                        Text(dish.description).font(SaborFont.bodySm)
                            .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(2)
                        HStack {
                            Text(dish.priceText).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
                            SaborRating(value: dish.rating)
                            Spacer()
                            Button { state.addToCart(dish); state.seedCartIfEmpty(); state.tab = .orders } label: {
                                Text("Pedir").font(SaborFont.labelMd).foregroundStyle(SaborColor.onPrimary)
                                    .padding(.horizontal, 14).frame(height: 32)
                                    .background(SaborColor.primary, in: Capsule())
                            }
                        }
                    }
                }
                .padding(SaborSpacing.md)
                .saborCard()
            }
        }
    }

    private var specialOffers: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            SaborSectionHeader(title: "Ofertas Especiales", icon: "tag.fill", actionTitle: "Ver 4 ofertas") {
                state.tab = .menu
            }
            if let dish = state.dishes.first(where: { $0.oldPrice != nil }) {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        SaborImage(key: dish.imageKey).frame(height: 150).clipped()
                        HStack(spacing: 4) {
                            Image(systemName: "percent").font(.system(size: 10, weight: .bold))
                            Text(dish.badge ?? "-20% HOY").font(SaborFont.labelSm)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(SaborColor.primary, in: Capsule())
                        .padding(10)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Horno de leña").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                        Text(dish.name).font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                        HStack(spacing: 8) {
                            Text(dish.priceText).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
                            if let old = dish.oldPriceText {
                                Text(old).font(SaborFont.bodySm).strikethrough()
                                    .foregroundStyle(SaborColor.onSurfaceVariant)
                            }
                        }
                        Text(dish.description).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                        HStack {
                            Button { state.addToCart(dish); state.seedCartIfEmpty() } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "cart.badge.plus")
                                    Text("Añadir").font(SaborFont.labelMd)
                                }
                                .foregroundStyle(SaborColor.onPrimary)
                                .padding(.horizontal, 16).frame(height: 40)
                                .background(SaborColor.primary, in: Capsule())
                            }
                            Spacer()
                        }
                    }
                    .padding(SaborSpacing.md)
                }
                .saborCard()
            }
        }
    }
}

// MARK: - Compact dish card

struct DishCardCompact: View {
    @EnvironmentObject var state: AppState
    let dish: Dish

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                SaborImage(key: dish.imageKey).frame(width: 210, height: 130).clipped()
                Button { state.toggleFavorite(dish) } label: {
                    Image(systemName: state.isFavorite(dish) ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(state.isFavorite(dish) ? SaborColor.primary : SaborColor.onSurface)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial, in: Circle())
                        .padding(8)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                SaborRating(value: dish.rating, reviews: dish.reviews)
                Text(dish.name).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface).lineLimit(2)
                Text(dish.description).font(SaborFont.bodySm)
                    .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(2)
                    .frame(height: 34, alignment: .top)
                Spacer(minLength: 0)
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("PRECIO").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                        Text(dish.priceText).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
                    }
                    Spacer()
                    SaborAddButton { state.addToCart(dish) }
                }
            }
            .padding(SaborSpacing.md)
        }
        .frame(width: 210)
        .saborCard()
    }
}
