import bumpy, vmath

# block:
#   let a = Segment(at: vec2(0, 0), to: vec2(100, 0))
#   doAssert overlap(a, a)

# block:
#   let
#     a = Segment(at: vec2(0, 0), to: vec2(100, 0))
#     b = Segment(at: vec2(0, 0), to: vec2(10, 0))
#   doAssert overlap(a, b)

# block:
#   let a = Line(a: vec2(0, 0), b: vec2(100, 0))
#   doAssert overlap(a, a)

# block:
#   let
#     a = Line(a: vec2(0, 0), b: vec2(100, 0))
#     b = Line(a: vec2(0, 0), b: vec2(10, 0))
#   doAssert overlap(a, b)

block:
  let
    a = Line(a: vec2(0, 0), b: vec2(100, 100))
    b = Line(a: vec2(0, 100), b: vec2(100, 0))
  var at: Vec2
  doAssert intersects(a, b, at)
  doAssert at == vec2(50, 50)

block:
  let
    a = Line(a: vec2(0, 0), b: vec2(100, 100))
    b = Line(a: vec2(0, 25), b: vec2(25, 0))
  var at: Vec2
  doAssert intersects(a, b, at)
  doAssert at == vec2(12.5, 12.5)

block:
  let
    a = Line(a: vec2(0, 0), b: vec2(50, 50))
    b = Line(a: vec2(0, 200), b: vec2(50, 150))
  var at: Vec2
  doAssert intersects(a, b, at)
  doAssert at == vec2(100, 100)

block:
  let
    c = Circle(pos: vec2(0, 0), radius: 10)
    s = Segment(at: vec2(0, 0), to: vec2(1, 1))
  doAssert overlaps(c, s)

block:
  let
    c = Circle(pos: vec2(20, 20), radius: 10)
    s = Segment(at: vec2(0, 0), to: vec2(5, 5))
  doAssert not overlaps(c, s)
