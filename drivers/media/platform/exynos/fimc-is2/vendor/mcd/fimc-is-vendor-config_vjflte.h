#ifndef FIMC_IS_VENDOR_CONFIG_VJFLTE_H
#define FIMC_IS_VENDOR_CONFIG_VJFLTE_H

#include "fimc-is-eeprom-rear-3p3_v001.h"

#define VENDER_PATH

#define CAMERA_SYSFS_V2

#define CAMERA_MODULE_ES_VERSION_REAR 'B'
#define CAL_MAP_ES_VERSION_REAR '1'
#define FIMC_IS_MAX_FW_BUFFER_SIZE (8 * 1024)

/* Sync with SUPPORT_GROUP_MIGRATION in HAL Side. */
/* #define CONFIG_SUPPORT_GROUP_MIGRATION_FOR_TDNR */
/* #define CONFIG_ENABLE_TDNR */

#endif /* FIMC_IS_VENDOR_CONFIG_VJFLTE_H */
