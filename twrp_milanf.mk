#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP Device Tree Generator
# Copyright (C) 2019-Present A-Team Digital Solutions
# Copyright (C) 2024 sosRR
#

# Inherit Common Android Stuff
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit Milanf Stuff
$(call inherit-product, device/motorola/milanf/device.mk)

# Inherit TWRP Stuff
$(call inherit-product, vendor/twrp/config/common.mk)

# Device Identifiers
PRODUCT_NAME := twrp_milanf
PRODUCT_DEVICE := milanf
PRODUCT_MANUFACTURER := Motorola
PRODUCT_BRAND := Moto_G
PRODUCT_MODEL := XT2215
PRODUCT_RELEASE_NAME := Moto G Sylus 5G 2022

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="milanf_g-user 13 T2SDS33.75-38-1-3-30 819dd2-ff9246 release-keys"

BUILD_FINGERPRINT := motorola/milanf_g/milanf:13/T2SDS33.75-38-1-3-30/819dd2-ff9246:user/release-keys