open Js_of_ocaml

(* BUG : txt is not surrounded by p, but printed... *)
let display js_s =
  let text_node = Dom_html.document##createTextNode (js_s) in
  let p = Dom_html.document##createElement (Js.string "p") in
  let p = p##appendChild (text_node :> Dom.node Js.t) in
  let body_jsopt = Dom_html.document##querySelector (Js.string "body") in
  Js.Opt.iter body_jsopt (fun body -> ignore (body##appendChild (p)))

let () =
  let xhr = XmlHttpRequest.create () in
  xhr##.onload :=
    Dom.full_handler (fun xhr _ev ->
        let js_s_opt = xhr##.responseText in
        Js.Opt.iter js_s_opt (fun js_s -> Firebug.console##log js_s);
        Js.Opt.iter js_s_opt display;
        Js._true);
  xhr##_open (Js.string "GET") (Js.string "/file.txt") Js._true;
  xhr##send (Js.null)

(*
(** Other snippet working (and simpler). *)
let () =
  let xhr = XmlHttpRequest.create () in
  xhr##.onload :=
      Dom.full_handler (fun xhr _ev ->
         Firebug.console##log (Js.string "fly");
         Firebug.console##log (xhr##.responseText);
         Js._true);
  xhr##_open (Js.string "GET") (Js.string "/file.txt") Js._true;
  xhr##send (Js.null)
*)
