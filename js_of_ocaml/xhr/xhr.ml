open Js_of_ocaml

let xhr = XmlHttpRequest.create ()

let bind_callback_str_opt (xhr:XmlHttpRequest.xmlHttpRequest Js.t) callback =
  xhr##.onreadystatechange :=
    Js.wrap_callback
      (fun _ ->
        match xhr##.readyState with
        | XmlHttpRequest.DONE ->
          let response_text_opt =
            xhr##.responseText
            |> Js.Opt.to_option
            |> Option.map (Js.to_string) in
          callback response_text_opt
        | _ -> ()
      )

let () =
  bind_callback_str_opt xhr
    (function
      | None -> ()
      | Some s ->
        let text_node = Dom_html.document##createTextNode (Js.string s) in
        let p = Dom_html.document##createElement (Js.string "p") in
        let p = p##appendChild (text_node :> Dom.node Js.t) in
        let body_opt = Dom_html.document##querySelector (Js.string "body")
                       |> Js.Opt.to_option in
        match body_opt with
        | None -> ()
        | Some body -> ignore (body##appendChild (p))
    );
  xhr##_open (Js.string "GET") (Js.string "https://api.github.com/zen") Js._true;
  xhr##send (Js.null)
