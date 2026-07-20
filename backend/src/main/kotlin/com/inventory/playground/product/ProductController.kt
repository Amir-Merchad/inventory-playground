package com.inventory.playground.product

import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/api/products")
class ProductController(
    private val productService: ProductService
) {

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createProduct(
        @Valid @RequestBody request: CreateProductRequest
    ): ProductResponse {
        return productService.createProduct(request)
    }

    @GetMapping
    fun getProductsPage(
        @RequestParam(
            name = "q",
            required = false
        )
        query: String?,

        @RequestParam(
            defaultValue = "0"
        )
        page: Int,

        @RequestParam(
            defaultValue = "10"
        )
        size: Int
    ): ProductPageResponse {
        return productService.getProductsPage(
            query = query,
            page = page,
            size = size
        )
    }

    @PatchMapping
    @ResponseStatus(HttpStatus.OK)
    fun updateProduct(
        @Valid @RequestBody request: UpdateProductRequest
    ) : ProductResponse {
        return productService.updateProduct(request)
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteProduct(
        @PathVariable id: UUID
    ) {
        productService.deleteProduct(id)
    }
}