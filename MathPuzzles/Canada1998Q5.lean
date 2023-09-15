/-
Copyright (c) 2023 David Renshaw. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: David Renshaw
-/

import Mathlib.Data.Int.Basic

import MathPuzzles.Meta.Attributes

#[problem_setup]/-!
Canadian Mathematical Olympiad 1998, Problem 5

Let m be a positive integer. Define the sequence {aₙ} by a₀ = 0,
a₁ = m, and aₙ₊₁ = m²aₙ - aₙ₋₁ for n ≥ 1. Prove that an ordered pair
(a,b) of nonegative integers, with a ≤ b, is a solution of the equation

 (a² + b²) / (ab + 1) = m²

if an only if (a,b) = (aₙ,aₙ₊₁) for some n ≥ 0.
-/

#[problem_setup] namespace Canada1998Q5

#[problem_setup]
def A (m : ℕ) (hm : 0 < m) : ℕ → ℤ
| 0 => 0
| 1 => (↑m)
| n + 2 => (m : ℤ)^2 * A m hm (n + 1) - A m hm n

#[problem_statement]
theorem canada1998_q5 (m : ℕ) (hm : 0 < m) (a b : ℕ) (hab : a ≤ b) :
    a^2 + b^2 = m^2 * (a * b + 1) ↔
     ∃ n : ℕ, (a:ℤ) = A m hm n ∧ (b:ℤ) = A m hm (n + 1) := by
  sorry

