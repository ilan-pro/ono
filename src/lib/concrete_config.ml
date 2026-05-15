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
  
let parse_json_to_symbolic symbolic_value symbolic_dimension =
  (* dimensions *)
  let width = symbolic_dimension |> member "largeur" |> to_int
  in
  let length = symbolic_dimension |> member "longueur" |> to_int
  in

  (* extraction des valeurs depuis "model" *)
  let values =
    symbolic_value
    |> member "model"
    |> to_list
    |> List.map (fun item ->
        item |> member "value" |> to_string |> int_of_string)
  in

  (* construction de alive *)
  let alive =
    values
    |> List.mapi (fun idx v ->
        let i = idx / width in
        let j = idx mod width in

        if v = 1 then Some (i, j)
        else None)
    |> List.filter_map Fun.id
  in

  { width; length; alive }


