Require Import Category.Main.
Require Import Functor.Main.

Section Algebras.
  Context {C : Category} (T : Functor C C).


  (** A T-Algebra in category C for an endo-functor T : C → C is a pair (U, h) where
U is an object of C and h : T _o U → U is an arrow in C. *)
  Record Algebra : Type :=
    {
      Alg_Carrier : C;
      Constructors : Hom (T _o Alg_Carrier) Alg_Carrier
    }.

  (** A T-Algebra homomorphism from (U, h) to (U', h') is an arrow g : U → U'
such that the following diagram commutes:

              T _a g
   T _o U ——————————————> T _o U'
     |                      |
     |                      |
     |                      |
   h |                      | h'
     |                      |
     |                      |
     ↓                      ↓
     U ————–——————————————> U
                g
 *)
  Record Algebra_Hom (alg alg' : Algebra) : Type :=
    {
      Alg_map : Hom (Alg_Carrier alg) (Alg_Carrier alg');

      Alg_map_com : ((Constructors alg') ∘ (T _a Alg_map) = Alg_map ∘ (Constructors alg))%morphism
    }.

  Arguments Alg_map {_ _} _.
  Arguments Alg_map_com {_ _} _.

  (** Composition of algebra homomorphisms. The algebra maps are simply composed. *)
  Program Definition Algebra_Hom_compose
          {alg alg' alg'' : Algebra}
          (h : Algebra_Hom alg alg')
          (h' : Algebra_Hom alg' alg'')
    : Algebra_Hom alg alg''
    :=
      {|
        Alg_map := ((Alg_map h') ∘ (Alg_map h))%morphism
      |}.

  Next Obligation.
  Proof.
    destruct h as [alm almcm]; destruct h' as [alm' almcm']; cbn.
    rewrite F_compose.
    rewrite assoc_sym.
    rewrite almcm'.
    rewrite assoc.
    rewrite almcm.
    auto.
  Qed.

  (** Two algebra maps are equal if their underlying maps are. The commutative diagrams
are equated with proof irrelevance. *)
  Lemma Algebra_Hom_eq_simplify (alg alg' : Algebra)
        (ah ah' : Algebra_Hom alg alg')
    : (Alg_map ah) = (Alg_map ah') -> ah = ah'.
  Proof.
    intros; destruct ah; destruct ah'; cbn in *.
    ElimEq.
    PIR.
    trivial.
  Qed.

  (** Composition of algebra homomorphisms is associative. *)
  Theorem Algebra_Hom_compose_assoc
          {alg alg' alg'' alg''' : Algebra}
          (f : Algebra_Hom alg alg')
          (g : Algebra_Hom alg' alg'')
          (h : Algebra_Hom alg'' alg''') :
    (Algebra_Hom_compose f (Algebra_Hom_compose g h))
    = (Algebra_Hom_compose (Algebra_Hom_compose f g) h).
  Proof.
    apply Algebra_Hom_eq_simplify; cbn; auto.
  Qed.

  (** The identity algebra homomorphism. *)
  Program Definition Algebra_Hom_id (alg : Algebra) : Algebra_Hom alg alg :=
    {|
      Alg_map := id
    |}.

  (** Identity algebra homomorphism is the left unit of compositon. *)
  Theorem Algebra_Hom_id_unit_left
          {alg alg' : Algebra}
          (f : Algebra_Hom alg alg') :
    (Algebra_Hom_compose f (Algebra_Hom_id alg')) = f.
  Proof.
    apply Algebra_Hom_eq_simplify; cbn; auto.
  Qed.
  
  (** Identity algebra homomorphism is the right unit of compositon. *)
  Theorem Algebra_Hom_id_unit_right
          {alg alg' : Algebra}
          (f : Algebra_Hom alg alg') :
    (Algebra_Hom_compose (Algebra_Hom_id alg) f) = f.
  Proof.
    apply Algebra_Hom_eq_simplify; cbn; auto.
  Qed.

  (** Algebras of an endo-functor form a category. *)
  Definition Algebra_Cat : Category :=
    {|
      Obj := Algebra;
      Hom := Algebra_Hom;
      compose := @Algebra_Hom_compose;
      assoc := @Algebra_Hom_compose_assoc;
      assoc_sym := fun _ _ _ _ _ _ _ => eq_sym (@Algebra_Hom_compose_assoc _ _ _ _ _ _ _);
      id := Algebra_Hom_id;
      id_unit_left := @Algebra_Hom_id_unit_left;
      id_unit_right := @Algebra_Hom_id_unit_right
    |}.

End Algebras.

Arguments Alg_Carrier {_ _} _.
Arguments Constructors {_ _} _.
Arguments Algebra_Hom {_ _} _ _.
Arguments Alg_map {_ _ _ _} _.
Arguments Alg_map_com {_ _ _ _} _.
Arguments Algebra_Hom_id {_ _} _.

(** Coalgebras are algebras in the dual category. *)
Section CoAlgebras.
  Context {C : Category}.

  Definition CoAlgebra := @Algebra C^op.
  
  Definition CoAlgebra_Hom :=
      @Algebra_Hom C^op.

  Definition CoAlgebra_Hom_id := @Algebra_Hom_id  C^op.

  Definition CoAlgebra_Cat := @Algebra_Cat C^op.

End CoAlgebras.