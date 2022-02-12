(** Continuation passing style (CPS) simple example
  * Here are discussed possible interests of this programming style
  * https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491
  * posts of zapashcanon, Chet_Murthy and ivg are of great value
  * to cite Chet_Murthy
  * "if you’re a journeyman programmer, then CPS can be viewed as a generalization of the “technique of accumulating parameters”. Well, actually “CPS + defunctionalization”."
  * zapashcanon details how to implement it brainlessly
*)

(** Dummy example on list, even if an mere accumulator would work *)
let sum l =
  let rec sum l k =
    match l with
    | [] -> k 0
    | h :: tl -> sum tl ((+) (k h))
  in
  sum l (fun x -> x)

let%test _ = sum [1;2;3;4;5] = 15

(** Example on a binarry tree to show the interest of the style *)
type 'a bin_tree =
  | Empty
  | Node of ('a * 'a bin_tree * 'a bin_tree)

(** Beware : it looks like inserting side effects inside modifies heavily how
  * compiler optimisations are performed, thus leading to a crazy number of
  * function calls even for a small tree like this (hundreds for tree below)
*)
let height t =
  let rec height t k =
    match t with
    | Empty -> k 0
    | Node (_,l,r) ->
        height l (fun lh ->
        height r (fun rh ->
        k (1 + max lh rh)))
  in
  height t (fun x -> x)

let%test _ =
  let tree = Node (1, Empty, Node(2, Node (3, Empty, Empty), Empty)) in
  height tree = 3

let%test _ =
  let tree = Node (1, Empty, Node(2, Node (3, Empty, Empty), Node (1, Empty, Node(2, Node (3, Empty, Empty), Empty)))) in
  height tree = 5
