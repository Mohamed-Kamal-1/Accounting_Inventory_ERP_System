# 📊 Smart Accounting & ERP System

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" />
  <img src="https://img.shields.io/badge/BLoC-1976D2?style=for-the-badge&logo=flutter&logoColor=white" />
</div>

<br>

A modern, comprehensive, and fully responsive Accounting and ERP application built with **Flutter**. Designed to work seamlessly across **Desktop, Tablet, and Mobile** devices. It handles sales, purchases, inventory, cash flow, and PDF report generation with full Arabic language support.

---

## 🚀 Download & Installation

Get the latest version of the application for your operating system:

* 💻 **Windows:** https://bit.ly/4dDzbNC
* 📱 **Android:** https://bit.ly/3UWtF2i



---

## ✨ Key Features

* **📦 Purchases & Sales Management:** Complete workflows for creating, tracking, and managing invoices.
* **📄 Advanced PDF Export:** Generate highly customizable PDF invoices with full **Arabic (RTL)** font support using the `pdf` and `printing` packages.
* **📱 Responsive Design:** Adaptive UI that transforms logically from a multi-column desktop view to a scrollable, touch-friendly mobile view.
* **👥 Contact Management:** Dynamically filter and manage entities (Suppliers, Merchants, Customers).
* **📈 Real-time Dashboard:** Track cash flow, inventory value, and daily statistics instantly.
* **🔒 Secure Cloud Database:** Powered by **Supabase** (PostgreSQL) with strict Row Level Security (RLS) policies.

---

## 🏗️ Architecture & Tech Stack

This project strictly adheres to **Clean Architecture** principles, ensuring separation of concerns, scalability, and highly maintainable code.

### Tech Stack:
* **Framework:** Flutter
* **State Management:** BLoC / Cubit
* **Backend as a Service:** Supabase (Auth & PostgreSQL)
* **Dependency Injection:** `get_it` & `injectable`
* **Routing:** `go_router`

### Architectural Layers:
1. **Domain Layer:** Contains core business rules, Entities (e.g., `PurchaseInvoiceEntity`), and abstract Repositories. Independent of any other layer.
2. **Data Layer:** Implements repositories, contains Models (e.g., `PurchaseInvoiceModel`), and connects to Remote Data Sources (Supabase).
3. **Presentation Layer:** Contains UI Widgets, Screens, and Cubits. UI components are heavily modularized (e.g., separated `ProductsSectionWidget`, `SummarySectionWidget`).

--- 

## 🛠️ Getting Started (For Developers)

### Prerequisites
* Flutter SDK (Latest Stable)
* Dart SDK
* Supabase Account & Project keys

### Run the Project
1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/accounting-erp.git](https://github.com/yourusername/accounting-erp.git)
