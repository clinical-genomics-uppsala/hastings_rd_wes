# Pipeline harmonization notes

This repository is being aligned with the CGU Hydra pipeline layout described in
the bootstrap/harmonization plan.

## Added in this pass

- `config/site/example.local.yaml`
- `config/site/miarka.local.yaml`
- `config/site/marvin.local.yaml`
- `profiles/local/config.yaml`
- `containers/manifest.yaml`

The existing `config/config.miarka.yaml` and `profiles/miarka/config.yaml` remain
in place for compatibility while start scripts and cluster validation catch up.

## Current standard invocation target

```bash
snakemake \
  --profile profiles/slurm \
  --configfile config/config.yaml \
  --configfile config/site/marvin.local.yaml
```

For Miarka:

```bash
snakemake \
  --profile profiles/miarka \
  --configfile config/config.yaml \
  --configfile config/site/miarka.local.yaml
```

## Remaining refactor candidates

- Move remaining absolute reference paths out of `config/config.yaml`.
- Convert container references in `config/config.yaml` to `{{CONTAINER_DIR}}/*.sif`
  after cluster validation of the manifest.
- Keep `workflow/Snakefile` thin and split new local logic into
  `workflow/rules/*.smk`.
- Compare `workflow/scripts/create_peddy_fam.py`,
  `workflow/scripts/create_peddy_mqc_config.py`, and MultiQC sample-order helpers
  with other pipelines for possible migration to `hydra-genetics/report`.
