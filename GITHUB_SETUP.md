# JMA Finance iOS — GitHub Ready

This folder is ready to upload to a GitHub repository.

## What is already included

- Native SwiftUI iPhone app
- 4-digit PIN
- Income and Expenses
- Current Balance
- Day / Week / Month summaries
- Transaction History
- Reports
- Settings / Change PIN
- Euro currency
- Local storage
- GitHub Actions build check
- GitHub Actions signed IPA + TestFlight workflow

## Easiest first test on GitHub

1. Create a new empty GitHub repository.
2. Upload **all files and folders inside this project** to the repository root.
   Make sure these are visible at the top level:
   - `JMAFinance.xcodeproj`
   - `JMAFinance/`
   - `.github/`
3. Open the repository's **Actions** tab.
4. Select **iOS Build Check**.
5. Choose **Run workflow**.
6. A green check means GitHub successfully compiled the iPhone app.

This first build does NOT need an Apple Developer certificate because it builds for the iPhone Simulator.

## To create a real signed IPA and send it to TestFlight

Apple signing credentials are required. In GitHub:

**Repository → Settings → Secrets and variables → Actions → New repository secret**

Add these seven secrets:

1. `APPLE_TEAM_ID`
   - Your Apple Developer Team ID.

2. `APPLE_DISTRIBUTION_CERTIFICATE_BASE64`
   - Your Apple Distribution `.p12` certificate encoded as Base64.

3. `APPLE_DISTRIBUTION_CERTIFICATE_PASSWORD`
   - Password used when exporting the `.p12`.

4. `APPLE_PROVISIONING_PROFILE_BASE64`
   - App Store provisioning profile (`.mobileprovision`) encoded as Base64.
   - It must match bundle ID: `com.jma.finance`.

5. `ASC_KEY_ID`
   - App Store Connect API Key ID.

6. `ASC_ISSUER_ID`
   - App Store Connect API Issuer ID.

7. `ASC_PRIVATE_KEY`
   - Full text of your App Store Connect `AuthKey_XXXXXXXXXX.p8` file.

Then:

1. Go to **Actions**.
2. Open **Build IPA and Upload to TestFlight**.
3. Click **Run workflow**.
4. GitHub will:
   - compile JMA Finance,
   - sign it,
   - create an `.ipa`,
   - save the IPA as a GitHub Actions artifact,
   - upload it to App Store Connect/TestFlight.

## Important Apple setup

Before the TestFlight workflow can succeed, Apple must already have:

- an Apple Developer Program membership,
- an App ID for bundle ID `com.jma.finance`,
- an App Store distribution provisioning profile for that App ID,
- an Apple Distribution certificate,
- an App Store Connect app record for the same bundle ID,
- an App Store Connect API key with suitable access.

## Security

Never upload certificates, passwords, provisioning profiles, or `.p8` keys as normal repository files.
Put them only in GitHub Actions **Secrets**.
