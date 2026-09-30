//
//  SignInView.swift
//  SaborApp
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var state: AppState
    @State private var email = "valentina@correo.com"
    @State private var password = "sabor1234"
    @State private var showPassword = false
    @State private var remember = true
    @State private var showRegister = false

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.lg) {
                    header
                    badge
                    SaborTextField(label: "Correo electrónico", placeholder: "ejemplo@correo.com",
                                   icon: "envelope.fill", text: $email, keyboard: .emailAddress)
                    passwordField
                    rememberRow
                    SaborPrimaryButton(title: "Iniciar sesión", icon: "arrow.right") {
                        state.signIn()
                    }
                    dividerLabel("o continúa con")
                    socialRow
                    guestButton
                    securityNote
                }
                .padding(SaborSpacing.margin)
                .padding(.top, 40)
                .padding(.bottom, 60)
            }
        }
        .sheet(isPresented: $showRegister) { RegisterView() }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.md) {
            HStack {
                Button { state.showOnboarding = true } label: {
                    Image(systemName: "arrow.left").font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(SaborColor.onSurface)
                        .frame(width: 38, height: 38)
                        .background(SaborColor.container, in: Circle())
                }
                Spacer()
                Button { showRegister = true } label: {
                    Text("Crear cuenta").font(SaborFont.labelMd).foregroundStyle(SaborColor.primary)
                }
            }
            SaborLogoMark(size: 46)
            HStack(spacing: 6) {
                Image(systemName: "fork.knife").font(.system(size: 11, weight: .bold))
                Text("ALTA COCINA A TU MESA").font(SaborFont.labelSm)
            }
            .foregroundStyle(SaborColor.primary)
            Text("¡Bienvenido de vuelta!").font(SaborFont.headlineLg).foregroundStyle(SaborColor.onSurface)
            Text("Inicia sesión para saborear tus platos favoritos y disfrutar de beneficios exclusivos.")
                .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var badge: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 12))
                .foregroundStyle(SaborColor.secondary)
            Text("Correo verificado").font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(SaborColor.secondary.opacity(0.12), in: Capsule())
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Contraseña").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurfaceVariant)
                Spacer()
                Button {} label: {
                    Text("¿Olvidaste tu contraseña?").font(SaborFont.labelSm).foregroundStyle(SaborColor.primary)
                }
            }
            SaborTextField(label: "", placeholder: "••••••••", icon: "lock.fill",
                           text: $password, isSecure: !showPassword,
                           trailingIcon: showPassword ? "eye.slash.fill" : "eye.fill",
                           trailingAction: { showPassword.toggle() })
        }
    }

    private var rememberRow: some View {
        Button { remember.toggle() } label: {
            HStack(spacing: 10) {
                Image(systemName: remember ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundStyle(remember ? SaborColor.primary : SaborColor.sandStrong)
                Text("Recordarme en este dispositivo").font(SaborFont.bodyMd)
                    .foregroundStyle(SaborColor.onSurface)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }

    private func dividerLabel(_ text: String) -> some View {
        HStack(spacing: 12) {
            Rectangle().fill(SaborColor.sand).frame(height: 1)
            Text(text).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant).fixedSize()
            Rectangle().fill(SaborColor.sand).frame(height: 1)
        }
    }

    private var socialRow: some View {
        HStack(spacing: SaborSpacing.md) {
            socialButton(icon: "globe", title: "Google")
            socialButton(icon: "apple.logo", title: "Apple")
            socialButton(icon: "faceid", title: "Face ID")
        }
    }

    private func socialButton(icon: String, title: String) -> some View {
        Button { state.signIn() } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                Text(title).font(SaborFont.labelMd)
            }
            .foregroundStyle(SaborColor.onSurface)
            .frame(maxWidth: .infinity).frame(height: 46)
            .background(SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
        }
    }

    private var guestButton: some View {
        Button { state.signIn() } label: {
            HStack(spacing: 8) {
                Image(systemName: "book.fill")
                Text("Explorar menú como invitado").font(SaborFont.labelMd)
            }
            .foregroundStyle(SaborColor.onSurfaceVariant)
            .frame(maxWidth: .infinity).frame(height: 46)
        }
    }

    private var securityNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.shield.fill").foregroundStyle(SaborColor.secondary)
            Text("Tus datos están protegidos con cifrado de grado bancario")
                .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
}
