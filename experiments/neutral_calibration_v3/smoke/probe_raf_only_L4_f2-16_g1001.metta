!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem/src/chem_neutral_raf.metta)
!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem/src/chem_neutral_ssa.metta)
!(let $food ("0" "1" "00" "01" "10" "11") (let $molecules (neutral-ssa-binary-polymers 4) (let $reactions (neutral-ssa-binary-reactions 4) (let $catalysis (neutral-ssa-sample-catalysis 1001 16 $molecules $reactions) (neutral-raf-list-length (neutral-raf-maximal-reactions $food (neutral-ssa-raf-reactions $reactions) (neutral-ssa-raf-catalysis $catalysis)))))))
