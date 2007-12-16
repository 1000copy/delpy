'''The first application of lisp
'''
'''2001 . 12 .3
'''author : sanrex
'''
'''dfadsfd == t2

(setq a (nth (load (constr (homedir)"ver.txt" )) 1))
(setq count (nth a 1))
(setq site (nth a 2))
(setq dir (nth a 3))
(setq fileset (nth a 4))
(setq tdir (nth a 5))
(if (eq tdir "") (setq tdir (homedir)))
(setq tfileset (nth a 6))
(print tfileset)
(setq i 0)
(downfile    site    "fileName"    "d:\f.txt")

