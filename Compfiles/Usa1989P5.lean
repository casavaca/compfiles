/-
Copyright (c) 2023 David Renshaw. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Renshaw
-/

import Mathlib.Tactic

import ProblemExtraction

problem_file

/-!
# USA Mathematical Olympiad 1989, Problem 5

Let u and v be real numbers such that

(u + u² + u³ + ⋯ + u⁸) + 10u⁹ = (v + v² + v³ + ⋯ + v¹⁰) + 10v¹¹ = 8.

Determine, with proof, which of the two numbers, u or v, is larger.
-/

namespace Usa1989P5

open scoped BigOperators

determine u_is_larger : Bool := false

problem usa1989_p5
    (u v : ℝ)
    (hu : (∑ i in Finset.range 8, u^(i + 1)) + 10 * u^9 = 8)
    (hv : (∑ i in Finset.range 10, v^(i + 1)) + 10 * v^11 = 8) :
    if u_is_larger then v < u else u < v := by
  -- solution from
  -- https://artofproblemsolving.com/wiki/index.php/1989_USAMO_Problems/Problem_5
  simp only [ite_self]

  let U (x : ℝ) : ℝ := (∑ i in Finset.range 8, x^(i + 1)) + 10 * x^ 9
  let V (x : ℝ) : ℝ := (∑ i in Finset.range 10, x^(i + 1)) + 10 * x^11

  have hU : ∀ x, x ≠ 1 → U x = (x^10 - x) / (x - 1) + 9 * x^9 := fun x hx ↦ by
    convert_to U x = x * ((x^9 - 1) / (x - 1)) + 9 * x^9
    · ring
    rw [←geom_sum_eq hx 9, Finset.mul_sum]
    have h1 : ∀ i, i ∈ Finset.range 9 → x * x^i = x ^(i + 1) := fun i _ ↦ rfl
    rw [Finset.sum_congr rfl h1, Finset.sum_range_succ]
    ring

  have hV : ∀ x, x ≠ 1 → V x = (x^12 - x) / (x - 1) + 9 * x^11 := fun x hx ↦ by
    convert_to V x = x * ((x^11 - 1) / (x - 1)) + 9 * x^11
    · ring
    rw [←geom_sum_eq hx 11, Finset.mul_sum]
    have h1 : ∀ i, i ∈ Finset.range 11 → x * x^i = x ^(i + 1) := fun i _ ↦ rfl
    rw [Finset.sum_congr rfl h1, Finset.sum_range_succ]
    ring

  have h1 : ∀ x : ℝ, x ≤ 0 → (U x ≤ 0 ∧ V x ≤ 0) := fun x hx ↦ by
    have h2 : 0 ≤ -x := neg_nonneg.mpr hx
    have h4 : x - 1 < 0 := by
      suffices H : x < 1 from sub_neg.mpr H
      exact lt_of_le_of_lt hx zero_lt_one
    have h5 : 9 * x^9 ≤ 0 := by
      suffices H : 0 ≤ (-x)^9 by linarith
      positivity
    have h6 : x ≠ 1 := by linarith
    constructor
    · have h3 : 0 ≤ x^10 - x := by change 0 ≤ x^10 + - x; positivity
      rw [hU x h6]
      have : (x ^ 10 - x) / (x - 1) ≤ 0 := by
        obtain h7 | h7 : x^10 - x = 0 ∨ 0 < x^10 - x := LE.le.eq_or_gt h3
        · rw [h7]; simp
        · exact LT.lt.le (div_neg_of_pos_of_neg h7 h4)
      exact add_nonpos this h5
    · have h3 : 0 ≤ x^12 - x := by change 0 ≤ x^12 + - x; positivity
      rw [hV x h6]
      have : (x ^ 12 - x) / (x - 1) ≤ 0 := by
        obtain h7 | h7 : x^12 - x = 0 ∨ 0 < x^12 - x := LE.le.eq_or_gt h3
        · rw [h7]; simp
        · exact LT.lt.le (div_neg_of_pos_of_neg h7 h4)
      have h5' : 9 * x^11 ≤ 0 := by
        suffices H : 0 ≤ (-x)^11 by linarith
        positivity
      exact add_nonpos this h5'

  have h2 : ¬ 9/10 ≤ u := by
    intro hu9
    have : 8 < U u := by
      -- todo: should the `mono` tactic help here?
      have h3 : (9/10)^9 ≤ u^9 := pow_le_pow_left (by norm_num) hu9 9
      have h4 : ∀ i ∈ Finset.range 8, (9/10)^(i+1) ≤ u^(i+1) := fun i _hi ↦ by
        exact pow_le_pow_left (by norm_num) hu9 (i + 1)

      have h5 : ∑ i in Finset.range 8, ((9:ℝ)/10) ^ (i + 1) ≤
                ∑ i in Finset.range 8, u^(i + 1) :=
        Finset.sum_le_sum h4

      have h6 : U (9 / 10) ≤ U u := by
        dsimp only [U]; gcongr
      have h7 : (9:ℝ)/10 ≠ 1 := by norm_num
      rw [hU _ h7] at h6
      norm_num at h6
      dsimp only [U]
      linarith
    have hu' : U u = 8 := hu
    linarith

  have h2' : ¬ 9/10 ≤ v := by
    intro hv9
    have : 8 < V v := by
      have h3 : (9/10)^11 ≤ v^11 := pow_le_pow_left (by norm_num) hv9 11
      have h4 : ∀ i ∈ Finset.range 10, (9/10)^(i+1) ≤ v^(i+1) := fun i _hi ↦ by
        exact pow_le_pow_left (by norm_num) hv9 (i + 1)

      have h5 : ∑ i in Finset.range 10, ((9:ℝ)/10) ^ (i + 1) ≤
                ∑ i in Finset.range 10, v^(i + 1) :=
        Finset.sum_le_sum h4

      have h6 : V (9 / 10) ≤ V v := by
        dsimp only [U]; gcongr
      have h7 : (9:ℝ)/10 ≠ 1 := by norm_num
      rw [hV _ h7] at h6
      norm_num at h6
      dsimp only [U]
      linarith
    have hv' : V v = 8 := hv
    linarith

  sorry