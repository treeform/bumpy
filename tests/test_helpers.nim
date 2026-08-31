import
  std/unittest,
  bumpy, vmath,
  test_common

suite "helpers":
  test "constructors preserve values":
    let
      r1 = rect(1, 2, 3, 4)
      r2 = rect(vec2(1, 2), vec2(3, 4))
      l = line(vec2(1, 2), vec2(3, 4))
      c = circle(vec2(5, 6), 7)
      s = segment(vec2(8, 9), vec2(10, 11))

    check r1 == r2
    check l.a == vec2(1, 2)
    check l.b == vec2(3, 4)
    check c.pos == vec2(5, 6)
    check c.radius == 7
    check s.at == vec2(8, 9)
    check s.to == vec2(10, 11)

  test "xy and wh accessors round trip":
    var r = rect(1, 2, 3, 4)

    check r.xy == vec2(1, 2)
    check r.wh == vec2(3, 4)

    r.xy = vec2(10, 20)
    r.wh = vec2(30, 40)

    check r == rect(10, 20, 30, 40)

  test "rect operators keep documented semantics":
    let
      a = rect(1, 2, 3, 4)
      b = rect(10, 20, 30, 40)
      scaled = a * 2.0
      divided = scaled / 2.0
      added = a + b
      unioned = a or rect(2, 1, 4, 6)
      intersected = rect(0, 0, 4, 4) and rect(2, 1, 4, 4)

    check scaled == rect(2, 4, 6, 8)
    check divided == a
    check added == rect(11, 22, 3, 4)
    check unioned == rect(1, 1, 5, 6)
    check intersected == rect(2, 1, 2, 3)

  test "segment translation and transform work":
    var moved = segment(vec2(1, 2), vec2(3, 4))
    moved += vec2(10, 20)
    check moved == segment(vec2(11, 22), vec2(13, 24))

    let transformed = translate(vec2(5, -2)) * segment(vec2(1, 2), vec2(3, 4))
    check transformed == segment(vec2(6, 0), vec2(8, 2))

  test "segment length handles zero and diagonal":
    check length(segment(vec2(0, 0), vec2(0, 0))) == 0
    check approxEq(length(segment(vec2(0, 0), vec2(3, 4))), 5)
