//
//  CheckoutView.swift
//  SaborApp
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var payment = 0
    @State private var when = 0
    @State private var note = ""
    @State private var showConfirmed = false

    var body: some View {
        ZStack(alignment: .bottom) {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    SaborTopBar(title: "Finalizar", showLogo: false, showBack: true,
                                showNotifications: false, trailingIcon: "questionmark.circle",
                                onBack: { dismiss() }, onTrailing: {})
                    etaCard
                    addressSection
                    whenSection
                    paymentSection
                    noteSection
                    summarySection
                    ecoNote
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 130)
            }
            placeBar
        }
        .fullScreenCover(isPresented: $showConfirmed) { OrderConfirmedView() }
        .onAppear { state.seedCartIfEmpty() }
    }

    private var etaCard: some View {
        HStack(spacing: SaborSpacing.md) {
            Image(systemName: "moped.fill").font(.system(size: 18, weight: .semibold))
                .foregroundStyle(SaborColor.primary)
                .frame(width: 44, height: 44).background(SaborColor.primary.opacity(0.10), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text("Tiempo estimado").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text("25 - 35 minutos").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
            }
            Spacer()
            HStack(spacing: 5) {
                Circle().fill(SaborColor.secondary).frame(width: 7, height: 7)
                Text("En directo").font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var addressSection: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Label("Dirección de Entrega", systemImage: "location.fill")
                    .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Button {} label: {
                    Text("+ Nueva dirección").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary)
                }
            }
            if let a = state.addresses.first {
                HStack(alignment: .top, spacing: SaborSpacing.md) {
                    Image(systemName: a.icon).foregroundStyle(SaborColor.primary)
                        .frame(width: 40, height: 40).background(SaborColor.primary.opacity(0.10), in: Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(a.label).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                            SaborTag(title: "Principal", tint: SaborColor.secondary)
                        }
                        Text(a.detail).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                        Text(a.note).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                    Spacer()
                    Button {} label: { Text("Cambiar").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary) }
                }
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var whenSection: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            Text("Momento de entrega").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
            HStack(spacing: SaborSpacing.sm) {
                selectable("Lo antes posible", icon: "bolt.fill", index: 0, binding: $when)
                selectable("Programar hora", icon: "clock.fill", index: 1, binding: $when)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func selectable(_ title: String, icon: String, index: Int, binding: Binding<Int>) -> some View {
        let selected = binding.wrappedValue == index
        return Button { binding.wrappedValue = index } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12, weight: .semibold))
                Text(title).font(SaborFont.labelMd)
            }
            .frame(maxWidth: .infinity).frame(height: 44)
            .foregroundStyle(selected ? SaborColor.onPrimary : SaborColor.onSurface)
            .background(selected ? SaborColor.primary : SaborColor.containerLow, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Label("Método de Pago", systemImage: "creditcard.fill")
                    .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Button {} label: {
                    Text("+ Añadir nuevo").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary)
                }
            }
            paymentRow(index: 0, icon: "creditcard.fill", title: "•••• 4829", sub: "Mastercard • Expira 09/27", badge: "Predeterminada")
            paymentRow(index: 1, icon: "wave.3.right", title: "Apple Pay", sub: "valentina@correo.com", badge: nil)
            paymentRow(index: 2, icon: "banknote.fill", title: "Pago en efectivo", sub: "Importe exacto recomendado", badge: nil)
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func paymentRow(index: Int, icon: String, title: String, sub: String, badge: String?) -> some View {
        let selected = payment == index
        return Button { payment = index } label: {
            HStack(spacing: SaborSpacing.md) {
                Image(systemName: icon).foregroundStyle(SaborColor.primary)
                    .frame(width: 40, height: 40).background(SaborColor.primary.opacity(0.10), in: Circle())
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                        if let badge { SaborTag(title: badge, tint: SaborColor.tertiary) }
                    }
                    Text(sub).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Spacer()
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20)).foregroundStyle(selected ? SaborColor.primary : SaborColor.sandStrong)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            Label("Notas para la cocina o repartidor", systemImage: "square.and.pencil")
                .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
            TextField("Ej: sin cebolla, dejar en conserjería...", text: $note, axis: .vertical)
                .font(SaborFont.bodyMd).lineLimit(2...4)
                .padding(12)
                .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous).stroke(SaborColor.sand, lineWidth: 1))
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Label("Resumen del Pedido", systemImage: "list.bullet")
                    .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text("\(state.cartCount) platos").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
            }
            HStack(spacing: -10) {
                ForEach(state.cart.prefix(3)) { line in
                    SaborImage(key: line.dish.imageKey).frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous).stroke(SaborColor.containerLowest, lineWidth: 2))
                }
                Spacer()
            }
            Text("Sabor Selección").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
            Text(state.cart.map { $0.dish.name.components(separatedBy: " ").first ?? "" }.joined(separator: ", "))
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
            Divider().overlay(SaborColor.sand)
            row("Subtotal", Dish.price(state.subtotal))
            row("Gastos de envío", Dish.price(state.deliveryFee))
            row("Tarifa de servicio", Dish.price(state.serviceFee))
            HStack {
                Label("Cupón SABOR25", systemImage: "tag.fill")
                    .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                Spacer()
                Text("-\(Dish.price(state.discount))").font(SaborFont.labelMd).foregroundStyle(SaborColor.secondary)
            }
            Divider().overlay(SaborColor.sand)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total final").font(SaborFont.titleMd).foregroundStyle(SaborColor.onSurface)
                    Text("Impuestos incluidos (10% IVA)").font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Spacer()
                Text(Dish.price(state.total)).font(SaborFont.headlineSm).foregroundStyle(SaborColor.primary)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func row(_ t: String, _ v: String) -> some View {
        HStack {
            Text(t).font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
            Spacer()
            Text(v).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
        }
    }

    private var ecoNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "leaf.fill").foregroundStyle(SaborColor.secondary)
            Text("Este pedido compensa su huella de carbono al 100% y utiliza envases compostables.")
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.secondary.opacity(0.10), in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
    }

    private var placeBar: some View {
        VStack(spacing: 8) {
            Button { state.placeOrder(); showConfirmed = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                    Text("Realizar pedido").font(SaborFont.labelLg)
                    Spacer()
                    Text(Dish.price(state.total)).font(SaborFont.labelLg)
                    Image(systemName: "arrow.right").font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(SaborColor.onPrimary)
                .padding(.horizontal, 20).frame(height: 54)
                .background(SaborColor.primary, in: Capsule())
            }
            HStack(spacing: 6) {
                Image(systemName: "lock.shield.fill").font(.system(size: 11)).foregroundStyle(SaborColor.secondary)
                Text("Pago cifrado SSL de 256 bits y garantía Sabor").font(SaborFont.labelSm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.containerLowest)
        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
        .saborElevation(.floating)
        .padding(.horizontal, SaborSpacing.margin)
        .padding(.bottom, 20)
    }
}
