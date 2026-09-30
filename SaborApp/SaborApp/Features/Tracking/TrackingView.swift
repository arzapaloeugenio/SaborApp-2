//
//  TrackingView.swift
//  SaborApp
//

import SwiftUI

struct TrackingView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    SaborTopBar(title: "Seguimiento", showLogo: false, showBack: true,
                                showNotifications: false, trailingIcon: "questionmark.circle",
                                onBack: { dismiss() }, onTrailing: {})
                    mapCard
                    statusCard
                    timeline
                    courierCard
                    pinCard
                    orderSummary
                    helpRow
                }
                .padding(.horizontal, SaborSpacing.margin)
                .padding(.top, SaborSpacing.sm)
                .padding(.bottom, 40)
            }
        }
    }

    private var mapCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: SaborRadius.xl, style: .continuous)
                .fill(LinearGradient(colors: [SaborColor.secondary.opacity(0.18), SaborColor.secondary.opacity(0.06)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 190)
            // stylised route
            Path { p in
                p.move(to: CGPoint(x: 40, y: 150))
                p.addCurve(to: CGPoint(x: 300, y: 50),
                           control1: CGPoint(x: 120, y: 170),
                           control2: CGPoint(x: 220, y: 30))
            }
            .stroke(SaborColor.primary.opacity(0.6), style: StrokeStyle(lineWidth: 3, dash: [6, 6]))

            VStack {
                HStack {
                    chip(icon: "flame.fill", text: "Sabor Bistro")
                    Spacer()
                    chip(icon: "bicycle", text: "Carlos • 12 min")
                }
                Spacer()
                HStack {
                    Spacer()
                    chip(icon: "house.fill", text: "Mi Casa")
                }
            }
            .padding(14)

            HStack(spacing: 10) {
                mapButton("location.fill") {}
                mapButton("bubble.left.fill") {}
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 14)

            Text("TRANSMISIÓN SATELITAL EN DIRECTO").font(SaborFont.labelSm)
                .foregroundStyle(SaborColor.secondary)
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(.ultraThinMaterial, in: Capsule())
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 12)
        }
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 10, weight: .bold))
            Text(text).font(SaborFont.labelSm)
        }
        .foregroundStyle(SaborColor.onSurface)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }
    private func mapButton(_ icon: String, _ a: @escaping () -> Void) -> some View {
        Button(action: a) {
            Image(systemName: icon).font(.system(size: 15, weight: .semibold))
                .foregroundStyle(SaborColor.onSurface)
                .frame(width: 40, height: 40).background(.ultraThinMaterial, in: Circle())
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: "location.north.fill").font(.system(size: 11))
                Text("En camino • 12 min aprox.").font(SaborFont.labelSm)
            }
            .foregroundStyle(SaborColor.secondary)
            Text("El repartidor va hacia tu puerta").font(SaborFont.headlineSm)
                .foregroundStyle(SaborColor.onSurface)
            Text("Carlos ha recogido tu comida caliente y está a 2.4 km de tu dirección.")
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(MockData.trackingSteps.enumerated()), id: \.element.id) { idx, step in
                HStack(alignment: .top, spacing: SaborSpacing.md) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(step.state == .pending ? SaborColor.container : SaborColor.secondary)
                                .frame(width: 34, height: 34)
                            Image(systemName: step.icon)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(step.state == .pending ? SaborColor.onSurfaceVariant : .white)
                        }
                        if idx < MockData.trackingSteps.count - 1 {
                            Rectangle().fill(step.state == .done ? SaborColor.secondary : SaborColor.sand)
                                .frame(width: 2).frame(maxHeight: .infinity)
                        }
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(step.title).font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                        Text(step.subtitle).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                    Spacer()
                    Text(step.time).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                }
                .padding(.bottom, idx < MockData.trackingSteps.count - 1 ? SaborSpacing.md : 0)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var courierCard: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            Text("Tu Repartidor Asignado").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
            HStack(spacing: SaborSpacing.md) {
                SaborImage(key: "Carlos M.").frame(width: 54, height: 54).clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Carlos M.").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                        SaborTag(title: "VIP Sabor", icon: "checkmark.seal.fill")
                    }
                    HStack(spacing: 4) {
                        SaborRating(value: 4.9)
                        Text("(1.240 entregas)").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                    Text("Moto Honda ecológica • M-8291-ZX").font(SaborFont.bodySm)
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
                Spacer()
            }
            HStack(spacing: SaborSpacing.md) {
                action("phone.fill", "Llamar") {}
                action("message.fill", "Mensaje") {}
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func action(_ icon: String, _ title: String, _ a: @escaping () -> Void) -> some View {
        Button(action: a) {
            HStack(spacing: 6) {
                Image(systemName: icon); Text(title).font(SaborFont.labelMd)
            }
            .foregroundStyle(SaborColor.primary)
            .frame(maxWidth: .infinity).frame(height: 44)
            .background(SaborColor.primary.opacity(0.10), in: Capsule())
        }
    }

    private var pinCard: some View {
        HStack(spacing: SaborSpacing.md) {
            Image(systemName: "lock.fill").foregroundStyle(SaborColor.primary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Código PIN de entrega").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                Text("4821").font(SaborFont.titleLg).foregroundStyle(SaborColor.onSurface).tracking(4)
            }
            Spacer()
            Image(systemName: "number.square.fill").font(.system(size: 24)).foregroundStyle(SaborColor.primary.opacity(0.4))
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private var orderSummary: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "fork.knife").foregroundStyle(SaborColor.primary)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Pedido \(state.lastOrderReference)").font(SaborFont.titleSm)
                            .foregroundStyle(SaborColor.onSurface)
                        Text("3 platos").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down").foregroundStyle(SaborColor.onSurfaceVariant)
            }
            Text("Pagado con Apple Pay • Total: \(Dish.price(41.60))").font(SaborFont.bodySm)
                .foregroundStyle(SaborColor.onSurfaceVariant)
            Divider().overlay(SaborColor.sand)
            ForEach(state.dishes.prefix(3)) { dish in
                HStack {
                    Text("1x").font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(dish.name.components(separatedBy: " ").prefix(2).joined(separator: " "))
                            .font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                        Text(dish.description).font(SaborFont.labelSm)
                            .foregroundStyle(SaborColor.onSurfaceVariant).lineLimit(1)
                    }
                    Spacer()
                    Text(dish.priceText).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                }
            }
            Divider().overlay(SaborColor.sand)
            row("Subtotal de platos", Dish.price(41.60))
            row("Tasa de entrega ecológica", "Gratis")
            row("Propina a Carlos", "Incluida (3,00 €)")
            HStack {
                Text("Total abonado").font(SaborFont.titleSm).foregroundStyle(SaborColor.onSurface)
                Spacer()
                Text(Dish.price(41.60)).font(SaborFont.titleMd).foregroundStyle(SaborColor.primary)
            }
        }
        .padding(SaborSpacing.md).saborCard()
    }

    private func row(_ t: String, _ v: String) -> some View {
        HStack {
            Text(t).font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
            Spacer()
            Text(v).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
        }
    }

    private var helpRow: some View {
        Button {} label: {
            HStack(spacing: SaborSpacing.md) {
                Image(systemName: "questionmark.circle.fill").foregroundStyle(SaborColor.primary)
                Text("¿Necesitas cambiar algo o reportar una incidencia?").font(SaborFont.bodyMd)
                    .foregroundStyle(SaborColor.onSurface)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
            .padding(SaborSpacing.md).saborCard()
        }
        .buttonStyle(.plain)
    }
}
