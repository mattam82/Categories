Require Import Category.Main.
Require Import Functor.Functor.
Require Import Functor.Functor_Ops.

Section Functor_Properties.
  Context {C C' : Category} (F : Functor C C').

  Definition Injective_Func := ∀ (c c' : Obj), F _o c = F _o c' → c = c'.

  Definition Essentially_Injective_Func := ∀ (c c' : Obj), F _o c = F _o c' → c ≡ c'.
  
  Definition Surjective_Func := ∀ (c : Obj), {c' : Obj | F _o c' = c}.

  Definition Essentially_Surjective_Func := ∀ (c : Obj), {c' : Obj & F _o c' ≡ c}.
  
  Definition Faithful_Func := ∀ (c c' : Obj) (h h' : Hom c c'), F _a _ _ h = F _a _ _ h' → h = h'.
  
  Definition Full_Func := ∀ (c1 c2 : Obj) (h' : Hom (F _o c1) (F _o c2)), {h : Hom c1 c2 | F _a _ _ h = h'}.

  Theorem Fully_Faithful_Essentially_Injective : Faithful_Func → Full_Func → Essentially_Injective_Func.
  Proof.
    intros F_Faithful F_Full c c' H.
    destruct (F_Full _ _ (
                       match H in (_ = Y) return Hom (F _o c) Y with
                         | eq_refl => F _a _ _ (@id _ c)
                       end)
             ) as [U' HU].
    destruct (F_Full _ _ (
                       match H in (_ = Y) return Hom Y (F _o c) with
                         | eq_refl => F _a _ _ (@id _ c)
                       end)
             ) as [V' HV].
    apply (Build_Isomorphism _ _ _ U' V');
      apply F_Faithful; rewrite F_compose;
      rewrite HU, HV;
      repeat rewrite F_id; clear; destruct H; auto.
  Qed.

  Theorem Fully_Faithful_Conservative : Faithful_Func → Full_Func → ∀ (c c' : Obj), F _o c ≡ F _o c' → c ≡ c'.
  Proof.
    intros F_Faithful F_Full c c' [f g H1 H2].
    destruct (F_Full _ _ f) as [Ff Hf].
    destruct (F_Full _ _ g) as [Fg Hg].
    apply (Build_Isomorphism _ _ _ Ff Fg);
      apply F_Faithful;
      rewrite F_compose;
      rewrite Hf, Hg, F_id; trivial.
  Qed.

End Functor_Properties.

Section Embedding.
  Context (C C' : Category).

  (**
    An embedding is a functor that is faully-faithful. Such a functor is necessarily essentially injective and conservative, i.e., if F _O c === F _O c' then c === c'.
   *)

  Class Embedding : Type :=
    {
      Emb_Func : Functor C C';

      Emb_Faithful : Faithful_Func Emb_Func;
      
      Emb_Full : Full_Func Emb_Func
    }.

  Coercion Emb_Func : Embedding >-> Functor.

  Definition Emb_Essent_Inj (E : Embedding) := Fully_Faithful_Essentially_Injective Emb_Func Emb_Faithful Emb_Full.
  
  Definition Emb_Conservative (E : Embedding) := Fully_Faithful_Conservative Emb_Func Emb_Faithful Emb_Full.

End Embedding.

Arguments Emb_Func {_ _} _.
Arguments Emb_Faithful {_ _} _ {_ _} _ _ _.
Arguments Emb_Full {_ _} _ {_ _} _.
