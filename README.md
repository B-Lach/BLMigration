BLMigration
===========

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Manages blocks of code that need to run once on version updates in your application. This could be anything from data
normalization routines, "What's New In This Version" screens, or bug fixes.


Most of the contribution goes out to [MTMigration](https://github.com/mysterioustrousers/MTMigration) - This is just an updated Version written in Swift and available for all major platforms (iOS, tvOS, watchOS, macOS)

## Installation

BLMigration can be installed one of two ways:

* Add `github "B-Lach/BLMigration"` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md), import as necessary with: `import BLMigration`
* Clone the Repo and insert `Constants.swift` and `BLMigration.swift` to your project

## Usage

If you need a block that runs every time your application version changes, pass that block to
the `applicationUpdate(updateBlock: BLMigrationBlock)` method.

```swift
BLMigration.applicationUpdate {
	metrics.resetStats()           
}
```

If a block is specific to a version, use `migrate(version: String, migrationBlock: BLMigrationBlock)` and BLMigration will
ensure that the block of code is only ever run once for that version.

```swift
BLMigration.migrate(version: "1.0") {
	// Do what ever you want to do
}
```

You would want to run this code in your app delegate or similar.

Parallel methods for `migrate(build: String, migrationBlock: BLMigrationBlock)` are also available.

Because BLMigration inspects your *-info.plist file for your actual version number and keeps track of the last migration,
it will migrate all un-migrated blocks inbetween. For example, let's say you had the following migrations:

```swift
BLMigration.migrate(version: "0.9") {
	//0.9 migration logic
}

BLMigration.migrate(version: "1.0") {
	// 1.0 migration logic
}
```

If a user was at version `0.8`, skipped `0.9`, and upgraded to `1.0`, then both the `0.9` *and* `1.0` blocks would run.

For debugging/testing purposes, you can call `reset` to clear out the last migration BLMigration remembered, causing all
migrations to run from the beginning:

```swift
BLMigration.reset()
```

## Notes

BLMigration assumes version numbers are incremented in a logical way, i.e. `1.0.1` -> `1.0.2`, `1.1` -> `1.2`, etc.

Version numbers that are past the version specified in your app will not be run. For example, if your *-info.plist file
specifies `1.2` as the app's version number, and you attempt to migrate to `1.3`, the migration will not run.

Blocks are executed on the thread the migration is run on. Background/foreground situations should be considered accordingly.

## Contributing

This library does not handle some more intricate migration situations, if you come across intricate use cases from your own
app, please add it and submit a pull request. Be sure to add test cases.

## Contributors

- [Parker Wightman](https://github.com/pwightman) ([@parkerwightman](http://twitter.com/parkerwightman))
- [Good Samaritans](https://github.com/mysterioustrousers/MTMigration/contributors)
- [Hector Zarate](https://github.com/Hecktorzr)
- [Sandro Meier](https://github.com/fechu)
- [Benny Lach](https://github.com/B-Lach)