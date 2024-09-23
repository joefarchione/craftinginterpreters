open Core

let create_test_file (directory:string)  = 
  let imports = 
"open Core
open Olox_lib
" in 

  let test_call (path:string) = 
    let name = 
      String.split ~on:'/' path 
      |> (fun lst -> List.nth lst ((List.length lst) - 1)) in 
    match name with 
    | Some (n) -> 
      Printf.sprintf 
"
let%%expect_test \"%s\" = 
  let filepath = \"%s\" in 
  Reader.interpret filepath;
;;
"
      n path
    | None -> failwith "couldn't find filename" in 

  let file_contents (tests: string array) =
    Array.map tests ~f:(fun path -> test_call path) 
    |> Array.fold ~init:imports ~f:(^) in 

  let write (filepath:string) (contents:string) = 
    Out_channel.write_all filepath ~data:contents in

  let test_paths directory = 
    let files = Sys_unix.readdir directory in 
    let paths = Array.map files ~f:(fun file -> directory ^ "/" ^ file) in 
    paths in 

  let root_test = "/home/joefarchione/Projects/crafting_interpreters/olox/test"  in
  let dir_path = root_test ^ "/data/" ^ directory in 
  test_paths dir_path
  |> file_contents
  |> write (root_test ^ "/" ^ directory ^ ".ml")

let%test "gen_all" = 
  let directories = Sys_unix.readdir "/home/joefarchione/Projects/crafting_interpreters/olox/test/data"  in 
  Array.iter directories ~f:create_test_file;
  true

