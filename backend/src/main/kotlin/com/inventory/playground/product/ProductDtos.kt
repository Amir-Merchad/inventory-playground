package com.inventory.playground.product

import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size
import java.math.BigDecimal
import java.util.UUID

data class CreateProductRequest(

    @field:NotBlank(message = "Product name is required")
    @field:Size(
        max = 150,
        message = "Product name cannot exceed 150 characters"
    )
    val name: String,

    @field:NotBlank(message = "SKU is required")
    @field:Size(
        max = 50,
        message = "SKU cannot exceed 50 characters"
    )
    val sku: String,

    @field:DecimalMin(
        value = "0.00",
        inclusive = true,
        message = "Price cannot be negative"
    )
    val price: BigDecimal,

    @field:Min(
        value = 0,
        message = "Stock cannot be negative"
    )
    val stock: Int
)

data class UpdateProductRequest(

    val id: UUID,

    @field:NotBlank(message = "name is required")
    @field:Size(
        max = 150,
        message = "Product name cannot exceed 150 characters"
    )
    val name: String,

    @field:NotBlank(message = "SKU is required")
    @field:Size(
        max = 50,
        message = "SKU cannot exceed 50 characters"
    )
    val sku: String,

    @field:DecimalMin(
        value = "0.00",
        inclusive = true,
        message = "Price cannot be negative"
    )
    val price: BigDecimal,

    @field:Min(
        value = 0,
        message = "Stock cannot be negative"
    )
    val stock: Int,

    @field:Min(
        value = 0,
        message = "Version cannot be negative"
    )
    val version: Long,

)

data class ProductResponse(
    val id: UUID,
    val name: String,
    val sku: String,
    val price: BigDecimal,
    val stock: Int,
    val version: Long
)

data class ProductPageResponse(
    val items: List<ProductResponse>,
    val page: Int,
    val size: Int,
    val totalItems: Long,
    val totalPages: Int,
    val hasNext: Boolean
)