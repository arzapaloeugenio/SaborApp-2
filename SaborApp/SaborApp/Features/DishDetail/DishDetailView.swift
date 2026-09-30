//
//  DishDetailView.swift
//  SaborApp
//

import SwiftUI

struct DishDetailView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    let dish: Dish

    @State private var quantity = 1
    @State private var showNutrition = false
    @State private var groups: [OptionGroup] = []
    @State private var single: [UUID: UUID] = [:]   // group → selected item
    @State private var multi: Set<UUID> = []        // selected extra items

    var body: some View {
        ZStack(alignment: .bottom) {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    hero
                    titleBlock
                    ingredientChips
                    nutritionDisclosure
                    customization
                }
                .padding(.bottom, 120)
            }
            bottomBar
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            groups = MockData.optionGroups(for: dish)
            for g in groups where !g.multiSelect {
                if let def = g.items.first(where: { $0.isDefault }) ?? g.items.first {
                    single[g.id] = def.id
                }
            }
        }
    }

    private var hero: some View {
        ZStack(alignment: .top) {
            SaborImage(key: dish.imageKey).frame(height: 320).clipped()
            LinearGradient(colors: [.black.opacity(0.25), .clear], startPoint: .top, endPoint: .center)
                .frame(height: 320)
            HStack {
                circleButton("arrow.left") { dismiss() }
                Spacer()
                circleButton(state.isFavorite(dish) ? "heart.fill" : "heart") { state.toggleFavorite(dish) }
            }
            .padding(.horizontal, SaborSpacing.margin)
            .padding(.top, 56)
        }
    }

    private func circleButton(_ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon).font(.system(size: 15, weight: .semibold))
                .foregroundStyle(SaborColor.onSurface)
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            SaborTag(title: dish.badge ?? "Plato de Autor", icon: "flame.fill", tint: SaborColor.primary)
            HStack(alignment: .top) {
                Text(dish.name).font(SaborFont.headlineLg).foregroundStyle(SaborColor.onSurface)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text(dish.priceText).font(SaborFont.headlineMd).foregroundStyle(SaborColor.primary)
            }
            HStack(spacing: SaborSpacing.md) {
                SaborRating(value: dish.rating, reviews: dish.reviews)
                metaPill("clock", dish.prepTime)
                metaPill("flame.fill", "\(dish.calories) kcal")
            }
            Text(dish.description).font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, SaborSpacing.margin)
    }

    private func metaPill(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .semibold))
            Text(text).font(SaborFont.labelMd)
        }
        .foregroundStyle(SaborColor.onSurfaceVariant)
        .padding(.horizontal, 10).frame(height: 28)
        .background(SaborColor.container, in: Capsule())
    }

    private var ingredientChips: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            Text("Ingredientes seleccionados").font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface)
            FlowChips(items: MockData.ingredients)
        }
        .padding(.horizontal, SaborSpacing.margin)
    }

    private var nutritionDisclosure: some View {
        VStack(spacing: 0) {
            Button { withAnimation { showNutrition.toggle() } } label: {
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill").foregroundStyle(SaborColor.primary)
                    Text("Información nutricional y Alérgenos").font(SaborFont.titleSm)
                        .foregroundStyle(SaborColor.onSurface)
                    Spacer()
                    Image(systemName: showNutrition ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .bold)).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                .padding(SaborSpacing.md)
            }
            if showNutrition {
                VStack(alignment: .leading, spacing: SaborSpacing.md) {
                    HStack(spacing: 8) {
                        Text("Alérgenos:").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurfaceVariant)
                        SaborTag(title: "Lácteos", tint: SaborColor.tertiary)
                        SaborTag(title: "Gluten", tint: SaborColor.tertiary)
                    }
                    HStack(spacing: SaborSpacing.md) {
                        nutrition("Proteínas", "42g")
                        nutrition("Grasas", "36g")
                        nutrition("Carbohidratos", "48g")
                    }
                }
                .padding([.horizontal, .bottom], SaborSpacing.md)
            }
        }
        .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))
        .padding(.horizontal, SaborSpacing.margin)
    }

    private func nutrition(_ t: String, _ v: String) -> some View {
        VStack(spacing: 2) {
            Text(v).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
            Text(t).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(SaborColor.container, in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
    }

    private var customization: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack(alignment: .firstTextBaseline) {
                Text("Personaliza tu plato").font(SaborFont.headlineSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                SaborTag(title: "A TU GUSTO", tint: SaborColor.secondary)
            }
            ForEach(groups) { group in optionGroup(group) }
        }
        .padding(.horizontal, SaborSpacing.margin)
    }

    private func optionGroup(_ group: OptionGroup) -> some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            HStack {
                Text(group.title).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text(group.required ? "Obligatorio" : "Opcional").font(SaborFont.labelSm)
                    .foregroundStyle(group.required ? SaborColor.primary : SaborColor.onSurfaceVariant)
            }
            VStack(spacing: 8) {
                ForEach(group.items) { item in optionRow(group: group, item: item) }
            }
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))
    }

    private func optionRow(group: OptionGroup, item: OptionItem) -> some View {
        let isSelected = group.multiSelect ? multi.contains(item.id) : single[group.id] == item.id
        return Button {
            if group.multiSelect {
                if multi.contains(item.id) { multi.remove(item.id) } else { multi.insert(item.id) }
            } else {
                single[group.id] = item.id
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? (group.multiSelect ? "checkmark.square.fill" : "largecircle.fill.circle")
                                             : (group.multiSelect ? "square" : "circle"))
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? SaborColor.primary : SaborColor.sandStrong)
                Text(item.name).font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurface)
                Spacer()
                if let note = item.note {
                    Text(note).font(SaborFont.labelSm)
                        .foregroundStyle(item.extra > 0 ? SaborColor.onSurfaceVariant : SaborColor.secondary)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 12)
            .background(isSelected ? SaborColor.primary.opacity(0.06) : SaborColor.containerLow,
                        in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var unitPrice: Double {
        var extra = 0.0
        for g in groups where !g.multiSelect {
            if let id = single[g.id], let it = g.items.first(where: { $0.id == id }) { extra += it.extra }
        }
        for g in groups where g.multiSelect {
            for it in g.items where multi.contains(it.id) { extra += it.extra }
        }
        return dish.price + extra
    }

    private var bottomBar: some View {
        HStack(spacing: SaborSpacing.md) {
            SaborStepper(value: $quantity)
            Button {
                let opts = selectedOptionNames()
                state.addToCart(dish, quantity: quantity, options: opts, unitPrice: unitPrice)
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bag.fill")
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Agregar al pedido").font(SaborFont.labelMd)
                        Text(Dish.price(unitPrice * Double(quantity))).font(SaborFont.labelSm).opacity(0.9)
                    }
                }
                .foregroundStyle(SaborColor.onPrimary)
                .frame(maxWidth: .infinity).frame(height: 54)
                .background(SaborColor.primary, in: Capsule())
            }
        }
        .padding(SaborSpacing.md)
        .background(.ultraThinMaterial)
        .overlay(Rectangle().fill(SaborColor.sand).frame(height: 1), alignment: .top)
    }

    private func selectedOptionNames() -> [String] {
        var names: [String] = []
        for g in groups where !g.multiSelect {
            if let id = single[g.id], let it = g.items.first(where: { $0.id == id }) { names.append(it.name) }
        }
        for g in groups where g.multiSelect {
            for it in g.items where multi.contains(it.id) { names.append(it.name) }
        }
        return names
    }
}

// MARK: - Flow chips (wrapping ingredient layout)

struct FlowChips: View {
    let items: [(String, String)]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), alignment: .leading),
                            GridItem(.flexible(), alignment: .leading)],
                  spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(spacing: 6) {
                    Image(systemName: item.0).font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(SaborColor.primary)
                    Text(item.1).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurface)
                }
                .padding(.horizontal, 10).padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))
            }
        }
    }
}
