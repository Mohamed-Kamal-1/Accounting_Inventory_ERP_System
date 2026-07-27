# 🛠️ Life Plast ERP System (Cloud-Enabled Desktop & Mobile)

**A High-Performance ERP solution tailored for industrial supply management, powered by Supabase.**

Built for **stability**, **data integrity**, and **speed**, leveraging a robust relational cloud backend to ensure seamless data synchronization across Windows Desktop and Mobile environments.

---

## 🚀 Overview
Life Plast ERP is a specialized management system designed for industrial and plumbing supply companies. It replaces manual paperwork with a robust digital infrastructure, focusing on fast data entry, secure cloud storage, and real-time record-keeping.

### Key Business Modules:
* **Inventory Engine:** Real-time stock tracking with cloud-based data persistence.
* **Invoicing System:** Instant digital invoice generation and secure record-keeping for daily sales.
* **Stock Flow Audit:** Specialized logic to track and verify stock movements and sales history.
* **Performance Dashboard:** High-speed data visualization for sales trends and stock alerts.

---

## 🏗️ Architecture & Tech Stack
This project is built with a focus on **modularity** and **testability**, ensuring the business logic is decoupled from the UI.

* **Framework:** [Flutter](https://flutter.dev) (Optimized for **Windows Desktop** & Android).
* **State Management:** [BLoC / Cubit](https://pub.dev/packages/flutter_bloc) for predictable, localized state handling.
* **Backend & Database:** 
    * **Supabase (PostgreSQL):** Utilized as the primary relational cloud database to structuralize, query, and manage complex inventory and accounting data.
    * **SharedPreferences:** Used for caching lightweight local configurations, user settings, and session flags.
* **Dependency Injection:** [Injectable](https://pub.dev/packages/injectable) & [GetIt](https://pub.dev/packages/get_it) for decoupled service management and cleaner code.
* **Business Logic:** Modularized using **Dart Mixins** to organize cross-cutting concerns (Sales, Purchases, Invoices).
* **Updates:** [Shorebird](https://shorebird.dev) for Over-the-Air (OTA) patches to deliver instant fixes.

---

## ✨ Technical Highlights
* **Real-Time Synchronization:** Seamless data sync between Windows (Admin use) and Mobile clients powered by Supabase.
* **Relational Data Integrity:** Designed structured PostgreSQL database tables with relational integrity to handle complex accounting transactions.
* **Service-Oriented Design:** Logic is encapsulated in Singletons and Services to ensure a clean API integration layer.
* **Luxury Minimalist UI:** A premium dashboard designed for high-density data management with a clean, professional aesthetic.
* **Cross-Platform Consistency:** Unified codebase providing a native experience on Windows and Mobile.

---

## 📸 Project Preview
*(Add your screenshots here to showcase the Luxury UI)*

---

## 🛠️ Installation & Setup (For Developers)

1. **Clone the repo:**
   ```bash
   git clone [https://github.com/Mohamed-Kamal-1/life_plast.git](https://github.com/Mohamed-Kamal-1/life_plast.git)
