# Farm Management System — Project Requirements

**Version:** 1.0 draft · **Date:** 2026-07-15 · **Based on:** client conversation + `app.drawio` schema

---

## 1. What the system is

A multi-farm management platform. Each farm tracks its **assets** (animals, crops), the **expenses** those assets generate, the **products** they produce, conversion of products into sellable **stock**, and **sales**. Stock items can be consumed to produce new items (e.g., milk → cheese). Farms are managed day-to-day by a **farm manager**; an **admin** oversees all farms through reports.

### Reading of your schema
Your drawio maps cleanly to this flow:

- **Farm** → has workers (worker expenses), general farm expenses, and assets.
- **Assets** = animals + crops. Both generate expenses (vaccines & vet appointments, food & vitamins, seeds) and produce **products**. Assets themselves can be sold (**asset sales**).
- **Products** → converted into **stock items**, with **conversion losses** and **production expenses** recorded.
- **Stock** → sold to customers (invoice-based, not POS), or **reused as inputs to produce new products** (your reuse loop).
- **Purchases** → buy items to resell (instead of producing) and buy supplies (feed, seeds, vitamins) which land as expenses.
- **Roles** → manager enters data per farm; admin sees all farms but must "enter as" a farm manager to modify data.

The schema is solid. The two things it implies but doesn't name are: a **recipe/BOM concept** (which stock items + quantities produce which product) and **unit-of-measure handling** (liters → kg with loss %). Both are called out below.

---

## 2. Tech stack assessment

Your plan (Kotlin Spring Boot backend + Flutter clients) is a good fit:

- **Kotlin + Spring Boot** — strong choice: Spring Security for role-based auth, Spring Data JPA + PostgreSQL, easy multi-tenancy by `farm_id` scoping.
- **Flutter** — one codebase covers Android/iOS for managers **and** desktop (Windows/macOS/Linux) + web for the admin. You do not need a separate desktop technology.
- **PostgreSQL** recommended (ledger-style data, reporting queries, row-level scoping).
- **JWT auth** (access + refresh) with roles embedded; admin "impersonate manager" as an explicit audited endpoint.
- Suggested extras: Flyway (DB migrations), OpenAPI/Swagger (contract for the Flutter team), Docker Compose for dev.

One strong recommendation: farms often have poor connectivity. Build the manager app **offline-first** (local SQLite/Drift cache, sync queue). This is the single biggest real-world success factor for this kind of app.

---

## 3. Actors & permissions

| Actor | Access |
|---|---|
| **Admin** | Sees all farms, all reports (read-only by default). Creates farms & manager accounts. Can impersonate a farm manager to edit data (audited). |
| **Farm Manager** | Full CRUD on their own farm only: assets, expenses, production, stock, purchases, sales, workers. |
| **Worker** (optional, phase 2) | Limited data entry (e.g., record feeding, harvest quantities) without seeing financials. |

---

## 4. Functional requirements (by module)

### 4.1 Farm & user management
- FR-1: Admin creates/edits/archives farms (name, location, type, currency).
- FR-2: Admin creates manager accounts and assigns them to exactly one farm (or more, configurable).
- FR-3: Authentication with email/username + password; password reset; session/refresh tokens.
- FR-4: Admin impersonation of a manager, with an audit log entry for every impersonated action.

### 4.2 Asset management — Animals
- FR-5: Register animals individually (tag/ID, species, breed, sex, birth date, source: born/purchased, purchase cost) or as **groups/flocks** (e.g., 200 chickens) — both models needed.
- FR-6: Animal lifecycle events: birth, weight records, breeding, illness, death, sold.
- FR-7: Health records: vaccines and vet appointments with date, cost, next-due date → generates expense + reminder.
- FR-8: Feeding: food & vitamin consumption recorded as expense, optionally drawn from purchased supply inventory.

### 4.3 Asset management — Crops
- FR-9: Register crop plots/fields (crop type, area, planting date, expected harvest date, season).
- FR-10: Crop expenses: seeds, fertilizers, vitamins, irrigation, labor.
- FR-11: Harvest events create **products** (quantity + unit).

### 4.4 Expenses
- FR-12: Every expense has: farm, date, amount, category, optional link to an asset/animal/crop/worker/production run, attachment (receipt photo), notes.
- FR-13: Expense categories (extensible): vet & vaccines, feed & vitamins, seeds & fertilizer, worker wages, production costs, general farm (fuel, rent, maintenance, utilities).
- FR-14: Recurring expenses (e.g., monthly wages, rent) auto-generated with confirmation.

### 4.5 Workers
- FR-15: Worker registry per farm (name, role, wage type: monthly/daily/per-task).
- FR-16: Wage payments and worker-related costs recorded as expenses; optional attendance log.

### 4.6 Purchases
- FR-17: Purchase orders/records for: supplies (feed, seeds, vitamins → supply inventory/expense), resale goods (→ directly into stock), and new assets (animals → asset registry).
- FR-18: Supplier registry (name, contact, balance if bought on credit).

### 4.7 Production (the core differentiator)
- FR-19: **Products** are produced by assets (milk, eggs, wheat…) — recorded with date, source asset(s), quantity, unit.
- FR-20: **Conversion to stock**: a production run converts products (and optionally other stock items) into stock items, recording input quantities, output quantities, **conversion losses**, and **production expenses** (labor, energy, packaging). Example: 100L milk + 2kg salt (stock) → 12kg cheese, 3% loss, 500 DA labor.
- FR-21: **Recipes/BOM**: define reusable recipes (inputs + expected outputs + expected loss %) so runs are fast to enter and variances are detectable.
- FR-22: Unit-of-measure support and conversion (L, kg, unit, dozen, bale…).

### 4.8 Stock / inventory
- FR-23: Stock items with quantity on hand, unit, average cost (computed from production costs + purchase costs), minimum-stock threshold.
- FR-24: Stock movements ledger: in (production, purchase), out (sale, consumed in production, spoilage/adjustment). Every change is a movement — no silent edits.
- FR-25: Low-stock and expiry alerts (batch/lot with expiry dates for perishables — recommended).

### 4.9 Sales
- FR-26: **Stock sales**: invoice-style sale to a customer (customer, date, lines with item/qty/unit price, payment status: paid/partial/credit). Explicitly *not* a POS.
- FR-27: **Asset sales**: sell an animal or a crop (standing/whole) — removes/archives the asset and records revenue with link to its accumulated cost.
- FR-28: Customer registry with balances (credit sales are common in farm trade).

### 4.10 Reports & dashboard (admin's main surface)
- FR-29: Per-farm and cross-farm dashboards: revenue, expenses, profit, stock value, asset counts, over a selectable period.
- FR-30: Profitability per asset / asset group / crop plot (revenue attributable minus expenses attributable) — this is the report the owner really wants.
- FR-31: Expense breakdown by category; sales by product/customer; production yield & loss variance vs. recipe.
- FR-32: Export to PDF/Excel; date-range filters everywhere.

---

## 5. Non-functional requirements

- NFR-1: **Multi-tenancy**: every row scoped by `farm_id`; enforced server-side, never trusted from the client.
- NFR-2: **Offline-first mobile** for managers with background sync and conflict handling (last-write-wins + audit, or server-authoritative merge).
- NFR-3: **Audit trail** on all financial records (who, when, what changed) — especially impersonated admin actions.
- NFR-4: Soft-delete only for financial data.
- NFR-5: Localization-ready (RTL/Arabic + French + English if this is for the Maghreb market) and multi-currency per farm.
- NFR-6: Daily automated DB backups; HTTPS everywhere; passwords hashed (bcrypt/argon2).
- NFR-7: Reasonable scale target: dozens of farms, a few users each — a single Postgres instance is fine; don't over-engineer.

---

## 6. New ideas (beyond the schema)

1. **Reminders & calendar** — vaccine due dates, vet appointments, planting/harvest windows, recurring expenses. Push notifications to the manager app. High value, low cost.
2. **Batch/lot tracking with expiry** — for dairy/processed goods; enables spoilage tracking and FIFO costing.
3. **QR/barcode tags** for animals and stock items — scan to open the record in the mobile app.
4. **Photo attachments** everywhere (animal photos, receipts, harvest photos) — cheap and hugely appreciated.
5. **Recipe variance alerts** — if a production run's loss exceeds the recipe's expected loss by X%, flag it on the admin dashboard (detects theft/waste).
6. **Weather integration** (phase 2+) for crop planning.
7. **Price history** per product/customer to help set sale prices.
8. **Simple cash ledger** per farm (money in/out) so the owner can reconcile cash — farms run on cash.

---

## 7. Open questions for the client

1. Animals tracked **individually, as groups, or both**? (Cows individually, chickens as flocks — affects the data model deeply.)
2. Does he need to track **which specific animal** produced what, or per-farm totals?
3. Sales on **credit** with customer balances? Multiple currencies?
4. How many farms/users at launch? One owner-admin or multiple admins?
5. Internet reliability at the farms → how critical is offline mode? (Assume critical.)
6. Language(s) of the UI?
7. Should purchased supplies (feed bags, seed sacks) be tracked as an inventory with quantities, or just expensed on purchase? (Recommend inventory-tracked in phase 2.)
8. Any legal/tax reporting needs (invoices with tax numbers)?

---

## 8. Architecture & delivery plan

```
Flutter mobile (manager, offline-first) ─┐
Flutter mobile/desktop/web (admin)      ─┤→ REST API (Kotlin + Spring Boot 3, JWT)
                                          → PostgreSQL (Flyway migrations)
                                          → Object storage for photos (S3/minio)
```

**Phase 1 — MVP (core value):** auth & roles, farm/manager setup, animals & crops registry, expenses, products → stock conversion (with losses), stock ledger, stock & asset sales, basic dashboard.
**Phase 2:** recipes/BOM + variance, offline sync, reminders & notifications, supply inventory, customer/supplier balances, exports.
**Phase 3:** batches/expiry, QR tags, worker attendance, weather, multi-language polish.

Estimate honestly: Phase 1 alone is ~3–4 months for one full-stack dev. The production/stock/costing loop is the hard 30% — prototype it first.
