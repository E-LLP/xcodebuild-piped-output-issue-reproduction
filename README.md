# XcodeBuild hanging reproduction sample

This is a fork of the awesome [https://github.com/ably/ably-ios](https://github.com/ably/ably-ios)
project.

**This project have only one purpose, to demonstrate an `xcodebuild` issue**.

*You should NOT use this repository for anything else, it's not a maintained
fork of the original repository. It just happens to be that this project
was perfect for reproducing this Xcode issue.*


## What's the Xcode (`xcodebuild`) bug/issue?

**TL;DR;** `xcodebuild ... test`'s test logs output is delayed until
all of the tests finish.

It seems that, for some projects, `xcodebuild` (tested with Xcode 7.2.1 's Command Line Tools),
when running *tests*, **will only show the test results once the tests are finished**,
if the output of `xcodebuild` is piped into another tool.

In other words you won't see a real-time output as you'd expect.
If you don't pipe the output of `xcodebuild` to another tool
you'll see the test log outputs right away, as `xcodebuild` executes the
tests one-by-one. But if you pipe the output into another tool
then `xcodebuild` will "dump" it's test log outputs in one batch,
after every test is finished.

We successfully reproduced the issue on multiple Macs, using this repository, 100% of the times.

This issue is most likely related to running tests on **library projects only**,
and does not affect app projects.


## How to run the reproduction

It's quite simple: just pipe the output of `xcodebuild ... test` into any tool.
You can use this project to reproduce the issue.

Step by step:

* `git clone --recursive https://github.com/bitrise-samples/ably-ios.git`
* `cd ably-ios`
* `pod install`
* `xcodebuild -workspace ably.xcworkspace -scheme Ably clean build test -destination 'platform=iOS Simulator,name=iPhone 4s,OS=latest' | tee /dev/null`

*Note: if you have the [Bitrise CLI](https://www.bitrise.io/cli) installed,
then you can run: `bitrise run test` in the repository root,
instead of manually calling `pod install` and running `xcodebuild`.*

You should see a real-time output up until the line:

`Touch ... ablySpec.xctest`

**There will be no more output until the tests finish** (should finish in about 1-2 minutes).
Once the tests are finished you'll see the whole output, just like you'd expect it,
but you'll see no outputs after `Touch ... ablySpec.xctest` until all the tests
finish.

If you remove the ` | tee /dev/null` from the end of the command
you'll see the real-time log output of the tests.


## License

Copyright (c) 2015 Ably Real-time Ltd, Licensed under the Apache License, Version 2.0.  Refer to [LICENSE](LICENSE) for the license terms.
