# exp01 planted ACS recovery

Purpose: validate the ACS/RAF-like detection seam on a planted case before making emergence claims.

The initial exp01 fixture embeds a two-rule planted catalytic set beside distractor reactions:

```text
rp0: Food + X --Z--> Y
rp1: Food + W --Y--> Z
```

The products `{Y, Z}` are also the cross-catalysts `{Z, Y}`, so the detector can recover a conservative `acs-candidate`. The first scanner enumerates all rule pairs in the four-rule planted fixture, marks only reciprocal product-as-catalyst closure as `active`, and keeps rejected distractor pairs explicit. A non-catalytic molecule cycle is still explicitly rejected. The ablation check now derives productivity from replayed PeTTa transition traces: baseline two-rule productivity has two trace events, removing one planted rule leaves one trace event, and the drop remains `1`.

Run:

```bash
scripts/run_exp01.sh
```

This is still a planted validation test, not an emergence result.
