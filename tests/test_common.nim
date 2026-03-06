import
  std/unittest,
  bumpy, vmath

const Epsilon* = 0.0001'f

proc approxEq*(a, b: float32, eps = Epsilon): bool =
  abs(a - b) <= eps

proc approxEq*(a, b: Vec2, eps = Epsilon): bool =
  approxEq(a.x, b.x, eps) and approxEq(a.y, b.y, eps)

template checkVec2*(actual, expected: Vec2, eps = Epsilon) =
  check approxEq(actual, expected, eps)

proc hasPoint*(poly: Polygon, point: Vec2, eps = Epsilon): bool =
  for polyPoint in poly:
    if approxEq(polyPoint, point, eps):
      return true
