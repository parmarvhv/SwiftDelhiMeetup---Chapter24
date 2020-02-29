# AppExtension-ios

# Summary

## Purpose

Briefly summarize the purpose of the app, who it’s intended for (target audience) and what it does.

## Deployment Targets

Identify the devices the app is intended to support (iOS for iPhone or iPad, Watch, or tvOS), along with any specific versions or limitations.

# Set­up and Configuration

## Toolset standard

Specify the toolset that was used to develop the project, including the Xcode version and language (Swift, Objective­-C, C/C++). It is not necessary to specify the language used for dependent libraries, but should clarify if the project provides a framework or library.

## Build Schemes and Configurations standard

Itemize the Build Configurations in the project (e.g., Debug, Distribution) and specify the host environments they point to for providing corresponding web services. Also specify the purpose of the build, what it is used for, and who it’s intended for (Development, QA, Beta Testing, Store Submission, etc.).

## Enabled Capabilities optional

If relevant, identify which service entitlements are being used by the app, such as Push Notifications, Apple Pay, In­-App Purchases, Background Modes, iCloud, etc.

  

## Dependency Management standard

Indicate how dependencies are managed in the project (Cocoapods, Carthage, or Manual) and provide instructions or guidance on how a developer might add or remove any dependencies along with a guideline for which management technique should be used.

  

# Project Architecture

## User Interaction Flow

Outline the basic flow of the application experience, highlighting any noteworthy features and functionality.

## Application Architecture

You should identify the Views, View Controllers, and Storyboards that support the above user flows, and when appropriate, also describe any design patterns that are used to implement application behavior.

## Persistent Storage optional

What mechanisms or technologies does the application use to support persistent data storage (Core Data, Realm, etc.), as well as any files that might be saved to the Cache or Documents directories.

## Remote Services optional

Specify all of the remote web services that are used by the application and provide a link to their documentation if available. It is also helpful to identify the networking service architecture, and also clarify the relationship between the remote service to any persisted or cached data if applicable.

# Resources and Frameworks

## Bundled Resources optional

Identify any Fonts, Audio, Video and any other sources that are included in the application bundle.

## Native Cocoa Frameworks

Outline any native frameworks that were included (such as System Configuration, CoreBluetooth, etc). It is not necessary to specify Foundation or UIKit as they are assumed. As such, it makes sense to begin with “In addition to the default native frameworks, this project makes use of...” for clarity.

## Third­ Party Libraries and Frameworks

Identify all third­-party libraries and frameworks used along with a short one­ sentence description of the purpose they serve. You should also link to their hosted source if possible so that users can reference the full documentation. These should be grouped as to how their dependency is managed since that is largely how they would appear within the project.

  

# System Integrations

## Analytics optional

Identify any analytics platforms that are used along with a list of tracked events.

  

## Automated Tests optional

Identify the purpose and coverage of any Unit Tests or UI Tests along with any third­-party frameworks that might be used to support these tests.

  

## Connected Hardware optional

If there is any companion hardware, identify the connection technology used (BLE, Wi­Fi, etc.) and link to any relevant documentation for the device. Also provide a brief synopsis of the purpose of the hardware and its role within the platform ecosystem.

================================================================================  
  

CHEERS!
