# Pipeline harmonization notes

This repository is being aligned with the CGU Hydra pipeline layout described in
the bootstrap/harmonization plan.

## Added in this pass

- `profiles/local/config.yaml`
- `containers/manifest.yaml`
- `workflow/manifest.yaml`

The existing `config/config.miarka.yaml` and `profiles/miarka/config.yaml` remain
in place for compatibility while start scripts and cluster validation catch up.

## Current workflow target

The main workflow entrypoint is `workflow/Snakefile`. Its local rules, hydra
modules, and script candidates are described in `workflow/manifest.yaml`.

## Remaining refactor candidates

- Move remaining absolute reference paths behind a common `cgu/library` layout
  so site config only needs the installation parent and runtime resources.
- Convert container references in `config/config.yaml` to `{{CONTAINER_DIR}}/*.sif`
  after cluster validation of the manifest.
- Keep `workflow/Snakefile` thin and split new local logic into
  `workflow/rules/*.smk`.
- Compare `workflow/scripts/create_peddy_fam.py`,
  `workflow/scripts/create_peddy_mqc_config.py`, and MultiQC sample-order helpers
  with other pipelines for possible migration to `hydra-genetics/report`.
