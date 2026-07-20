# Backend + Frontend Learning Roadmap

A living checklist for turning the products playground into the foundation of a real POS/ERP.
Work top to bottom — each phase leans on the one before it. Check boxes as you go.

Legend: `[ ]` todo · `[~]` in progress · `[x]` done · **(you)** = you write it, I review

---

## Where the project stands today

Backend (Kotlin / Spring Boot 4 / JPA / Flyway / Postgres):
- Products CRUD with pagination + case-insensitive search
- Flyway migrations, `ddl-auto=validate`, `open-in-view=false`
- Optimistic locking via `@Version`, bean validation, DTO/entity separation
- Multi-stage Dockerfile, healthcheck-gated compose

Frontend (Flutter / BLoC / Retrofit / freezed / Dio):
- Product list with search (debounced), pagination, page-size selector, CRUD
- `restartable` / `droppable` / `debounce` event transformers
- `Decimal` for money, freezed models, Retrofit API client

Known small fixes (do whenever you touch the file):
- [ ] `product_event.dart`: `final id;` → `final String id;` in `ProductDeleted`
- [ ] Default page size is inconsistent: state `20`, api `20`, controller `10` — pick one
- [ ] `updateProduct` manually sets `version + 1`, which fights JPA's `@Version` (Hibernate increments on flush). Keep the pre-check, drop the manual increment.

---

## Phase 1 — Error handling + error contract  ← START HERE

**Why first:** every `throw IllegalArgumentException(...)` currently returns HTTP 500. Auth is entirely about status codes (401/403/409/400), and the frontend can't react to errors it can't distinguish. Fix the contract before building on it.

Concepts to learn:
- Why unhandled exceptions become 500 in Spring
- RFC 9457 `ProblemDetail` (built into Spring Boot 4)
- `@RestControllerAdvice` + `@ExceptionHandler`
- Domain exceptions carrying an HTTP status + a stable error `code`
- Handling `MethodArgumentNotValidException` (validation → 400 + field errors)
- Handling `OptimisticLockingFailureException` (→ 409)

Backend tasks **(you)**:
- [ ] Define domain exceptions (e.g. `ProductNotFoundException`, `DuplicateSkuException`, a base `AppException`)
- [ ] Replace `IllegalArgumentException` throws in `ProductService` with domain exceptions
- [ ] Write a `GlobalExceptionHandler` (`@RestControllerAdvice`) returning `ProblemDetail`
- [ ] Map: not found → 404, duplicate SKU → 409, validation → 400, optimistic lock → 409, catch-all → 500
- [ ] Add a stable `code` (e.g. `PRODUCT_NOT_FOUND`) and a `errors` list for field validation

Frontend tasks **(you)**:
- [ ] A typed `ApiError` model (status, code, message, field errors)
- [ ] A Dio error mapper / interceptor that turns `DioException` → `ApiError`
- [ ] Surface `ApiError.message` in the UI instead of `error.toString()`

Acceptance:
- [ ] `POST` a duplicate SKU → 409 with a readable body
- [ ] `PATCH` an unknown id → 404
- [ ] `POST` an invalid body (blank name) → 400 with field errors
- [ ] Frontend shows the server message, not a raw Dio dump

---

## Phase 2 — Reusable backend code

**Why:** stop repeating audit fields and page wrappers; set the patterns auth reuses.

Concepts:
- `@MappedSuperclass` for a shared `BaseEntity`
- Spring Data JPA Auditing (`@EnableJpaAuditing`, `@CreatedDate`, `@LastModifiedDate`)
- Generics: a reusable `PageResponse<T>` + a mapper from Spring's `Page<T>`

Tasks **(you)**:
- [ ] `BaseEntity` (`@MappedSuperclass`) holding `id`, `createdAt`, `updatedAt`, `version`
- [ ] Enable JPA auditing; drop the manual `Instant.now()` calls
- [ ] `PageResponse<T>` generic; a `Page<E>.toResponse { }` helper
- [ ] Migrate `ProductEntity` / `ProductPageResponse` onto the shared pieces
- [ ] (Optional) a Flyway migration if column defaults change

Acceptance:
- [ ] Products still work; `created_at` / `updated_at` set automatically
- [ ] `ProductPageResponse` replaced by `PageResponse<ProductResponse>`

---

## Phase 3 — Logging (both sides)

**Why:** you asked for a logging service; correlation IDs make backend+frontend logs line up.

Concepts (backend):
- SLF4J + Logback (already on the classpath via Spring Boot)
- MDC (mapped diagnostic context) for a per-request correlation ID
- A servlet `Filter` / `OncePerRequestFilter` that generates/propagates the ID
- Structured (JSON) log output; log levels per environment

Concepts (frontend):
- The `logger` package for leveled logs
- A Dio interceptor that generates a correlation ID header + logs request/response/error
- File logging via `path_provider` (rotating app log)
- (Later) crash reporting hook (Sentry is already stubbed in pubspec)

Tasks **(you)**:
- [ ] Backend: correlation-ID filter writing to MDC + response header
- [ ] Backend: logback config with the correlation ID in the pattern (or JSON encoder)
- [ ] Frontend: `AppLogger` wrapper around `logger`
- [ ] Frontend: Dio interceptor adds `X-Correlation-Id`, logs via `AppLogger`
- [ ] Frontend: write logs to a file the user/support can retrieve

Acceptance:
- [ ] One request shows the same correlation ID in backend logs and Flutter logs
- [ ] Errors are logged with context, not swallowed

---

## Phase 4 — Auth (signup / login / JWT / sessions)

**Why last:** it depends on the error contract, reusable base entities, and logging.

Concepts (backend):
- Spring Security architecture: filter chain, `SecurityFilterChain`, `AuthenticationManager`
- Password hashing with BCrypt (`PasswordEncoder`)
- Users table + Flyway migration; a `UserEntity` on `BaseEntity`
- Signup + login endpoints; DTO validation reusing Phase 1 error handling
- JWT: access token (short-lived) + refresh token (long-lived), signing keys
- A JWT auth filter that populates the `SecurityContext`
- Stateless session policy; CORS config lives here too
- Refresh-token storage + rotation (this is your "login sessions"): a `refresh_tokens` table, revoke on logout, rotate on refresh
- Method/endpoint authorization (`@PreAuthorize` or `authorizeHttpRequests`)

Concepts (frontend):
- Token storage in `flutter_secure_storage` (already a dependency)
- A Dio interceptor: attach `Authorization: Bearer`, catch 401, refresh, retry
- An `AuthBloc` (unauthenticated / authenticated / loading)
- `go_router` redirect guards based on auth state
- Handling refresh races (queue requests while refreshing)

Tasks **(you)** — we'll break this into sub-steps when we get here:
- [ ] Add Spring Security + JWT deps
- [ ] Users migration + `UserEntity` + repository
- [ ] `PasswordEncoder` bean (BCrypt)
- [ ] Signup + login endpoints returning tokens
- [ ] JWT service (issue/verify) + auth filter
- [ ] `SecurityFilterChain` (stateless, permit signup/login, secure the rest) + CORS
- [ ] Refresh endpoint + `refresh_tokens` table + rotation + logout/revoke
- [ ] Frontend token storage + auth interceptor + auto-refresh
- [ ] `AuthBloc` + go_router guards + login/signup screens

Acceptance:
- [ ] Signup hashes the password; duplicate email → 409 (reuses Phase 1)
- [ ] Login returns access + refresh tokens
- [ ] Protected endpoint rejects missing/expired token → 401
- [ ] Expired access token auto-refreshes transparently on the client
- [ ] Logout revokes the refresh token server-side

---

## After the foundation (POS/ERP backlog, for later)
- Roles/permissions (cashier vs manager vs admin)
- Categories, suppliers, stock movements, sales/orders, receipts
- Idempotency keys for sale creation
- Testing: `@DataJpaTest`, MockMvc, Testcontainers
- Profiles: `application-dev` / `application-prod`
- Rate limiting, request size limits, actuator/metrics
