import
  std/[math, unittest],
  bumpy, vmath,
  test_common

suite "polygons hulls and wedges":
  test "triangle overlap handles interior edge and exterior points":
    let tri = @[vec2(0, 0), vec2(6, 0), vec2(0, 6)]

    check overlapsTri(tri, vec2(1, 1))
    check overlapsTri(tri, vec2(3, 0))
    check not overlapsTri(tri, vec2(4, 4))

  test "polygon point overlap is consistent for open and closed polygons":
    let
      openSquare = @[
        vec2(0, 0),
        vec2(4, 0),
        vec2(4, 4),
        vec2(0, 4)
      ]
      closedSquare = openSquare & @[openSquare[0]]

    check overlaps(openSquare, vec2(2, 2))
    check overlaps(closedSquare, vec2(2, 2))
    check not overlaps(openSquare, vec2(5, 5))
    check not overlaps(closedSquare, vec2(5, 5))

  test "empty polygons safely report no overlap":
    let
      empty: Polygon = @[]
      c = circle(vec2(0, 0), 1)
      r = rect(0, 0, 1, 1)
      s = segment(vec2(0, 0), vec2(1, 0))
      l = line(vec2(0, 0), vec2(1, 0))
      poly = @[vec2(0, 0), vec2(1, 0), vec2(0, 1)]

    check not overlaps(empty, vec2(0, 0))
    check not overlaps(empty, c)
    check not overlaps(empty, r)
    check not overlaps(empty, s)
    check not overlaps(empty, l)
    check not overlaps(empty, poly)

  test "polygon overlaps detect containment and crossing":
    let
      square = @[
        vec2(0, 0),
        vec2(4, 0),
        vec2(4, 4),
        vec2(0, 4)
      ]
      innerRect = rect(1, 1, 1, 1)
      crossingSeg = segment(vec2(-1, 2), vec2(2, 2))
      crossingLine = line(vec2(-1, 2), vec2(5, 2))
      innerCircle = circle(vec2(2, 2), 0.5)
      disjointPoly = @[
        vec2(10, 10),
        vec2(12, 10),
        vec2(12, 12),
        vec2(10, 12)
      ]

    check overlaps(square, innerRect)
    check overlaps(square, crossingSeg)
    check overlaps(square, crossingLine)
    check overlaps(square, innerCircle)
    check not overlaps(square, disjointPoly)

  test "polygon polygon overlap includes containment and shared edges":
    let
      outer = @[
        vec2(0, 0),
        vec2(5, 0),
        vec2(5, 5),
        vec2(0, 5)
      ]
      inner = @[
        vec2(1, 1),
        vec2(2, 1),
        vec2(2, 2),
        vec2(1, 2)
      ]
      edgeTouch = @[
        vec2(5, 1),
        vec2(7, 1),
        vec2(7, 3),
        vec2(5, 3)
      ]

    check overlaps(outer, inner)
    check overlaps(outer, edgeTouch)

  test "convex hull removes interior points and keeps the extremes":
    let
      points = @[
        vec2(0, 0),
        vec2(4, 0),
        vec2(4, 4),
        vec2(0, 4),
        vec2(2, 2),
        vec2(1, 1),
        vec2(4, 4)
      ]
      hull = convexHull(points)

    check hull.len == 4
    check hasPoint(hull, vec2(0, 0))
    check hasPoint(hull, vec2(4, 0))
    check hasPoint(hull, vec2(4, 4))
    check hasPoint(hull, vec2(0, 4))

  test "convex hull of collinear points collapses to endpoints":
    let
      points = @[
        vec2(0, 0),
        vec2(1, 0),
        vec2(2, 0),
        vec2(3, 0)
      ]
      hull = convexHull(points)

    check hull.len == 2
    check hasPoint(hull, vec2(0, 0))
    check hasPoint(hull, vec2(3, 0))

  test "convex hull normal returns an upward normal for left to right edge":
    checkVec2(convexHullNormal(segment(vec2(0, 0), vec2(4, 0))), vec2(0, 1))

  test "wedge polygon closes itself and responds to error tolerance":
    let
      wedge = Wedge(
        pos: vec2(0, 0),
        rot: 0,
        minRadius: 0,
        maxRadius: 4,
        arc: Pi / 2
      )
      coarse = polygon(wedge, 0.5)
      fine = polygon(wedge, 0.1)

    check coarse.len >= 4
    check coarse[0] == vec2(0, 0)
    checkVec2(coarse[0], coarse[^1])
    check fine.len >= coarse.len

  test "wedge point overlap includes radial and angular boundaries":
    let wedge = Wedge(
      pos: vec2(0, 0),
      rot: 0,
      minRadius: 2,
      maxRadius: 4,
      arc: Pi / 2
    )

    check overlaps(wedge, vec2(2, 0))
    check overlaps(wedge, vec2(4 * cos(Pi / 4), 4 * sin(Pi / 4)))
    check not overlaps(wedge, vec2(1.9, 0))
    check not overlaps(wedge, vec2(4 * cos(Pi / 4 + 0.01), 4 * sin(Pi / 4 + 0.01)))

  test "wedge overlaps are symmetric for representative shapes":
    let
      wedge = Wedge(
        pos: vec2(0, 0),
        rot: 0,
        minRadius: 0,
        maxRadius: 5,
        arc: Pi / 2
      )
      seg = segment(vec2(3, -1), vec2(3, 1))
      circ = circle(vec2(3, 0), 0.5)
      rectShape = rect(2, -1, 1, 2)
      poly = @[
        vec2(2, -0.5),
        vec2(4, 0),
        vec2(2, 0.5)
      ]
      otherWedge = Wedge(
        pos: vec2(1, 0),
        rot: 0,
        minRadius: 0,
        maxRadius: 4,
        arc: Pi / 2
      )

    check overlaps(wedge, seg)
    check overlaps(wedge, circ)
    check overlaps(wedge, rectShape)
    check overlaps(wedge, poly)
    check overlaps(wedge, otherWedge)
