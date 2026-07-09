!(import! &self ../../src/chem_exp04.metta)

!(test (ligation-rule? (rich-rule lAB ligation A B AB None ABC)) True)
!(test (cleavage-rule? (rich-rule cABC1 cleavage ABC None AB C ABC)) True)
!(test (modification-rule? (rich-rule mAB modification AB None ABstar None ABC)) True)
!(test (rich-rule-reactant-b (rich-rule cABC1 cleavage ABC None AB C ABC)) None)
!(test (rich-rule-secondary (rich-rule cABC1 cleavage ABC None AB C ABC)) C)

!(test (structural-contains? ABC AB) True)
!(test (structural-contains? ABCstar ABC) True)
!(test (template-catalyzes? ABC A B AB) True)
!(test (template-catalyzes? ABC AB None ABstar) True)
!(test (rich-rule-template-catalyzed? (rich-rule lABC1 ligation AB C ABC None AB)) True)

!(test (exp04-rule-count) 20)
!(test (exp04-ligation-rule-count) 8)
!(test (exp04-cleavage-rule-count) 6)
!(test (exp04-modification-rule-count) 6)
!(test (exp04-rule-mix-ok?) True)
!(test (exp04-rule-pool-large-enough?) True)
!(test (exp04-has-all-template-types?) True)
!(test (exp04-derived-molecules) (AB AC AD BC BD CD ABC ABD ACD BCD))
!(test (exp04-modified-molecules) (ABstar BCstar ABCstar BCDstar ACstar CDstar))
!(test (exp04-run-long-enough?) True)
!(test (exp04-replenishment-policy)
       (food-replenishment (A B C D) floor 3 checked-each-tick True))
!(test (exp04-food-floor-ok?) True)
!(test (exp04-final-snapshot)
       (abundance-snapshot 56
         ((mol A 3) (mol B 3) (mol C 3) (mol D 3)
          (mol AB 6) (mol BC 6) (mol CD 4) (mol AC 3)
          (mol ABC 5) (mol BCD 4)
          (mol ABstar 2) (mol BCstar 2) (mol ABCstar 2) (mol BCDstar 1)
          (mol ACstar 1) (mol CDstar 1))))

!(test (exp04-closure-step-0) (A B C D))
!(test (exp04-closure-step-3)
       (A B C D AB BC CD AC ABC BCD ABstar BCstar ABCstar BCDstar ACstar CDstar))
!(test (exp04-prune-bound) 36)
!(test (exp04-maximal-prune-fixed-point-step) 3)
!(test (exp04-maximal-prune-converged?) True)
!(test (exp04-maximal-raf-size) 20)

!(test (exp04-food-generated-reactant? AB) True)
!(test (exp04-rule-food-generated? (rich-rule lABC1 ligation AB C ABC None AB)) True)
!(test (exp04-rule-food-generated? (rich-rule cABC1 cleavage ABC None AB C ABC)) True)
!(test (exp04-raf5-ra-ok?) True)
!(test (exp04-raf5-fg-ok?) True)
!(test (exp04-raf? (exp04-raf5-rules)) True)
!(test (exp04-raf-candidate)
       (raf-candidate exp04-raf5 size 5 status active
                      rules (exp04-raf5-rules)
                      maximal-source-size 20
                      pruning fixed-point-step-3
                      reflexively-autocatalytic True
                      food-generated True))
!(test (exp04-active-raf-count) 1)
!(test (exp04-spontaneous-raf-emerged?) True)
!(test (exp04-run-summary)
       (rich-run exp04-rich-56 seed-31 ticks 56 rules 20 food-floor 3
                 event-count 42 raf-status emerged))

!(test (exp04-reduction-sweep-id) exp04-reduction-sweep-20260708)
!(test (exp04-reduction-sweep-row-count) 24)
!(test (exp04-reduction-baseline-row)
       (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14))
!(test (exp04-reduction-sweep-row hand-designed none 4)
       (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
!(test (exp04-reduction-sweep-row mechanically-generated-template specific 4)
       (reduction-row mechanically-generated-template specific basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
!(test (exp04-reduction-sweep-row hand-designed shuffled 4)
       (reduction-row hand-designed shuffled basal-4 maximal-raf 10 core 3 events 53 diversity 16 catalyzed 39 basal 14))
!(test (exp04-reduction-baseline-positive?) True)
!(test (exp04-reduction-no-catalysis-zero?) True)
!(test (exp04-reduction-generated-specific-zero?) True)
!(test (exp04-reduction-shuffled-caveat?) True)
!(test (exp04-reduction-sweep-interpretation)
       (interpretation positive-inspectable-artifact
                       no-catalysis-controls raf-negative
                       shuffled-hand-designed-control raf-like-signal-remains
                       generated-specific-control raf-negative
                       claim unbiased-emergence-not-supported))
!(test (exp04-reduction-sweep-report-complete?) True)
