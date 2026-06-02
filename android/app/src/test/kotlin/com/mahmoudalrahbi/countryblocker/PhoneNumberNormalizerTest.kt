package com.mahmoudalrahbi.countryblocker

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Unit tests for CallBlockingService.normalizeForPrefixMatch.
 *
 * Regression coverage for the bug where numbers prefixed with `00` (international dial prefix)
 * were not blocked even when the country code was on the blocklist.
 *
 * The root cause: Case B prefix matching stripped `+` via `\\D` but left `00` intact,
 * so `"002438707037817".startsWith("243")` returned false.
 */
class PhoneNumberNormalizerTest {

    // ── Core normalization ────────────────────────────────────────────────────

    @Test
    fun `plus-prefixed number is stripped to pure digits`() {
        assertEquals("2438707037817", CallBlockingService.normalizeForPrefixMatch("+2438707037817"))
    }

    @Test
    fun `00-prefixed number strips the 00 international prefix`() {
        assertEquals("2438707037817", CallBlockingService.normalizeForPrefixMatch("002438707037817"))
    }

    @Test
    fun `plain digit number is unchanged`() {
        assertEquals("2438707037817", CallBlockingService.normalizeForPrefixMatch("2438707037817"))
    }

    @Test
    fun `number with internal spaces is normalized`() {
        assertEquals("2438707037817", CallBlockingService.normalizeForPrefixMatch("+243 870 703 7817"))
    }

    @Test
    fun `number with hyphens is normalized`() {
        assertEquals("2438707037817", CallBlockingService.normalizeForPrefixMatch("+243-870-703-7817"))
    }

    // ── Regression: DRC (+243) blocked, number arrives as +2438707037817 ─────

    @Test
    fun `plus-prefixed DRC number matches blocked code 243`() {
        val clean = CallBlockingService.normalizeForPrefixMatch("+2438707037817")
        assertTrue("Expected '$clean' to start with '243'", clean.startsWith("243"))
    }

    @Test
    fun `00-prefixed DRC number matches blocked code 243`() {
        val clean = CallBlockingService.normalizeForPrefixMatch("002438707037817")
        assertTrue("Expected '$clean' to start with '243'", clean.startsWith("243"))
    }

    // ── Other country codes ───────────────────────────────────────────────────

    @Test
    fun `US plus-prefixed number matches blocked code 1`() {
        val clean = CallBlockingService.normalizeForPrefixMatch("+15551234567")
        assertTrue(clean.startsWith("1"))
    }

    @Test
    fun `UAE 00-prefixed number matches blocked code 971`() {
        val clean = CallBlockingService.normalizeForPrefixMatch("00971501234567")
        assertTrue("Expected '$clean' to start with '971'", clean.startsWith("971"))
    }

    @Test
    fun `number starting with 00 that is not a prefix strips correctly`() {
        // 0011... (Australia's exit code is 0011, but we still strip leading 00)
        val clean = CallBlockingService.normalizeForPrefixMatch("001112345678")
        assertEquals("1112345678", clean)
    }
}
