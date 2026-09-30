//
//  OnboardingView.swift
//  SaborApp
//
//  Splash / Onboarding carousel (3 slides) matching the Stitch design.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var state: AppState
    @State private var index = 0
    @State private var showRegister = false

    private let slides: [Slide] = [
        Slide(image: "Hamburguesa Trufada Sabor",
              title: "Descubre nuevos sabores artesanales",
              desc: "Platos de alta cocina preparados al momento con ingredientes frescos de origen local directamente a tu mesa.",
              cta: "Comenzar a ordenar"),
        Slide(image: "Raviolis de Boletus y Foie",
              title: "Recetas de autor y sazón auténtica",
              desc: "Creadas por maestros culinarios que transforman cada bocado en una experiencia sensorial inolvidable.",
              cta: "Explorar menú"),
        Slide(image: "Salmón Glaseado al Miso",
              title: "La mesa servida donde prefieras",
              desc: "Servicio impecable con empaques ecológicos diseñados para conservar la textura y temperatura ideal.",
              cta: "Crear mi cuenta"),
    ]

    struct Slide { let image, title, desc, cta: String }

    var body: some View {
        ZStack {
            SaborCanvas()
            VStack(spacing: 0) {
                hero
                details
            }
            .ignoresSafeArea(edges: .top)
        }
        .sheet(isPresented: $showRegister) { RegisterView() }
    }

    // MARK: Hero image stack

    private var hero: some View {
        ZStack(alignment: .top) {
            ForEach(slides.indices, id: \.self) { i in
                SaborImage(key: slides[i].image)
                    .opacity(i == index ? 1 : 0)
            }
            .frame(height: 400)
            .clipped()

            LinearGradient(colors: [.black.opacity(0.35), .clear, SaborColor.background],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: 400)

            // Top bar over the photo
            HStack {
                SaborLogoMark(size: 30, showWordmark: true)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                Spacer()
                Button { state.showOnboarding = false } label: {
                    HStack(spacing: 4) {
                        Text("Saltar").font(SaborFont.labelMd)
                        Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(SaborColor.onSurface)
                    .padding(.horizontal, 12).frame(height: 34)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
            .padding(.horizontal, SaborSpacing.margin)
            .padding(.top, 60)
        }
    }

    // MARK: Copy + badges + CTAs

    private var details: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            // trust badges
            HStack(spacing: SaborSpacing.md) {
                badge(icon: "leaf.fill", text: "Ingredientes 100% de origen local")
                Spacer()
                HStack(spacing: 5) {
                    Image(systemName: "star.fill").font(.system(size: 11)).foregroundStyle(SaborColor.tertiary)
                    Text("4.9/5").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                    Text("de +12.000 comensales").font(SaborFont.labelSm)
                        .foregroundStyle(SaborColor.onSurfaceVariant)
                }
            }

            Text(slides[index].title)
                .font(SaborFont.displayLg)
                .foregroundStyle(SaborColor.onSurface)
                .fixedSize(horizontal: false, vertical: true)

            Text(slides[index].desc)
                .font(SaborFont.bodyMd)
                .foregroundStyle(SaborColor.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: SaborSpacing.lg) {
                feature(icon: "timer", title: "Entrega ágil", sub: "En su punto exacto")
                feature(icon: "fork.knife", title: "Menú de Autor", sub: "Chefs destacados")
            }

            // dots
            HStack(spacing: 6) {
                ForEach(slides.indices, id: \.self) { i in
                    Capsule()
                        .fill(i == index ? SaborColor.primaryContainer : SaborColor.containerHighest)
                        .frame(width: i == index ? 22 : 8, height: 8)
                }
            }
            .padding(.top, 2)

            SaborPrimaryButton(title: slides[index].cta, icon: "arrow.right") {
                if index < slides.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) { index += 1 }
                } else {
                    showRegister = true
                }
            }

            HStack(spacing: 4) {
                Spacer()
                Text("¿Ya tienes una cuenta?").font(SaborFont.bodySm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
                Button { state.showOnboarding = false } label: {
                    Text("Iniciar sesión").font(SaborFont.labelMd).foregroundStyle(SaborColor.primary)
                }
                Spacer()
            }
        }
        .padding(SaborSpacing.margin)
    }

    private func badge(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 12, weight: .bold))
                .foregroundStyle(SaborColor.secondary)
            Text(text).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurface)
        }
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(SaborColor.containerLowest, in: Capsule())
        .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
    }

    private func feature(icon: String, title: String, sub: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                .foregroundStyle(SaborColor.primary)
                .frame(width: 32, height: 32)
                .background(SaborColor.primary.opacity(0.10), in: Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                Text(sub).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant)
            }
        }
    }
}
