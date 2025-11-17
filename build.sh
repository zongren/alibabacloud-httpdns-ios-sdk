#!/bin/sh
set -e

FRAMEWORK_NAME="AlicloudHTTPDNS"  # Must match the name in podspec and Xcode scheme
CONFIGURATION="Release"
OUTPUT_DIR="$(pwd)/BuildOutput"

# Clean previous builds
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Build for iOS Devices (arm64)
xcodebuild archive \
  -workspace "${FRAMEWORK_NAME}.xcworkspace" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration "${CONFIGURATION}" \
  -destination "generic/platform=iOS" \
  -archivePath "${OUTPUT_DIR}/${FRAMEWORK_NAME}-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SUPPORTS_MACCATALYST=NO \
  HEADER_SEARCH_PATHS='$(inherited) $(SRCROOT)/AlicloudHttpDNS'

# Build for iOS Simulators (x86_64 + arm64)
xcodebuild archive \
  -workspace "${FRAMEWORK_NAME}.xcworkspace" \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration "${CONFIGURATION}" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${OUTPUT_DIR}/${FRAMEWORK_NAME}-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SUPPORTS_MACCATALYST=NO \
  HEADER_SEARCH_PATHS='$(inherited) $(SRCROOT)/AlicloudHttpDNS'

# Create XCFramework
xcodebuild -create-xcframework \
  -framework "${OUTPUT_DIR}/${FRAMEWORK_NAME}-iOS.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${OUTPUT_DIR}/${FRAMEWORK_NAME}-Simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"
