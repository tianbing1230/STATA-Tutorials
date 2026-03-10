# Public Release Checklist

Use this checklist before switching the repository to public on GitHub.

## Content and Permissions

- [ ] I have rights to publish all tutorial PDFs in this repository.
- [ ] I have rights to publish all dataset files currently included in the repository.
- [ ] I confirmed no personally identifiable or restricted information is included.
- [ ] I confirmed no sensitive files remain in git history (not just in the latest commit).

## Repository Quality

- [ ] `README.md` explains purpose, structure, and how to run tutorial scripts.
- [ ] `.do` files do not contain personal absolute paths.
- [ ] Temporary files and generated outputs are excluded by `.gitignore`.
- [ ] The public repository contains PDF lecture files only (no unintended source artifacts).
- [ ] If LaTeX source files are intentionally excluded, this is clearly stated in `README.md`.

## Optional but Recommended

- [ ] Add a `LICENSE` file.
- [ ] Add a short citation/attribution note for reused external materials.
- [ ] Add a `CHANGELOG.md` if this repo will be updated over time.
- [ ] Create a lightweight public version if some files cannot be openly shared.
