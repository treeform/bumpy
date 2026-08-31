import
  std/[math, unittest],
  bumpy, vmath

suite "wrapper symmetry":
  test "simple overlap wrappers stay symmetric":
    let
      point = vec2(3, 0)
      circleShape = circle(vec2(0, 0), 5)
      rectShape = rect(0, -1, 5, 2)
      segmentShape = segment(vec2(0, 0), vec2(5, 0))
      lineShape = line(vec2(0, 0), vec2(5, 0))
      polygonShape = @[
        vec2(0, -1),
        vec2(5, -1),
        vec2(5, 1),
        vec2(0, 1)
      ]
      wedgeShape = Wedge(
        pos: vec2(0, 0),
        rot: 0,
        minRadius: 0,
        maxRadius: 5,
        arc: Pi / 2
      )

    check overlaps(circleShape, point) == overlaps(point, circleShape)
    check overlaps(rectShape, point) == overlaps(point, rectShape)
    check overlaps(segmentShape, point) == overlaps(point, segmentShape)
    check overlaps(lineShape, point) == overlaps(point, lineShape)
    check overlaps(circleShape, rectShape) == overlaps(rectShape, circleShape)
    check overlaps(circleShape, segmentShape) == overlaps(segmentShape, circleShape)
    check overlaps(circleShape, lineShape) == overlaps(lineShape, circleShape)
    check overlaps(point, polygonShape) == overlaps(polygonShape, point)
    check overlaps(circleShape, polygonShape) == overlaps(polygonShape, circleShape)
    check overlaps(rectShape, polygonShape) == overlaps(polygonShape, rectShape)
    check overlaps(segmentShape, polygonShape) == overlaps(polygonShape, segmentShape)
    check overlaps(lineShape, polygonShape) == overlaps(polygonShape, lineShape)
    check overlaps(point, wedgeShape) == overlaps(wedgeShape, point)
    check overlaps(lineShape, wedgeShape) == overlaps(wedgeShape, lineShape)
    check overlaps(segmentShape, wedgeShape) == overlaps(wedgeShape, segmentShape)
    check overlaps(circleShape, wedgeShape) == overlaps(wedgeShape, circleShape)
    check overlaps(rectShape, wedgeShape) == overlaps(wedgeShape, rectShape)
    check overlaps(polygonShape, wedgeShape) == overlaps(wedgeShape, polygonShape)

  test "segment line intersection wrapper returns the same answer":
    let
      l = line(vec2(-10, 0), vec2(10, 0))
      s = segment(vec2(2, -3), vec2(2, 3))
    var
      atLine = vec2(0, 0)
      atSegment = vec2(0, 0)

    check intersects(l, s, atLine)
    check intersects(s, l, atSegment)
    check atLine == atSegment
