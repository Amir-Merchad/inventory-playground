package com.inventory.playground.product

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import jakarta.persistence.Version
import java.math.BigDecimal
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "products")
class ProductEntity(

    @Id
    val id: UUID,

    @Column(nullable = false, length = 150)
    var name: String,

    @Column(nullable = false, unique = true, length = 50)
    var sku: String,

    @Column(nullable = false, precision = 12, scale = 2)
    var price: BigDecimal,

    @Column(nullable = false)
    var stock: Int,

    @Version
    @Column(nullable = false)
    var version: Long = 0,

    @Column(name = "created_at", nullable = false)
    val createdAt: Instant = Instant.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: Instant = Instant.now()
)