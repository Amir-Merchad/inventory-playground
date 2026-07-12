package com.inventory.playground.product

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import java.time.Instant
import java.util.UUID

@Service
class ProductService(
    private val productRepository: ProductRepository
) {

    @Transactional
    fun createProduct(
        request: CreateProductRequest
    ): ProductResponse {
        val normalizedName = request.name.trim()
        val normalizedSku = request.sku.trim().uppercase()

        if (productRepository.existsBySkuIgnoreCase(normalizedSku)) {
            throw IllegalArgumentException(
                "A product with SKU $normalizedSku already exists"
            )
        }

        val product = ProductEntity(
            id = UUID.randomUUID(),
            name = normalizedName,
            sku = normalizedSku,
            price = request.price,
            stock = request.stock,
            createdAt = Instant.now(),
            updatedAt = Instant.now()
        )

        val savedProduct = productRepository.save(product)

        return savedProduct.toResponse()
    }

    @Transactional(readOnly = true)
    fun getAllProducts(): List<ProductResponse> {
        val products = productRepository.findAll()
        return products.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun getProductsPage(
        query: String?,
        page: Int,
        size: Int
    ): ProductPageResponse {
        require(page >= 0) {
            "Page cannot be negative"
        }

        require(size in 1..100) {
            "Page size must be between 1 and 100"
        }

        val normalizedQuery = query?.trim().orEmpty()

        val pageable = PageRequest.of(
            page,
            size,
            Sort.by(
                Sort.Order.asc("name"),
                Sort.Order.asc("id")
            )
        )

        val productPage = if (normalizedQuery.isBlank()) {
            productRepository.findAll(pageable)
        } else {
            productRepository.search(
                normalizedQuery,
                pageable
            )
        }

        return ProductPageResponse(
            items = productPage.content.map {
                it.toResponse()
            },
            page = productPage.number,
            size = productPage.size,
            totalItems = productPage.totalElements,
            totalPages = productPage.totalPages,
            hasNext = productPage.hasNext()
        )
    }

    @Transactional
    fun updateProduct(
        request: UpdateProductRequest
    ): ProductResponse {
        val product = productRepository.findById(request.id)
            .orElseThrow {
                IllegalArgumentException(
                    "Product with ID ${request.id} not found"
                )
            }

        if (product.version != request.version) {
            throw IllegalArgumentException(
                "Product with ID ${request.id} has been modified by another transaction"
            )
        }

        val normalizedName = request.name.trim()
        val normalizedSku = request.sku.trim().uppercase()

        if (
            !product.sku.equals(normalizedSku, ignoreCase = true) &&
            productRepository.existsBySkuIgnoreCase(normalizedSku)
        ) {
            throw IllegalArgumentException(
                "A product with SKU $normalizedSku already exists"
            )
        }

        product.name = normalizedName
        product.sku = normalizedSku
        product.price = request.price
        product.stock = request.stock
        product.version = request.version + 1
        product.updatedAt = Instant.now()

        productRepository.flush()

        return product.toResponse()
    }

    private fun ProductEntity.toResponse(): ProductResponse {
        return ProductResponse(
            id = id,
            name = name,
            sku = sku,
            price = price,
            stock = stock,
            version = version
        )
    }
}