Require Import Category.Main.
Require Import Functor.Main.

(** The terminal object in category C is an object t such that for any object a, there is a unique arrow ! : a -> t. *)
Class Terminal (C : Category) : Type :=
{
  terminal : C;
  t_morph : ∀ (d : Obj), Hom d terminal;
  t_morph_unique : ∀ (d : Obj) (f g : Hom d terminal), f = g
}.

Arguments terminal {_} _.
Arguments t_morph {_} _ _.
Arguments t_morph_unique {_} _ _ _ _.

Coercion terminal : Terminal >-> Obj.

(** (The) terminal object is unique up to isomorphism. *)
Theorem Terminal_iso {C : Category} (T T' : Terminal C) : (T ≡ T')%morphism.
Proof.
  apply (Build_Isomorphism _ _ _ (t_morph _ _) (t_morph _ _)); apply t_morph_unique.
Qed.

(** The initial is the dual of the terminal object. *)
Definition Initial (C : Category) := Terminal (C ^op).
Existing Class Initial.