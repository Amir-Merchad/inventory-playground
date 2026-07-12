CREATE TABLE products (
                          id UUID PRIMARY KEY,
                          name VARCHAR(150) NOT NULL,
                          sku VARCHAR(50) NOT NULL UNIQUE,
                          price NUMERIC(12, 2) NOT NULL,
                          stock INTEGER NOT NULL DEFAULT 0,
                          version BIGINT NOT NULL DEFAULT 0,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT chk_products_name_not_blank
                              CHECK (length(trim(name)) > 0),

                          CONSTRAINT chk_products_price_non_negative
                              CHECK (price >= 0),

                          CONSTRAINT chk_products_stock_non_negative
                              CHECK (stock >= 0)
);