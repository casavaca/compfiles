/-
Copyright (c) 2024 The Compfiles Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Renshaw
-/

import Mathlib.Tactic

import ProblemExtraction

problem_file { tags := [.Combinatorics] }

/-!
# International Mathematical Olympiad 2009, Problem 6

Let a₁, a₂, ..., aₙ be distinct positive integers and let M
be a set of n - 1 positive integers not containing
s = a₁ + a₂ + ... + aₙ. A grasshopper is to jump along the
real axis, starting at the point 0 and making n jumps to
the right with lengths a₁, a₂, ..., aₙ in some order. Prove
that the order can be chosen in such a way that the
grasshopper never lands on any point in M.
-/

namespace Imo2009P6

open scoped BigOperators

snip begin

lemma lemma1 (n : ℕ) (a : Fin n → ℤ) :
    ∃ p : Fin n → Fin n,
        p.Bijective ∧ ∀ i j, i ≤ j → a (p i) ≤ a (p j) := by
  sorry

lemma lemma2 (n : ℕ) (a : Fin n → ℤ)
    (ainj : a.Injective) :
    ∃ p : Fin n → Fin n,
        p.Bijective ∧ ∀ i j, i < j → (a ∘ p) i < (a ∘ p) j := by
  obtain ⟨p, hp1, hp2⟩ := lemma1 n a
  refine ⟨p, hp1, ?_⟩
  intro i j hij
  have h0 := ne_of_lt hij
  have h2 := hp2 i j (le_of_lt hij)
  have h3 : p i ≠ p j := fun hx ↦ h0 (hp1.1 hx)
  exact lt_of_le_of_ne h2 fun a ↦ h3 (ainj a)

theorem imo2009_p6_aux1 (n : ℕ) (hn : 0 < n)
    (a : Fin n → ℤ)
    (ainj : a.Injective)
    (apos : ∀ i, 0 < a i)
    (asorted : ∀ i j, i < j → a i < a j)
    (M : Finset ℤ)
    (Mpos : ∀ m ∈ M, 0 < m)
    (Mcard : M.card ≤ n - 1)
    (hM : ∑ i, a i ∉ M)
    : ∃ p : Fin n → Fin n,
        p.Bijective ∧
          ∀ i : Fin n, ∑ j in Finset.filter (· ≤ i) Finset.univ, a (p j) ∉ M := by
  revert a M hn
  induction' n using Nat.strongInductionOn with n ih
  intro hn a ainj apos asorted M Mpos Mcard
  let x := ∑ i in Finset.filter (·.val < n-1) Finset.univ, a i
  -- four cases: split on whether x ∈ M and whether
  -- there is any y > x such that y ∈ M.
  have h1 := Classical.em (x ∈ M)
  have h2 := Classical.em (∃ y, x < y ∧ y ∈ M)
  cases' h1 with h1 h1 <;> cases' h2 with h2 h2
  · sorry
  · sorry
  · -- x has no mine, and there is a mine past x.
    -- Then there are at most n − 2 mines in [0, x] and
    -- so we use induction to reach x, then leap from x to s and win
    obtain ⟨y, hy1, hy2⟩ := h2
    let M' := M.filter (fun z ↦ z ≤ x)
    have hyM' : y ∉ M' := by
      intro hy
      rw [Finset.mem_filter] at hy
      omega
    have h3 : M'.card ≤ n - 2 := by
      let M'' := Finset.cons y M' hyM'
      have h4 : M'' ⊆ M := by
        intro a ha
        rw [Finset.mem_cons] at ha
        obtain rfl | ha := ha
        · exact hy2
        · rw [Finset.mem_filter] at ha
          exact ha.1
      have h4' : M''.card ≤ M.card := Finset.card_le_card h4
      have h5 : M''.card = M'.card + 1 := Finset.card_cons hyM'
      have h6 : M'.card + 1 ≤ M.card := by omega
      omega
    intro hM
    obtain h7 | h7 := Nat.eq_zero_or_pos M'.card
    · refine ⟨id, Function.bijective_id, ?_⟩
      intro i
      obtain hi1 | hi2 := Classical.em (i.val < n-1)
      · let z := ∑ j in Finset.filter (· ≤ i) Finset.univ, a j
        have h9 : z ≤ x := by sorry
        intro h10
        change z ∈ M at h10
        have h11 : z ∈ M' := by
          rw [Finset.mem_filter]
          exact ⟨h10, h9⟩
        rw [Finset.card_eq_zero] at h7
        have h12 := Finset.not_mem_empty z
        rw [h7] at h11
        exact h12 h11
      · have h9 : i.val + 1 = n := by omega
        have h10 : Finset.filter (fun x ↦ x ≤ i) Finset.univ =
                    Finset.univ (α := Fin n) := by
          ext x
          rw [Finset.mem_filter]
          suffices x ≤ i from and_iff_left_of_imp fun a ↦ this
          omega
        rw [h10]
        exact hM
    let n' := n - 1
    let a' := fun i : Fin n' ↦ a ⟨i, by omega⟩
    have ainj' : a'.Injective := by
      intro i j hij
      have h11 : a ⟨i, by omega⟩ = a ⟨j, by omega⟩ := by
        simp only [a'] at hij
        exact hij
      have h12 := congrArg Fin.val (@ainj ⟨i, by omega⟩ ⟨j, by omega⟩ h11)
      dsimp at h12
      exact Fin.eq_of_val_eq h12
    have apos' : ∀ (i : Fin n'), 0 < a' i :=
      fun i ↦ apos ⟨i.val, by omega⟩
    have asorted' : ∀ (i j : Fin n'), i < j → a' i < a' j := by
      intro i j hij
      exact asorted ⟨i, by omega⟩ ⟨j, by omega⟩ hij
    have Mpos' : (∀ m ∈ M', 0 < m) := by
      intro m hm
      rw [Finset.mem_filter] at hm
      exact Mpos m hm.1
    have hM' : ∑ i : Fin n', a' i ∉ M' := by
      have h14 : ∑ i : Fin n', a' i = x := by
        let f : Fin n' ↪ Fin n :=
          ⟨fun x ↦ ⟨x, by omega⟩,
           by intro x y hxy; dsimp at hxy; apply_fun (·.val) at hxy
              exact Fin.eq_of_val_eq hxy⟩
        have h40 : (Finset.univ (α := Fin n')).map f =
             Finset.filter (·.val < n - 1) Finset.univ := by
          ext x
          rw [Finset.mem_map, Finset.mem_filter]
          constructor
          · rintro ⟨y, hy1, hy2⟩
            simp only [Finset.mem_univ, true_and]
            rw [←hy2]
            obtain ⟨y', hy'⟩ := y
            unfold_let f
            exact hy'
          · rintro ⟨_, h41⟩
            use ⟨x.val, by omega⟩
            simp [f]
        unfold_let x
        rw [←h40, Finset.sum_map]
        congr
      rw [←h14] at h1
      rw [Finset.mem_filter]
      push_neg
      intro h15
      exact (h1 h15).elim
    obtain ⟨p', hp1, hp2⟩ :=
      ih n' (by omega) (by omega) a' ainj' apos' asorted' M' Mpos' (by omega) hM'
    clear ih
    let p : Fin n → Fin n := fun i ↦
      if h : i < n' then ⟨p' ⟨i, h⟩, by omega⟩ else i
    have pb : p.Bijective := sorry
    refine ⟨p, pb, ?_⟩
    intro i
    obtain h30 | h30 := Classical.em (i.val < n')
    · let i' : Fin n' := ⟨i.val, h30⟩
      have h31 := hp2 i'
      rw [Finset.mem_filter] at h31
      have h33 : ∑ j in Finset.filter (· ≤ i') Finset.univ, a' (p' j) =
                 ∑ j in Finset.filter (· ≤ i) Finset.univ, a (p j) := by
           sorry
      rw [h33] at h31
      have h34 : ∑ j in Finset.filter (· ≤ i) Finset.univ, a (p j) ≤ x := by
        sorry
      intro H
      exact (h31 ⟨H, h34⟩).elim
    · have h31 : i.val = n' := by omega
      have h32 : ∑ j in Finset.filter (fun x ↦ x ≤ i) Finset.univ, a (p j) =
                 ∑ i : Fin n, a i := by
        rw [←Function.Bijective.sum_comp pb (fun j ↦ a j)]
        have h33 : i.val + 1 = n := by omega
        have h10 : Finset.filter (fun x ↦ x ≤ i) Finset.univ =
                    Finset.univ (α := Fin n) := by
          ext x
          rw [Finset.mem_filter]
          suffices x ≤ i from and_iff_left_of_imp fun a ↦ this
          omega
        rw[h10]
      rw [h32]
      exact hM
  · sorry

-- The problem with an additional assumption that a is sorted.
theorem imo2009_p6_aux2 (n : ℕ) (hn : 0 < n)
    (a : Fin n → ℤ)
    (ainj : a.Injective)
    (apos : ∀ i, 0 < a i)
    (asorted : ∀ i j, i < j → a i < a j)
    (M : Finset ℤ)
    (Mpos : ∀ m ∈ M, 0 < m)
    (Mcard : M.card = n - 1)
    (hM : ∑ i, a i ∉ M)
    : ∃ p : Fin n → Fin n,
        p.Bijective ∧
          ∀ i : Fin n, ∑ j in Finset.univ.filter (· ≤ i), a (p j) ∉ M := by
  have Mcard' := Mcard.le
  exact imo2009_p6_aux1 n hn a ainj apos asorted M Mpos Mcard' hM

snip end

problem imo2009_p6 (n : ℕ) (hn : 0 < n)
    (a : Fin n → ℤ)
    (ainj : a.Injective)
    (apos : ∀ i, 0 < a i)
    (M : Finset ℤ)
    (Mpos : ∀ m ∈ M, 0 < m)
    (Mcard : M.card = n - 1)
    (hM : ∑ i, a i ∉ M)
    : ∃ p : Fin n → Fin n,
        p.Bijective ∧
        ∀ i : Fin n,
          ∑ j in Finset.univ.filter (· ≤ i), a (p j) ∉ M := by
  obtain ⟨ps, hps1, hps2⟩ := lemma2 n a ainj
  have ainj' : (a ∘ ps).Injective :=
    (Function.Injective.of_comp_iff' a hps1).mpr ainj
  have apos' : ∀ (i : Fin n), 0 < (a ∘ ps) i := by
    intro i
    exact apos (ps i)
  have hM' : ∑ i : Fin n, (a ∘ ps) i ∉ M := by
    have : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
    let ps' := Fintype.bijInv hps1
    have h0 : ps'.Bijective := Fintype.bijective_bijInv hps1
    have h3 : ∀ x, ps (ps' x) = x := by
      have h5 := Fintype.rightInverse_bijInv hps1
      intro x
      exact ainj (congrArg a (ainj (congrArg a (h5 x))))
    have h3' : ∀ x, a (ps (ps' x)) = a x := by
      intro x
      exact congrArg a (ainj (congrArg a (h3 x)))
    have h1 : Finset.map ⟨ps', h0.1⟩ Finset.univ = Finset.univ := by simp
    rw [←h1]
    rw [Finset.sum_map, Function.Embedding.coeFn_mk]
    simp_rw [Function.comp_apply]
    rw [Fintype.sum_congr _ _ h3']
    exact hM
  obtain ⟨p', hp1, hp2⟩ :=
    imo2009_p6_aux2 n hn (a ∘ ps) ainj' apos' hps2 M Mpos Mcard hM'
  exact ⟨ps ∘ p', Function.Bijective.comp hps1 hp1, hp2⟩