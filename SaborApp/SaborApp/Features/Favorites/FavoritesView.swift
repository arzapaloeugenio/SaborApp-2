//
//  FavoritesView.swift
//  SaborApp
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""
    @State private var filter = 0
    @State private var showEmpty = false
    @State private var selected: Dish?

    private let filters = ["Todos", "Platos Principales", "Postres", "Ofertas"]

    private var dishes: [Dish] {
        var list = showEmpty ? [] : state.favoriteDishes
        if !query.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        return list
    }

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    SaborTopBar(showLocation: true, location: state.addressLabel) {}
                    header
                    searchField
                    filterChips
                    if dishes.isEmpty { emptyState } else {
                        LazyVStack(spacing: SaborSpacing.md) {
                            ForEach(dishes) { dish in
                                FavoriteCard(dish: dish) { selected = dish }
                            }
                        }
                        chefRecommendations
                    }
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 110)
            }
        }
        .sheet(item: $selected) { DishDetailView(dish: $0) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text("Mis Favoritos").font(SaborFont.headlineLg).foregroundStyle(SaborColor.onSurface)
                Text("\(state.favorites.count)").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Spacer()
                Button { state.favorites.removeAll() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "trash").font(.system(size: 11))
                        Text("Limpiar").font(SaborFont.labelSm)
                    }
                    .foregroundStyle(SaborColor.primary)
                }
            }
            Text("Tus elecciones gastronómicas predilectas").font(SaborFont.bodySm)
                .foregroundStyle(SaborColor.onSurfaceVariant)
            HStack(spacing: SaborSpacing.sm) {
                chipToggle("heart.fill", "Guardados (\(state.favorites.count))", active: !showEmpty) { showEmpty = false }
                chipToggle("heart", "Ver estado vacío", active: showEmpty) { showEmpty = true }
            }
        }
    }

    private func chipToggle(_ icon: String, _ title: String, active: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 11, weight: .semibold))
                Text(title).font(SaborFont.labelSm)
            }
            .foregroundStyle(active ? SaborColor.onSecondary : SaborColor.onSurfaceVariant)
            .padding(.horizontal, 12).frame(height: 34)
            .background(active ? SaborColor.secondary : SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(active ? .clear : SaborColor.sand, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(SaborColor.onSurfaceVariant)
            TextField("Buscar en mis favoritos...", text: $query).font(SaborFont.bodyMd)
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(SaborColor.onSurfaceVariant)
                }
            }
        }
        .padding(.horizontal, 14).frame(height: 48)
        .background(SaborColor.containerLowest, in: Capsule())
        .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SaborSpacing.sm) {
                ForEach(Array(filters.enumerated()), id: \.offset) { idx, f in
                    Button { filter = idx } label: {
                        SaborChip(title: idx == 0 ? "\(f) (\(state.favorites.count))" : f,
                                  icon: idx == 0 ? "checkmark" : (idx == 3 ? "flame.fill" : nil),
                                  selected: filter == idx)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
        .padding(.horizontal, -SaborSpacing.margin)
        .padding(.leading, SaborSpacing.margin)
    }

    private var emptyState: some View {
        VStack(spacing: SaborSpacing.md) {
            Image(systemName: "heart").font(.system(size: 40, weight: .light))
                .foregroundStyle(SaborColor.onSurfaceVariant.opacity(0.5))
            Text("Aún no tienes platos favoritos").font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
            Text("Explora nuestra carta gastronómica y pulsa en el corazón de los platos que más te gusten.")
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
            Button { state.tab = .menu; showEmpty = false } label: {
                HStack(spacing: 6) {
                    Image(systemName: "fork.knife")
                    Text("Explorar la carta completa").font(SaborFont.labelMd)
                }
                .foregroundStyle(SaborColor.onPrimary)
                .padding(.horizontal, 20).frame(height: 46)
                .background(SaborColor.primary, in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(SaborSpacing.xl)
        .saborCard()
    }

    private var chefRecommendations: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack(spacing: 8) {
                Image(systemName: "crown.fill").foregroundStyle(SaborColor.tertiary)
                Text("Recomendados por el Chef").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text("Populares hoy").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SaborSpacing.md) {
                    ForEach(state.dishes.filter { ["Ramen Tonkotsu", "Gyozas de Ibérico", "Bowl Burrata & Higos"].contains($0.name) }) { dish in
                        VStack(alignment: .leading, spacing: 6) {
                            ZStack(alignment: .topTrailing) {
                                SaborImage(key: dish.imageKey).frame(width: 140, height: 100).clipped()
                                Button { state.toggleFavorite(dish) } label: {
                                    Image(systemName: state.isFavorite(dish) ? "heart.fill" : "heart")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(state.isFavorite(dish) ? SaborColor.primary : SaborColor.onSurface)
                                        .frame(width: 28, height: 28).background(.ultraThinMaterial, in: Circle())
                                        .padding(6)
                                }
                            }
                            Text(dish.name).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface).lineLimit(1)
                            Text(dish.priceText).font(SaborFont.labelMd).foregroundStyle(SaborColor.primary)
                        }
                        .frame(width: 140)
                        .saborCard()
                    }
                }
                .padding(.vertical, 2)
            }
            .padding(.horizontal, -SaborSpacing.margin)
            .padding(.leading, SaborSpacing.margin)
        }
    }
}

struct FavoriteCard: View {
    @EnvironmentObject var state: AppState
    let dish: Dish
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                ZStack(alignment: .topTrailing) {
                    SaborImage(key: dish.imageKey).frame(height: 160).clipped()
                    VStack {
                        HStack {
                            if let badge = dish.badge { SaborTag(title: badge, icon: "flame.fill", tint: .white) }
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(10)
                    Button { state.toggleFavorite(dish) } label: {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(SaborColor.primary)
                            .frame(width: 32, height: 32)
                            .background(.ultraThinMaterial, in: Circle())
                            .padding(10)
                    }
                }
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let tag = dish.tags.first { SaborTag(title: tag) }
                    Spacer()
                    SaborRating(value: dish.rating, reviews: dish.reviews)
                }
                Text(dish.name).font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                HStack(alignment: .bottom) {
                    Text(dish.priceText).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
                    if let old = dish.oldPriceText {
                        Text(old).font(SaborFont.bodySm).strikethrough().foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                    Spacer()
                    Text(dish.prepTime).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Text(dish.description).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(2)
                Button { state.addToCart(dish) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus").font(.system(size: 11, weight: .bold))
                        Text("Agregar al carrito").font(SaborFont.labelMd)
                    }
                    .foregroundStyle(SaborColor.onPrimary)
                    .frame(maxWidth: .infinity).frame(height: 40)
                    .background(SaborColor.primary, in: Capsule())
                }
            }
            .padding(SaborSpacing.md)
        }
        .saborCard()
    }
}
