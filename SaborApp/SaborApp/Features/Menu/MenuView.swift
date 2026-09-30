//
//  MenuView.swift
//  SaborApp
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var state: AppState
    @State private var showFilters = false
    @State private var sortBy = "Popularidad"

    var body: some View {
        ZStack(alignment: .bottom) {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.md) {
                    SaborTopBar(showLocation: true, location: state.addressLabel) {}
                    searchField
                    controlRow
                    categoryChips
                    dietFilters
                    headerBlock
                    LazyVStack(spacing: SaborSpacing.md) {
                        ForEach(state.filteredDishes) { dish in
                            DishCardWide(dish: dish) { selected = dish }
                        }
                    }
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 170)
            }
            if state.cartCount > 0 { stickyCartBar }
        }
        .sheet(item: $selected) { dish in DishDetailView(dish: dish) }
        .sheet(isPresented: $showFilters) { FiltersSheet() }
        .sheet(isPresented: $showCart) { CartView() }
    }

    @State private var selected: Dish?
    @State private var showCart = false

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(SaborColor.onSurfaceVariant)
            TextField("Buscar por plato o ingrediente...", text: $state.searchText)
                .font(SaborFont.bodyMd)
            Image(systemName: "mic.fill").foregroundStyle(SaborColor.primary)
        }
        .padding(.horizontal, 14).frame(height: 50)
        .background(SaborColor.containerLowest, in: Capsule())
        .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
    }

    private var controlRow: some View {
        HStack(spacing: SaborSpacing.sm) {
            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down").font(.system(size: 12, weight: .semibold))
                    Text("Ordenar:").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                    Text(sortBy).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                    Image(systemName: "chevron.down").font(.system(size: 10, weight: .bold))
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
                .padding(.horizontal, 14).frame(height: 40)
                .background(SaborColor.containerLowest, in: Capsule())
                .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
            }
            Spacer()
            Button { showFilters = true } label: {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3").font(.system(size: 12, weight: .semibold))
                    Text("Filtrar").font(SaborFont.labelMd)
                    Text("2").font(.system(size: 10, weight: .bold)).foregroundStyle(.white)
                        .frame(width: 18, height: 18).background(SaborColor.primary, in: Circle())
                }
                .padding(.horizontal, 14).frame(height: 40)
                .foregroundStyle(SaborColor.primary)
                .background(SaborColor.primary.opacity(0.10), in: Capsule())
            }
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SaborSpacing.sm) {
                ForEach(MockData.categories, id: \.self) { cat in
                    Button { state.selectedCategory = cat } label: {
                        SaborChip(title: cat, selected: state.selectedCategory == cat)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
        .padding(.horizontal, -SaborSpacing.margin)
        .padding(.leading, SaborSpacing.margin)
    }

    private var dietFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SaborSpacing.sm) {
                filterPill("🌿  Vegano", selected: false)
                filterPill("🌾  Sin Gluten", selected: true)
                filterPill("⭐  Más de 4.8", selected: true)
                filterPill("⚡️  Menos de 30 min", selected: false)
            }
            .padding(.vertical, 2)
        }
        .padding(.horizontal, -SaborSpacing.margin)
        .padding(.leading, SaborSpacing.margin)
    }

    private func filterPill(_ text: String, selected: Bool) -> some View {
        Text(text).font(SaborFont.labelSm)
            .padding(.horizontal, 12).frame(height: 32)
            .foregroundStyle(selected ? SaborColor.onSecondary : SaborColor.onSurfaceVariant)
            .background(selected ? SaborColor.secondary : SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(selected ? .clear : SaborColor.sand, lineWidth: 1))
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("Menú de Temporada").font(SaborFont.headlineSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(SaborColor.secondary).frame(width: 7, height: 7)
                    Text("Cocina activa").font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
                }
            }
            Text("\(state.filteredDishes.count) platos artesanos disponibles hoy")
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .padding(.top, 4)
    }

    private var stickyCartBar: some View {
        HStack(spacing: SaborSpacing.md) {
            ZStack {
                Image(systemName: "bag.fill").font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(SaborColor.onPrimary)
                Text("\(state.cartCount)").font(.system(size: 9, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 16, height: 16).background(SaborColor.primary, in: Circle())
                    .offset(x: 12, y: -12)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Mi Selección").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text(Dish.price(state.subtotal)).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
            }
            Spacer()
            Button { showCart = true } label: {
                HStack(spacing: 6) {
                    Text("Ver Cesta").font(SaborFont.labelMd)
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(SaborColor.onPrimary)
                .padding(.horizontal, 20).frame(height: 46)
                .background(SaborColor.primary, in: Capsule())
            }
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.containerLowest)
        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous)
            .stroke(SaborColor.sand, lineWidth: 1))
        .saborElevation(.floating)
        .padding(.horizontal, SaborSpacing.margin)
        .padding(.bottom, 84)
    }
}

// MARK: - Wide dish card

struct DishCardWide: View {
    @EnvironmentObject var state: AppState
    let dish: Dish
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                ZStack(alignment: .topTrailing) {
                    SaborImage(key: dish.imageKey).frame(height: 168).clipped()
                    HStack(spacing: 6) {
                        if let badge = dish.badge {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill").font(.system(size: 9, weight: .bold))
                                Text(badge.uppercased()).font(SaborFont.labelSm)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(SaborColor.primary, in: Capsule())
                        }
                        Spacer()
                        Button { state.toggleFavorite(dish) } label: {
                            Image(systemName: state.isFavorite(dish) ? "heart.fill" : "heart")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(state.isFavorite(dish) ? SaborColor.primary : SaborColor.onSurface)
                                .frame(width: 32, height: 32).background(.ultraThinMaterial, in: Circle())
                        }
                    }
                    .padding(10)
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(dish.name).font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                    Spacer()
                    SaborRating(value: dish.rating, reviews: dish.reviews)
                }
                Text(dish.description).font(SaborFont.bodySm)
                    .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(2)
                HStack(spacing: 6) {
                    ForEach(dish.tags.prefix(3), id: \.self) { tag in
                        SaborTag(title: tag, icon: tagIcon(tag))
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("PRECIO").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                        HStack(spacing: 6) {
                            Text(dish.priceText).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
                            if let old = dish.oldPriceText {
                                Text(old).font(SaborFont.bodySm).strikethrough()
                                    .foregroundStyle(SaborColor.onSurfaceVariant)
                            }
                        }
                    }
                    Spacer()
                    Button { state.addToCart(dish) } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                            Text("Añadir").font(SaborFont.labelMd)
                        }
                        .foregroundStyle(SaborColor.onPrimary)
                        .padding(.horizontal, 16).frame(height: 38)
                        .background(SaborColor.primary, in: Capsule())
                    }
                }
            }
            .padding(SaborSpacing.md)
        }
        .saborCard()
    }

    private func tagIcon(_ tag: String) -> String? {
        switch tag {
        case "Vegano", "Vegetariano", "Orgánico": return "leaf.fill"
        case "Sin Gluten": return "circle.slash"
        case "Premio Repostería": return "trophy.fill"
        default: return nil
        }
    }
}

// MARK: - Filters sheet

struct FiltersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var priceMax = 20.0
    @State private var vegan = false
    @State private var glutenFree = true
    @State private var fast = true

    var body: some View {
        NavigationStack {
            ZStack { SaborCanvas()
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    Text("Precio máximo: \(Dish.price(priceMax))")
                        .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                    Slider(value: $priceMax, in: 5...30).tint(SaborColor.primary)
                    SaborToggleRow(title: "Vegano", icon: "leaf.fill", isOn: $vegan)
                    SaborToggleRow(title: "Sin Gluten", icon: "circle.slash", isOn: $glutenFree)
                    SaborToggleRow(title: "Entrega rápida (< 30 min)", icon: "bolt.fill", isOn: $fast)
                    Spacer()
                    SaborPrimaryButton(title: "Aplicar filtros", icon: "checkmark") { dismiss() }
                }
                .padding(SaborSpacing.margin)
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
}
