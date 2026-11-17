/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

int getStatus(unsigned int mode __attribute__((unused)), int timeout_ms __attribute__((unused))) {
    // The following return emulates "engmode service is not present".
    return 0xd0270010;
}
