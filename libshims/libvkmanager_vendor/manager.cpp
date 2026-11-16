/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <cstddef>

class VaultKeeperManager {
  public:
    static VaultKeeperManager* getInstance();
    int checkDataWritable();
    int read(int index, char* buffer, int* length);
    int destroy();
};

VaultKeeperManager* VaultKeeperManager::getInstance() {
    return nullptr;
}

int VaultKeeperManager::checkDataWritable() {
    return 0;
}

int VaultKeeperManager::read(int, char*, int*) {
    return 0;
}

int VaultKeeperManager::destroy() {
    return 0;
}
