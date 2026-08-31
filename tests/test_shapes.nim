import
  std/[math, unittest],
  bumpy, vmath

suite "shape boundaries":
  test "point overlap is exact":
    check overlaps(vec2(1, 2), vec2(1, 2))
    check not overlaps(vec2(1, 2), vec2(1, 2.001))

  test "circle boundaries include tangent points":
    let
      c = circle(vec2(0, 0), 5)
      touching = circle(vec2(10, 0), 5)
      separate = circle(vec2(10.1, 0), 5)

    check overlaps(vec2(5, 0), c)
    check overlaps(c, touching)
    check not overlaps(c, separate)

  test "rect boundaries include edges and corners":
    let r = rect(1, 2, 3, 4)

    check overlaps(vec2(1, 2), r)
    check overlaps(vec2(4, 6), r)
    check not overlaps(vec2(4.1, 6), r)

  test "rect overlap treats touching edges as overlap":
    let
      a = rect(0, 0, 4, 4)
      b = rect(4, 1, 3, 2)
      c = rect(5, 1, 3, 2)

    check overlaps(a, b)
    check not overlaps(a, c)

  test "circle rect overlap includes tangent contact":
    let
      sideTouch = circle(vec2(5, 2), 1)
      cornerTouch = circle(vec2(5, 5), sqrt(2.0'f))
      r = rect(0, 0, 4, 4)

    check overlaps(sideTouch, r)
    check overlaps(cornerTouch, r)

  test "point segment overlap respects inclusive fudge threshold":
    let
      s = segment(vec2(0, 0), vec2(10, 0))
      thresholdPoint = vec2(10.05, 0)
      farPoint = vec2(10.2, 0)

    check overlaps(vec2(10, 0), s)
    check overlaps(thresholdPoint, s, 0.1)
    check not overlaps(farPoint, s, 0.1)

  test "point line overlap respects fudge for sloped and vertical lines":
    let
      diagonal = line(vec2(0, 0), vec2(10, 10))
      vertical = line(vec2(2, -5), vec2(2, 5))

    check overlaps(vec2(5, 5.1), diagonal, 0.1)
    check not overlaps(vec2(5, 5.15), diagonal, 0.1)
    check overlaps(vec2(2.1, 1), vertical, 0.1)
    check not overlaps(vec2(2.11, 1), vertical, 0.1)

  test "circle segment overlap handles tangency and degenerate segments":
    let
      tangentCircle = circle(vec2(5, 1), 1)
      lineSegment = segment(vec2(0, 0), vec2(10, 0))
      insidePoint = segment(vec2(0, 0), vec2(0, 0))
      outsidePoint = segment(vec2(3, 3), vec2(3, 3))

    check overlaps(tangentCircle, lineSegment)
    check overlaps(circle(vec2(0, 0), 1), insidePoint)
    check not overlaps(circle(vec2(0, 0), 1), outsidePoint)

  test "circle line overlap handles tangency":
    let
      c = circle(vec2(5, 1), 1)
      l = line(vec2(0, 0), vec2(10, 0))

    check overlaps(c, l)

  test "segment and line overlap with rect on boundaries":
    let
      r = rect(0, 0, 4, 4)
      inside = segment(vec2(1, 1), vec2(3, 3))
      edgeTouch = segment(vec2(-1, 0), vec2(0, 0))
      through = line(vec2(-1, 2), vec2(5, 2))

    check overlaps(inside, r)
    check overlaps(edgeTouch, r)
    check overlaps(r, through)
