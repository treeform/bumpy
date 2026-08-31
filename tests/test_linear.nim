import
  std/unittest,
  bumpy, vmath,
  test_common

suite "linear overlap and intersections":
  test "segment overlap covers crossing and endpoint touch":
    let
      crossingA = segment(vec2(0, 0), vec2(10, 10))
      crossingB = segment(vec2(0, 10), vec2(10, 0))
      endpointA = segment(vec2(0, 0), vec2(10, 0))
      endpointB = segment(vec2(10, 0), vec2(10, 5))

    check overlaps(crossingA, crossingB)
    check overlaps(endpointA, endpointB)

  test "segment overlap treats collinear overlap as overlap":
    let
      a = segment(vec2(0, 0), vec2(10, 0))
      b = segment(vec2(5, 0), vec2(15, 0))
      c = segment(vec2(11, 0), vec2(15, 0))

    check overlaps(a, b)
    check not overlaps(a, c)

  test "segment overlap rejects parallel disjoint segments":
    let
      a = segment(vec2(0, 0), vec2(10, 0))
      b = segment(vec2(0, 2), vec2(10, 2))

    check not overlaps(a, b)

  test "line overlap handles crossing coincident and parallel cases":
    let
      crossingA = line(vec2(0, 0), vec2(10, 10))
      crossingB = line(vec2(0, 10), vec2(10, 0))
      coincidentA = line(vec2(0, 0), vec2(10, 0))
      coincidentB = line(vec2(2, 0), vec2(7, 0))
      parallel = line(vec2(0, 1), vec2(10, 1))

    check overlaps(crossingA, crossingB)
    check overlaps(coincidentA, coincidentB)
    check not overlaps(coincidentA, parallel)

  test "line segment overlap handles crossing collinear and parallel cases":
    let
      l = line(vec2(-10, 0), vec2(10, 0))
      crossing = segment(vec2(2, -3), vec2(2, 3))
      collinear = segment(vec2(1, 0), vec2(4, 0))
      parallel = segment(vec2(1, 2), vec2(4, 2))

    check overlaps(l, crossing)
    check overlaps(l, collinear)
    check not overlaps(l, parallel)

  test "line line intersection returns the crossing point":
    let
      a = line(vec2(0, 0), vec2(100, 100))
      b = line(vec2(0, 100), vec2(100, 0))
    var at: Vec2

    check intersects(a, b, at)
    checkVec2(at, vec2(50, 50))

  test "line line intersection rejects parallel lines":
    let
      a = line(vec2(0, 0), vec2(10, 0))
      b = line(vec2(0, 5), vec2(10, 5))
    var at = vec2(-1, -1)

    check not intersects(a, b, at)
    check at == vec2(-1, -1)

  test "segment intersection returns unique crossing points":
    let
      crossingA = segment(vec2(0, 0), vec2(10, 10))
      crossingB = segment(vec2(0, 10), vec2(10, 0))
      endpointA = segment(vec2(0, 0), vec2(10, 0))
      endpointB = segment(vec2(10, 0), vec2(10, 5))
    var at: Vec2

    check intersects(crossingA, crossingB, at)
    checkVec2(at, vec2(5, 5))
    check intersects(endpointA, endpointB, at)
    checkVec2(at, vec2(10, 0))

  test "segment intersection rejects parallel and collinear overlaps":
    let
      parallelA = segment(vec2(0, 0), vec2(10, 0))
      parallelB = segment(vec2(0, 1), vec2(10, 1))
      collinear = segment(vec2(5, 0), vec2(15, 0))
    var at = vec2(-1, -1)

    check not intersects(parallelA, parallelB, at)
    check not intersects(parallelA, collinear, at)
    check at == vec2(-1, -1)

  test "line segment intersection handles crossing and rejects collinear":
    let
      l = line(vec2(-10, 0), vec2(10, 0))
      crossing = segment(vec2(2, -3), vec2(2, 3))
      collinear = segment(vec2(1, 0), vec2(4, 0))
      parallel = segment(vec2(1, 2), vec2(4, 2))
    var at = vec2(-1, -1)

    check intersects(l, crossing, at)
    checkVec2(at, vec2(2, 0))
    check not intersects(l, collinear, at)
    check not intersects(l, parallel, at)
