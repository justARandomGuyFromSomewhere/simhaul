# Online APK Build Guide (GitHub + GitHub Actions)

## 1. Upload Project to GitHub
1. Extract `haul_calc_flutter_app.zip`.
2. Create a new repository on GitHub (for example: `haul-calc-app`).
3. Upload the contents of the `haul_calc_app` folder to the repository (including `.github/workflows/build_apk.yml`).

## 2. Run the Build Workflow
1. Go to the **Actions** tab in your GitHub repository.
2. Select **Build Flutter Release APK**.
3. Click **Run workflow** (or push to `main` / `master`).

## 3. Download and Install APK
1. Wait for the workflow run to complete with a green checkmark.
2. Open the completed run and scroll down to **Artifacts**.
3. Download **`haul-calc-release-apk`**, extract `app-release.apk`, transfer it to your Android phone, and install it.
