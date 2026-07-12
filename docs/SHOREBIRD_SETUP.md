# Shorebird OTA updates — setup

The Shorebird CLI is installed locally at `~/.shorebird/bin/shorebird` (not
on PATH by default — either call it with the full path or add
`~/.shorebird/bin` to your PATH yourself).

These steps require your own Shorebird account, so they need to be run by
you, not by an assistant:

1. **Log in** (opens a browser to authenticate/create your account):
   ```
   ~/.shorebird/bin/shorebird login
   ```

2. **Register this app with Shorebird** (creates `shorebird.yaml` with your
   app's id):
   ```
   ~/.shorebird/bin/shorebird init
   ```

3. **Create the baseline release.** Patches apply on top of a release, so
   you need one before patches will do anything:
   ```
   ~/.shorebird/bin/shorebird release android
   ```
   This produces the APK you should actually distribute (e.g. via the
   website's download button) — a plain `flutter build apk` is **not**
   patchable by Shorebird, only builds made with `shorebird release` are.

4. **Generate a CI token** at https://console.shorebird.dev (account
   settings → API keys), then add it as a GitHub Actions secret named
   `SHOREBIRD_TOKEN` in this repo: Settings → Secrets and variables →
   Actions → New repository secret.

Once the secret is set, `.github/workflows/shorebird-patch.yml` runs on
every push to `main` that touches `lib/**`, `pubspec.yaml`, or `assets/**`,
and publishes a patch against the latest release — installs update
automatically the next time they check in with Shorebird's backend (on
app launch, roughly).

Re-run step 3 (`shorebird release android`) whenever you ship a change
Shorebird can't patch OTA — native code, plugin changes, or new assets
added to `pubspec.yaml`'s `assets:` list (the CLI will refuse to patch
these and tell you so).
