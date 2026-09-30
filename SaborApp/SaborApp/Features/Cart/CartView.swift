//
//  CartView.swift
//  SaborApp
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckout = false

    var body: some View {
        ZStack(alignment: .bottom) {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    SaborTopBar(title: "Carrito", showLogo: false, showBack: true,
                                showNotifications: false, trailingIcon: "square.and.arrow.up",
                                onBack: { dismiss() }, onTrailing: {})
                    deliveryCard
                    orderItems
                    drinksUpsell
                    cutleryToggle
                    coupon
                    summary
                    surchargeNote
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 120)
            }
            if !state.cart.isEmpty { payBar }
        }
        .onAppear { state.seedCartIfEmpty() }
        .sheet(isPresented: $showCheckout) { CheckoutView() }
    }

    private var deliveryCard: some View {
        HStack(spacing: SaborSpacing.md) {
            Image(systemName: "bicycle").font(.system(size: 18, weight: .semibold))
                .foregroundStyle(SaborColor.secondary)
                .frame(width: 44, height: 44)
                .background(SaborColor.secondary.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text("Entrega estimada").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text("25-35 min").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Text("Calle Mayor 24, 3ºB").font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "pencil").font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(SaborColor.primary)
                    .frame(width: 38, height: 38).background(SaborColor.primary.opacity(0.10), in: Circle())
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var orderItems: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Text("Tu pedido").font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface)
                Text("(\(state.cartCount) platos)").font(SaborFont.bodySm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
                Spacer()
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill").font(.system(size: 11))
                        Text("Añadir más").font(SaborFont.labelSm)
                    }
                    .foregroundStyle(SaborColor.primary)
                }
            }
            ForEach(state.cart) { line in
                HStack(spacing: SaborSpacing.md) {
                    SaborImage(key: line.dish.imageKey)
                        .frame(width: 68, height: 68)
                        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(line.dish.name).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                                .lineLimit(1)
                            Spacer()
                            Button { state.remove(line) } label: {
                                Image(systemName: "trash").font(.system(size: 13))
                                    .foregroundStyle(SaborColor.onSurfaceVariant)
                            }
                        }
                        if !line.options.isEmpty {
                            Text(line.options.joined(separator: " • ")).font(SaborFont.bodySm)
                                .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(1)
                        }
                        HStack {
                            Text(Dish.price(line.lineTotal)).font(SaborFont.titleSm)
                                .foregroundStyle(SaborColor.primary)
                            Spacer()
                            HStack(spacing: 10) {
                                Button { state.dec(line) } label: {
                                    Image(systemName: "minus").font(.system(size: 12, weight: .bold))
                                        .frame(width: 26, height: 26)
                                }
                                Text("\(line.quantity)").font(SaborFont.labelMd).monospacedDigit()
                                Button { state.inc(line) } label: {
                                    Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                                        .frame(width: 26, height: 26)
                                }
                            }
                            .foregroundStyle(SaborColor.onSurface)
                            .padding(.horizontal, 6).padding(.vertical, 3)
                            .background(SaborColor.container, in: Capsule())
                        }
                    }
                }
                .padding(SaborSpacing.sm)
                .background(SaborColor.containerLow, in: RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
            }
        }
    }

    private var drinksUpsell: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack(spacing: 8) {
                Image(systemName: "wineglass.fill").foregroundStyle(SaborColor.tertiary)
                Text("¿Deseas agregar bebida?").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text("Maridaje ideal").font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SaborSpacing.md) {
                    ForEach(state.dishes.filter { $0.category == "Bebidas" }) { drink in
                        HStack(spacing: 10) {
                            SaborImage(key: drink.imageKey)
                                .frame(width: 44, height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(drink.name).font(SaborFont.labelMd)
                                    .foregroundStyle(SaborColor.onSurface).lineLimit(1)
                                Text(drink.priceText).font(SaborFont.bodySm)
                                    .foregroundStyle(SaborColor.primary)
                            }
                            Button { state.addToCart(drink) } label: {
                                Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(SaborColor.onPrimary)
                                    .frame(width: 30, height: 30)
                                    .background(SaborColor.primary, in: Circle())
                            }
                        }
                        .padding(SaborSpacing.sm)
                        .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))
                    }
                }
            }
        }
    }

    private var cutleryToggle: some View {
        HStack(spacing: SaborSpacing.md) {
            Image(systemName: "leaf.fill").foregroundStyle(SaborColor.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Cubiertos biodegradables").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Text("Ayuda a reducir residuos de un solo uso").font(SaborFont.bodySm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
            Spacer()
            Toggle("", isOn: $state.ecoCutlery).labelsHidden().tint(SaborColor.secondary)
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var coupon: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            HStack(spacing: 10) {
                Image(systemName: "ticket.fill").foregroundStyle(SaborColor.primary)
                TextField("Código de cupón", text: .constant("SABOR25")).font(SaborFont.bodyMd)
                Button { state.couponApplied = true } label: {
                    Text("Aplicado").font(SaborFont.labelMd).foregroundStyle(SaborColor.secondary)
                }
            }
            .padding(.horizontal, 14).frame(height: 50)
            .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))

            if state.couponApplied {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(SaborColor.secondary)
                    Text("Cupón SABOR25 (-25% en platos)").font(SaborFont.labelSm)
                        .foregroundStyle(SaborColor.onSurface)
                    Spacer()
                    Text("-8,00 €").font(SaborFont.labelMd).foregroundStyle(SaborColor.secondary)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(SaborColor.secondary.opacity(0.10), in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
            }
        }
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            Text("Resumen del pedido").font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface)
            row("Subtotal", Dish.price(state.subtotal))
            row("Coste de entrega", Dish.price(state.deliveryFee))
            row("Tarifa de servicio", Dish.price(state.serviceFee))
            if state.discount > 0 {
                HStack {
                    Text("Descuento promocional (SABOR25)").font(SaborFont.bodyMd)
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                    Spacer()
                    Text("-\(Dish.price(state.discount))").font(SaborFont.labelMd)
                        .foregroundStyle(SaborColor.secondary)
                }
            }
            Divider().overlay(SaborColor.sand)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total a pagar").font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                    Text("Impuestos incluidos (10% IVA)").font(SaborFont.bodySm)
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Spacer()
                Text(Dish.price(state.total)).font(SaborFont.headlineSm).foregroundStyle(SaborColor.primary)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
            Spacer()
            Text(value).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
        }
    }

    private var surchargeNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.shield.fill").foregroundStyle(SaborColor.secondary)
            Text("Pago seguro cifrado con garantía Sabor Fresco").font(SaborFont.bodySm)
                .foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity)
    }

    private var payBar: some View {
        HStack(spacing: SaborSpacing.md) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Total con descuento").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text(Dish.price(state.total)).font(SaborFont.titleLg).foregroundStyle(SaborColor.primary)
            }
            Spacer()
            Button { showCheckout = true } label: {
                HStack(spacing: 6) {
                    Text("Continuar al pago").font(SaborFont.labelMd)
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(SaborColor.onPrimary)
                .padding(.horizontal, 22).frame(height: 48)
                .background(SaborColor.primary, in: Capsule())
            }
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.containerLowest)
        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
        .saborElevation(.floating)
        .padding(.horizontal, SaborSpacing.margin)
        .padding(.bottom, 84)
    }
}
