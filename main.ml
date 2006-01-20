let parse () =
  let lexbuf = Lexing.from_channel stdin in
  try Parser.prog Lexer.token lexbuf
  with Parsing.Parse_error ->
    let i = lexbuf.Lexing.lex_start_p.Lexing.pos_cnum in
    failwith (Format.sprintf "Syntax error at char %i" i)

let infer (e,t) = 
  let s = Mtt.infer Mtt.Env.empty e t () in
  Printf.eprintf "Inferred\n"; flush stderr;
  Format.fprintf Format.std_formatter "inferred input:%a@." Ta.print (Ta.normalize s)

let main () =
  let prog = Syntax.parse (parse ()) in
  Printf.eprintf "Parsed\n"; flush stderr;
  List.iter infer prog

let () = 
  try main ()
  with exn -> Printf.eprintf "Error:\n%s\n" (Printexc.to_string exn); exit 2
