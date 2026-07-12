package com.inventory.playground.product

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.UUID

interface ProductRepository :
    JpaRepository<ProductEntity, UUID> {

    fun existsBySkuIgnoreCase(sku: String): Boolean

    @Query(
        """
        SELECT product
        FROM ProductEntity product
        WHERE
            LOWER(product.name) LIKE LOWER(
                CONCAT('%', :query, '%')
            )
            OR LOWER(product.sku) LIKE LOWER(
                CONCAT('%', :query, '%')
            )
        """
    )
    fun search(
        @Param("query") query: String,
        pageable: Pageable
    ): Page<ProductEntity>
}