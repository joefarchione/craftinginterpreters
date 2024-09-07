(lang dune 3.16)

(name olox)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Joe Farchione")

(maintainers "Joe Farchione")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name olox)
 (synopsis "jlox in ocaml from Crafting Interpreters")
 ;(description "A longer description")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
