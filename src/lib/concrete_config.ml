open Yojson.Safe.Util

type config = { width : int; length : int; alive : (int * int) list }

(* la config json *)
let global_config : config option ref = ref None

let parse_config js =
  (* member permet de retourner la valeur associé à la clée, ici largeur renvoie 3 si largeur:3 *)
  (* to_int vient également du yojson *)
  let width = js |> member "largeur" |> to_int in
  let length = js |> member "longueur" |> to_int in
  let alive =
    (* to_list permet de transformer le tableau json en Ocaml de JSON *)
    (* la liste est en liste Yojson.Safe.t et plus en représentation textuelle *)
    (* ensuite on transfrome la liste yojson... en (int*int) list *)
    js |> member "alive" |> to_list
    |> List.map (fun couple ->
        match to_list couple with
        (* le couple n'est pas encore en type yojson car c une liste double donc
                            on refait un to_list sur chaque pair du tableau *)
        | [ x; y ] -> (to_int x, to_int y)
        | _ -> failwith "Invalid format")
  in
  { width; length; alive }

(* lire les balises *)
let read_xml_values xml_string =
  let re = Str.regexp "<input>[ \n\t\r]*\\([01]\\)[ \n\t\r]*</input>" in

  let rec loop pos acc =
    try
      ignore (Str.search_forward re xml_string pos);

      let v =
        Str.matched_group 1 xml_string
        |> int_of_string
      in

      loop (Str.match_end ()) (v :: acc)

    with Not_found ->
      List.rev acc
  in

  loop 0 []
  
let parse_xml_to_json xml js =
  (* largeur / longueur depuis le JSON *)
  let width = js |> member "largeur" |> to_int in
  let length = js |> member "longueur" |> to_int in

  (* liste des 0/1 *)
  let values = read_xml_values xml in

  (* construction de alive *)
  let alive =
    values
    |> List.mapi (fun idx v ->
           let i = idx / width in
           let j = idx mod width in

           if v = 1 then Some (i, j)
           else None)
    |> List.filter_map (fun x -> x)
  in

  { width; length; alive }


