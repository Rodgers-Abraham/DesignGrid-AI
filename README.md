# DesignGrid.AI 🎨✨

**DesignGrid.AI** is a premium, AI-augmented design studio application built with Flutter. It combines high-end aesthetic design with powerful generative capabilities to provide a seamless creative workflow for professionals.

## 🌟 Vision
To empower designers with an ultra-fluid interface that bridges the gap between manual precision and AI-driven inspiration.

## 🛠️ Key Features

### 1. The Hub (Home)
- **3D Stacked Carousel:** An automated 10-second cycling deck showcasing project drafts with smooth perspective transforms.
- **Quick Access Hub:** Instant entry points to the Creator Studio and project archives.

### 2. Creator Studio
- **Hybrid Canvas:** Seamlessly toggle between **Manual Editing** and **AI Co-pilot Mode**.
- **Gemini Integration:** Generate high-fidelity designs using multimodal prompts powered by Google AI Studio.
- **Multi-Format Presets:** Optimized layouts for Business Cards, Promo Posters, Web Banners, and more.

### 3. Project Terminal
- **Local Persistence:** Designs are stored locally with metadata overlays.
- **Responsive Grid:** Fast access to drafts and saved projects.

### 4. Identity Terminal (Me Page)
- **Premium UI:** A high-end operating system terminal-style interface for account management.
- **Dynamic Theming:** Instant switching between Dark (Matte Black/Amber) and Light modes.

## 🏗️ Technical Implementation

### Core Stack
- **Framework:** Flutter (Multi-platform)
- **State Management:** BLoC / Cubit for predictable data flow.
- **Navigation:** GoRouter with `StatefulShellRoute` to maintain canvas state across tabs.
- **Logic:** Multimodal AI integration via Gemini API.
- **Security:** AES-encrypted local storage for API keys using `flutter_secure_storage`.

### Design System
- **Background:** Ultra-deep charcoal/matte black (#0D0E12).
- **Accents:** Bright Amber (#FFC72C) and Yellow (#FFB800).
- **Typography:** Google Fonts (Inter).
- **Shapes:** Consistent 12px to 16px corner radii for a modern container-based feel.

## 📁 Asset Management
- **Logo:** High-fidelity brand assets should be placed in `assets/images/logo/`.
- **Templates:** Pre-configured design examples and presets are located in `assets/templates/`. These serve as the backbone for the Creator Studio gallery.

---

## 🚀 Development Phases

- [x] **Phase 1: Scaffolding** - Core architecture and theme setup.
- [x] **Phase 2: Navigation** - Multi-tab shell and stateful routing.
- [x] **Phase 3: Logic** - Implementation of BLoC states and secure storage.
- [x] **Phase 4: UI Development** - High-fidelity screen implementation.
- [x] **Phase 5: Validation** - Final security audit and performance optimization.

---

