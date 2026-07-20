package com.inventory.playground.common.logging

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.util.UUID

/**
 * Runs once per request, before controllers.
 *
 * - Reuses an incoming `X-Request-Id` header (sent by the Flutter client) or
 *   generates a fresh UUID if there isn't one.
 * - Puts it in the SLF4J MDC under "requestId" so every log line during this
 *   request is tagged with it (see logging.pattern.level in application.properties).
 * - Echoes it back in the response header so the client can correlate too.
 * - Logs a single access line with method, path, status and duration.
 *
 * MDC is thread-local, so it MUST be cleared in `finally` or the id would leak
 * into the next request handled by the same thread.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
class CorrelationIdFilter : OncePerRequestFilter() {

    private val log = LoggerFactory.getLogger(CorrelationIdFilter::class.java)

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain,
    ) {
        val requestId = request.getHeader(HEADER)?.takeIf { it.isNotBlank() }
            ?: UUID.randomUUID().toString()

        MDC.put(MDC_KEY, requestId)
        response.setHeader(HEADER, requestId)

        val startedAt = System.currentTimeMillis()
        try {
            filterChain.doFilter(request, response)
        } finally {
            val durationMs = System.currentTimeMillis() - startedAt
            log.info(
                "{} {} -> {} ({} ms)",
                request.method,
                request.requestURI,
                response.status,
                durationMs,
            )
            MDC.remove(MDC_KEY)
        }
    }

    companion object {
        const val HEADER = "X-Request-Id"
        const val MDC_KEY = "requestId"
    }
}
