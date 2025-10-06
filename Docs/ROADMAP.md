# ROADMAP — WalletOCR (MVP v0.1.0)

## Цель
Рабочий офлайн-кошелёк с OCR чеков, тесты, метрики, CI, экспорт CSV.

## План по дням
### День 1 — Каркас навигации
- [x] RootView + AppCoordinator (табы + стек по табам)
- [x] Home → Scan → Review (пуш)
- [x] Системная кнопка «Назад» везде

### День 2 — CoreTypes + In-Memory repo
- [x] Модели Transaction/Money/Category
- [x] Добавить фикстуры и BudgetCalculator
- [x] Реализовать протоколы репозиториев (TransactionRepository, BudgetRepository)
- [x] InMemoryTransactionsRepository (save/fetch/delete/observe)

### День 3 — Dummy OCR → Review → Save
- [ ] OCRService (заглушка)
- [ ] Review сохраняет в repo и переключает в Траты

### День 4 — DesignSystem + доступность
- [ ] PrimaryButton + базовая типографика
- [ ] Навбар/заголовки/лейблы VO

### День 5 — SwiftData/Core Data
- [ ] Реальный репозиторий
- [ ] Миграция v1, индексы

### День 6 — BudgetEngine
- [ ] monthlyTotal / byCategory / remaining
- [ ] Экран Budgets с суммами

### День 7 — Vision OCR
- [ ] Preprocess → Recognize → Parse → Validate
- [ ] Камера/галерея, 5–10 реальных фото

### День 8 — CSV, локализация, флаги
- [ ] Экспорт CSV
- [ ] ru/en строки
- [ ] feature_flags.local.json

### День 9 — Перф и метрики
- [ ] Таймеры OCR/репо, MetricKit
- [ ] Миниатюры, отмена задач

### День 10 — Тесты, CI, доки
- [ ] Unit/Integration/UI
- [ ] GitHub Actions (линт, сборка, тесты)
- [ ] README/ARCHITECTURE/ADR/PRIVACY
