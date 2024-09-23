open Olox_lib
open Cmdliner

let prompt_t = Term.(const Interpreter.prompt $ const ())
let cmd_prompt = Cmd.v (Cmd.info "prompt") prompt_t

let filename =
  let doc = "interpret" in
  Arg.(value & pos 0 string "" & info [] ~docv:"MSG" ~doc)

let file_t = Term.(const Reader.interpret $filename)
let cmd_file = Cmd.v (Cmd.info "interpreter") file_t

let cmd =
  let doc = "Olox interpreter" in
  let info = Cmd.info "olox" ~version:"1.0" ~doc in
  Cmd.group info [cmd_prompt; cmd_file]

let main () = exit (Cmd.eval cmd)
let () = main ()

