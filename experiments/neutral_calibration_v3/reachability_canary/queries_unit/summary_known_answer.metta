!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem-v3-speedup/src/chem_neutral_raf.metta)
!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem-v3-speedup/src/chem_neutral_ssa.metta)
; Direct known-answer check of neutral-ssa-raf-reachability-summary on a
; hand-written valid trajectory (independent of the SSA sampler):
; R1 @0.5, R2 @0.7 (001 consumed -> 0), R1 @1.25 (all closure positive).
; Expected: reachable True first-time 1.25.
!(neutral-ssa-raf-reachability-summary ((ssa-timed-transition index 0 time 0.5 event (ligation "lig:00:1" "00" "1" "001") before-counts (("0" 20) ("1" 20) ("00" 20) ("001" 0) ("0010" 0)) after-counts (("0" 20) ("1" 19) ("00" 19) ("001" 1) ("0010" 0))) (ssa-timed-transition index 1 time 0.7 event (ligation "lig:001:0" "001" "0" "0010") before-counts (("0" 20) ("1" 19) ("00" 19) ("001" 1) ("0010" 0)) after-counts (("0" 19) ("1" 19) ("00" 19) ("001" 0) ("0010" 1))) (ssa-timed-transition index 2 time 1.25 event (ligation "lig:00:1" "00" "1" "001") before-counts (("0" 19) ("1" 19) ("00" 19) ("001" 0) ("0010" 1)) after-counts (("0" 19) ("1" 18) ("00" 18) ("001" 1) ("0010" 1)))) ("lig:00:1" "lig:001:0") ("0010" "001" "0" "1" "00"))
; Truncated after R2 (closure member 001 = 0): expected reachable False censored.
!(neutral-ssa-raf-reachability-summary ((ssa-timed-transition index 0 time 0.5 event (ligation "lig:00:1" "00" "1" "001") before-counts (("0" 20) ("1" 20) ("00" 20) ("001" 0) ("0010" 0)) after-counts (("0" 20) ("1" 19) ("00" 19) ("001" 1) ("0010" 0))) (ssa-timed-transition index 1 time 0.7 event (ligation "lig:001:0" "001" "0" "0010") before-counts (("0" 20) ("1" 19) ("00" 19) ("001" 1) ("0010" 0)) after-counts (("0" 19) ("1" 19) ("00" 19) ("001" 0) ("0010" 1)))) ("lig:00:1" "lig:001:0") ("0010" "001" "0" "1" "00"))
; Only R1 fires: expected reachable False censored.
!(neutral-ssa-raf-reachability-summary ((ssa-timed-transition index 0 time 0.5 event (ligation "lig:00:1" "00" "1" "001") before-counts (("0" 20) ("1" 20) ("00" 20) ("001" 0) ("0010" 0)) after-counts (("0" 20) ("1" 19) ("00" 19) ("001" 1) ("0010" 0)))) ("lig:00:1" "lig:001:0") ("0010" "001" "0" "1" "00"))
