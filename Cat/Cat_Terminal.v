Require Import Category.Main.
Require Import Functor.Main.
Require Import Cat.Cat.
Require Import Basic_Cons.Terminal.
Require Import Archetypal.Discr.Discr.
Require Import NatTrans.NatTrans NatTrans.Func_Cat.

(** The unique functor to the terminal category. *)
Program Definition Functor_To_1_Cat (C' : Category) : Functor C' 1 :=
{|
  FO := fun x => tt;
  FA := fun a b f => tt;
  F_id := fun _ => eq_refl;
  F_compose := fun _ _ _ _ _ => eq_refl
|}.

(** Terminal category. *)
Program Instance Cat_Term : Terminal Cat :=
{
  terminal := 1%category;

  t_morph := fun x => Functor_To_1_Cat x
}.

Next Obligation. (* t_morph_unique *)
Proof.
  Func_eq_simpl;
  FunExt;
  match goal with
    [|- ?A = ?B] =>
    destruct A;
      destruct B end;
  trivial.
Qed.  

(** A functor from terminal category maps all arrows (any arrow is just the identity)
to the identity arrow. *)
Section From_Term_Cat.
  Context {C : Category} (F : Functor 1 C).

  Theorem From_Term_Cat : ∀ h, (F @_a tt tt h)%morphism = id.
  Proof.
    destruct h.
    change tt with (id 1 tt).
    apply F_id.
  Qed.

End From_Term_Cat.

(** Any two functors from a category to the terminal categoy are naturally isomorphic. *)
Program Definition Functor_To_1_Cat_Iso
        {C : Category}
        (F F' : Functor C 1)
  : (F ≡≡ F' ::> Func_Cat _ _)%morphism :=
{|
  iso_morphism :=
    {|
      Trans := fun _ => tt
    |};
  inverse_morphism :=
    {|
      Trans := fun _ => tt
    |}
|}.