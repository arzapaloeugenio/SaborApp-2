//
//  OrderConfirmedView.swift
//  SaborApp
//

import SwiftUI

struct OrderConfirmedView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showTracking = false

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    hero
                    referenceCard
                    dishesCard
                    freshnessNote
                    actions
                }
                .padding(SaborSpacing.margin)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showTracking) { TrackingView() }
    }

    private var hero: some View {
        VStack(spacing: SaborSpacing.md) {
            ZStack {
                Circle().fill(SaborColor.secondary.opacity(0.14)).frame(width: 96, height: 96)
                Image(systemName: "checkmark").font(.system(size: 40, weight: .bold))
                    .foregroundStyle(SaborColor.secondary)
            }
            Text("¡Pedido Confirmado con Éxito!").font(SaborFont.headlineMd)
                .foregroundStyle(SaborColor.onSurface).multilineTextAlignment(.center)
            Text("La cocina de Sabor ha recibido tu orden y ya está encendiendo los fogones.")
                .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var referenceCard: some View {
        VStack(spacing: SaborSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Referencia").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                    Text(state.lastOrderReference).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                }
                Spacer()
                HStack(spacing: 5) {
                    Image(systemName: "flame.fill").font(.system(size: 10))
                    Text("En cocina").font(SaborFont.labelSm)
                }
                .foregroundStyle(SaborColor.primary)
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(SaborColor.primary.opacity(0.10), in: Capsule())
            }
            Divider().overlay(SaborColor.sand)
            infoRow("clock.fill", "Tiempo estimado", "25 - 35 min", nil)
            infoRow("location.fill", "Dirección de entrega", "Calle Mayor 24, 3ºB", nil)
            infoRow("creditcard.fill", "Método de pago", "Mastercard •••• 4829", Dish.price(state.total))
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func infoRow(_ icon: String, _ title: String, _ value: String, _ trailing: String?) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(SaborColor.primary).frame(width: 24)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text(value).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
            }
            Spacer()
            if let trailing { Text(trailing).font(SaborFont.labelMd).foregroundStyle(SaborColor.primary) }
        }
    }

    private var dishesCard: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Text("Platos en preparación (\(state.orders.first?.dishCount ?? 3))")
                    .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text("Ver detalle").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary)
            }
            ForEach(state.dishes.prefix(3)) { dish in
                HStack(spacing: SaborSpacing.md) {
                    SaborImage(key: dish.imageKey).frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dish.name.components(separatedBy: " ").prefix(2).joined(separator: " "))
                            .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                        Text(dish.description).font(SaborFont.bodySm)
                            .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(1)
                    }
                    Spacer()
                    Text("x1").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurfaceVariant)
                }
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var freshnessNote: some View {
        HStack(spacing: SaborSpacing.md) {
            Image(systemName: "leaf.fill").font(.system(size: 18)).foregroundStyle(SaborColor.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Garantía de Frescura Sabor").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Text("Ingredientes 100% frescos preparados al momento por nuestros chefs colaboradores.")
                    .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
            }
        }
        .padding(SaborSpacing.md)
        .background(SaborColor.secondary.opacity(0.10), in: RoundedRectangle(cornerRadius: SaborRadius.lg, style: .continuous))
    }

    private var actions: some View {
        VStack(spacing: SaborSpacing.sm) {
            SaborPrimaryButton(title: "Seguimiento en Vivo", icon: "arrow.right", iconLeading: "location.fill") {
                showTracking = true
            }
            HStack(spacing: SaborSpacing.md) {
                ghostAction("Ir al Inicio", "house.fill") {
                    dismiss(); state.tab = .home
                }
                ghostAction("Recibo PDF", "doc.text.fill") {}
            }
        }
    }

    private func ghostAction(_ title: String, _ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title).font(SaborFont.labelMd)
            }
            .foregroundStyle(SaborColor.onSurface)
            .frame(maxWidth: .infinity).frame(height: 48)
            .background(SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
        }
    }
}
