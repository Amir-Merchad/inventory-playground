package com.inventory.playground.common.error

import org.springframework.http.HttpStatus
import java.util.UUID

abstract class AppException(
    val status: HttpStatus,
    val code: String,
    message: String,
) : RuntimeException(message)

class ProductNotFoundException(id: UUID) : AppException(
    status = HttpStatus.NOT_FOUND,
    code = "PRODUCT_NOT_FOUND",
    message = "Product with ID $id not found",
)

class DuplicateSkuException(sku: String) : AppException(
    status = HttpStatus.CONFLICT,
    code = "DUPLICATE_SKU",
    message = "A product with SKU $sku already exists",
)

class ProductConflictException(id: UUID) : AppException(
    status = HttpStatus.CONFLICT,
    code = "PRODUCT_MODIFIED",
    message = "Product $id was modified by another transaction",
)