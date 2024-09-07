(* open Olox_lib *)

(* let rec run_prompt () = 
  let line = In_channel.input_line In_channel.stdin in 
  match line with 
  | None -> run_prompt ()
  | Some text -> (
    ignore (Scanner.scan_text text); 
    run_prompt ())


let () = 
  match (Array.length Sys.argv) with
  | 1 -> run_prompt ()
  | 2 -> Scanner.scan_text Sys.argv.(1)
  | _ -> failwith "not implemented"
 *)

let () = Printf.printf "Hello World!"