; Catalysis facts as DATA atoms in the space (not = rules)
!(add-atom &self (catalyzes ABC lAB))
!(add-atom &self (catalyzes CD lBCD2))

; Total closed-world predicate: collapse a match to a list, test non-empty.
(= (catalyzes? $m $rid)
   (if (== (collapse (match &self (catalyzes $m $rid) matched)) ())
       False
       True))

!(test (catalyzes? ABC lAB) True)
!(test (catalyzes? CD lBCD2) True)
!(test (catalyzes? XX yy) False)
!(test (catalyzes? ABC lBCD2) False)
