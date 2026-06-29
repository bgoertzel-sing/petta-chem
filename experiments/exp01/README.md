# exp01 planted ACS recovery

Purpose: validate the ACS/RAF-like detection seam on a planted case before making emergence claims.

The initial exp01 fixture embeds a two-rule planted catalytic set beside distractor reactions:

```text
rp0: Food + X --Z--> Y
rp1: Food + W --Y--> Z
```

The products `{Y, Z}` are also the cross-catalysts `{Y, Z}`, so the detector can recover a conservative `acs-candidate`. Distractor reactions and a non-catalytic molecule cycle are explicitly rejected. A first ablation check removes one planted rule and verifies productivity drops from `2` to `1`.

Run:

```bash
scripts/run_exp01.sh
```

This is still a planted validation test, not an emergence result.
