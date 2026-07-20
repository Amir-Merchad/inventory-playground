# Prompt for Claude — Farm Management System prototype + presentation

Copy everything below the line and paste it into Claude.

---

I'm a freelance developer pitching a farm management system to a client. I need two things from you: **(1) a clickable HTML prototype** of the app and **(2) a short presentation** (5–7 slides) I can show him. Build the prototype first.

## The product

An online multi-farm management system. Each farm is run by a **farm manager** who enters daily data from a mobile app. The **owner (admin)** sees all farms through a desktop dashboard with reports. Online only — no offline mode.

The core business flow:

- A farm has **animals** (tracked individually with a tag, or as groups/flocks) and **crops**. Both are assets.
- Assets generate **expenses**: vaccines & vet visits, feed & vitamins, seeds & fertilizer, worker wages (entered as simple expenses, not payroll), and general farm costs.
- Assets produce **products**: milk, eggs, wheat, etc.
- Products are converted into **stock items** through a **production run** that follows a recipe (defined inputs → outputs), recording production costs and **conversion losses** (e.g., 100L milk + 2kg salt → 12kg cheese, 3% loss).
- **Stock can be reused as an input** to produce new products — this loop is the heart of the system.
- **Purchases**: supplies (feed, seeds, medicine) and ready goods bought for resale straight into stock.
- **Sales**: stock sold to customers with simple invoices (credit sales and customer balances supported), and **asset sales** (selling an animal or a crop directly).
- **Reports**: profit per farm / animal group / crop, expense breakdown by category, production efficiency (expected vs. actual losses), stock value.

Roles: the admin is read-only across all farms by default; to edit data he "enters as" that farm's manager, and everything is audited.

## 1) The prototype

A single-file HTML clickable prototype (no backend, hardcoded realistic demo data — use a dairy/poultry farm called "Green Valley Farm" with a second farm for the admin view). Two experiences, switchable from a small toggle at the top:

**Manager view (phone-sized frame, ~390px wide):**
- Home: today's summary (expenses entered, production recorded, low-stock alerts) + big quick-action buttons: add expense, record production, record sale.
- Animals list (mix of individual cows with tags and a chicken flock) → tap one to see its record: info, health/vaccine history with next-due reminder, its expenses.
- Add expense form (category, amount, link to animal/crop/general, photo placeholder).
- Record production run: pick a recipe (e.g., "Cheese — white"), enter input quantities, see expected output, enter actual output, loss is computed and highlighted if above the recipe's normal loss.
- Stock list with quantities, average cost, and a low-stock badge.
- New sale (invoice): pick customer, add stock lines, paid/partial/credit.

**Admin view (desktop layout):**
- Dashboard across farms: revenue vs. expenses this month, profit per farm, stock value, alerts (low stock, abnormal production loss, vaccine due).
- Farm detail: profit per animal group and per crop, expense breakdown donut, recent sales.
- A visible "Enter as manager" button (just switches to manager view) with an "audited" note.

Style: clean, modern, farm-friendly (greens/earth tones), Arabic-friendly design direction but build the prototype in English. Navigation must actually work between screens.

## 2) The presentation

5–7 slides for a non-technical farm owner: the problem (paper/Excel, no real numbers per animal or crop), the solution in one picture (the flow above), what the manager does daily, what the owner sees, extra features (vaccine reminders, QR tags for animals, loss alerts, expiry tracking, plot/season planning as later options), and delivery in 3 phases (core in ~3–4 months, then comfort features, then refinements) with a monthly live demo. Keep the text minimal and visual.

Ask me at most 3 clarifying questions before starting if anything is truly blocking; otherwise make sensible assumptions and go.
