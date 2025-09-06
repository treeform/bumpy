import algorithm, vmath

type
  Circle* = object
    pos*: Vec2
    radius*: float32

  Segment* = object
    at*: Vec2
    to*: Vec2

  Rect* = object
    x*: float32
    y*: float32
    w*: float32
    h*: float32

  Line* = object
    a*: Vec2
    b*: Vec2

  Polygon* = seq[Vec2]

  Wedge* = object
    ## Used in Field of View, Area of Effect, Sector Targeting and
    ## Lighting/Shadows calculations.
    pos*: Vec2              ## Position.
    rot*: float32           ## Rotation.
    minRadius*: float32     ## Minimum radius, can't fire really close.
    maxRadius*: float32     ## Far radius, max range.
    arc*: float32           ## Radians, -arc/2 is left and +arc/2 is right.

proc rect*(x, y, w, h: float32): Rect {.inline.} =
  result.x = x
  result.y = y
  result.w = w
  result.h = h

proc rect*(pos, size: Vec2): Rect {.inline.} =
  result.x = pos.x
  result.y = pos.y
  result.w = size.x
  result.h = size.y

proc line*(a, b: Vec2): Line {.inline.} =
  result.a = a
  result.b = b

proc xy*(rect: Rect): Vec2 {.inline.} =
  ## Gets the xy as a Vec2.
  vec2(rect.x, rect.y)

proc `xy=`*(rect: var Rect, v: Vec2) {.inline.} =
  ## Sets the xy from Vec2.
  rect.x = v.x
  rect.y = v.y

proc wh*(rect: Rect): Vec2 {.inline.} =
  ## Gets the wh as a Vec2.
  vec2(rect.w, rect.h)

proc `wh=`*(rect: var Rect, v: Vec2) {.inline.} =
  ## Sets the wh from Vec2.
  rect.w = v.x
  rect.h = v.y

proc `*`*(r: Rect, v: float): Rect =
  ## Multiply all elements of a Rect.
  rect(r.x * v, r.y * v, r.w * v, r.h * v)

proc `/`*(r: Rect, v: float): Rect =
  ## Divide all elements of a Rect.
  rect(r.x / v, r.y / v, r.w / v, r.h / v)

proc `+`*(a, b: Rect): Rect =
  ## Add two rectangles together.
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.w = a.w
  result.h = a.h

proc `$`*(a: Rect): string =
  "(" & $a.x & ", " & $a.y & ": " & $a.w & " x " & $a.h & ")"

proc `or`*(a, b: Rect): Rect =
  ## Union of two rectangles.
  result.x = min(a.x, b.x)
  result.y = min(a.y, b.y)
  result.w = max(a.x + a.w, b.x + b.w) - result.x
  result.h = max(a.y + a.h, b.y + b.h) - result.y

proc `and`*(a, b: Rect): Rect =
  ## Intersection of two rectangles.
  result.x = max(a.x, b.x)
  result.y = max(a.y, b.y)
  result.w = min(a.x + a.w, b.x + b.w) - result.x
  result.h = min(a.y + a.h, b.y + b.h) - result.y

proc `+=`*(s: var Segment, v: Vec2) {.inline.} =
  s.at += v
  s.to += v

proc `*`*(m: Mat3, s: Segment): Segment {.inline.} =
  Segment(at: m * s.at, to: m * s.to)

proc circle*(pos: Vec2, radius: float32): Circle {.inline.} =
  Circle(pos: pos, radius: radius)

proc segment*(at, to: Vec2): Segment {.inline.} =
  Segment(at: at, to: to)

iterator segments(r: Rect): Segment =
  ## Returns all sides of the rect as segments.
  yield segment(vec2(r.x, r.y), vec2(r.x, r.y + r.h))
  yield segment(vec2(r.x + r.w, r.y), vec2(r.x + r.w, r.y + r.h))
  yield segment(vec2(r.x, r.y), vec2(r.x + r.w, r.y))
  yield segment(vec2(r.x, r.y + r.h), vec2(r.x + r.w, r.y + r.h))

iterator segments*(poly: Polygon): Segment =
  ## Return elements in pairs: (1st, 2nd), (2nd, 3rd) ... (last, 1st).
  for i in 0 ..< poly.len - 1:
    yield segment(poly[i], poly[i+1])
  if poly[^1] != poly[0]:
    yield segment(poly[^1], poly[0])

proc overlaps*(a, b: Vec2): bool {.inline.} =
  ## Test overlap: point vs point. (Must be exactly equal.)
  a == b

proc overlaps*(a: Vec2, b: Circle): bool {.inline.} =
  ## Test overlap: point vs circle.
  a.dist(b.pos) <= b.radius

proc overlaps*(a: Circle, b: Vec2): bool {.inline.} =
  ## Test overlap: circle vs point.
  overlaps(b, a)

proc overlaps*(a, b: Circle): bool =
  ## Test overlap: circle vs circle.
  a.pos.dist(b.pos) <= b.radius + a.radius

proc overlaps*(a: Vec2, b: Rect): bool =
  ## Test overlap: point vs rectangle.
  a.x >= b.x and # Right of the left edge AND
  a.x <= b.x + b.w and # left of the right edge AND
  a.y >= b.y and # below the top AND
  a.y <= b.y + b.h # above the bottom.

proc overlaps*(a: Rect, b: Vec2): bool {.inline.} =
  ## Test overlap: rect vs point.
  overlaps(b, a)

proc overlaps*(a, b: Rect): bool =
  ## Test overlap: rect vs rect.
  a.x + a.w >= b.x and # A right edge past b left?
  a.x <= b.x + b.w and # A left edge past b right?
  a.y + a.h >= b.y and # A top edge past b bottom?
  a.y <= b.y + b.h # A bottom edge past b top?

proc overlaps*(a: Circle, b: Rect): bool =
  ## Test overlap: circle vs rectangle.
  var
    testX = a.pos.x
    testY = a.pos.y

  # Which edge is closest?
  if a.pos.x < b.x:
    testX = b.x # Test left edge.
  elif a.pos.x > b.x + b.w:
    testX = b.x+b.w # Right edge.

  if a.pos.y < b.y:
    testY = b.y # Top edge.
  elif a.pos.y > b.y+b.h:
    testY = b.y+b.h # Bottom edge.

  # Get distance from closest edges.
  let
    distX = a.pos.x - testX
    distY = a.pos.y - testY
    distance = sqrt(distX*distX + distY*distY)

  # If the distance is less than the radius, there is a collision.
  distance <= a.radius

proc overlaps*(a: Rect, b: Circle): bool {.inline.} =
  ## Test overlap: rect vs circle.
  overlaps(b, a)

proc overlaps*(a: Vec2, s: Segment, fudge = 0.1): bool =
  ## Test overlap: point vs segment.

  # Get distance from the point to the two ends of the segment.
  let
    d1 = dist(a, s.at)
    d2 = dist(a, s.to)
    # Get the length of the segment.
    lineLen = dist(s.at, s.to)

  # If the two distances are equal to the segment's
  # length, the point is on the segment!
  # Note we use the fudge here to give a range,
  # rather than one exact value.
  d1 + d2 >= lineLen - fudge and
  d1 + d2 <= lineLen + fudge

proc overlaps*(a: Segment, b: Vec2, fudge = 0.1): bool {.inline.} =
  ## Test overlap: segment vs point.
  overlaps(b, a, fudge)

proc overlaps*(c: Circle, s: Segment): bool =
  ## Test overlap: circle vs segment.

  # If either end inside the circle return.
  if overlaps(s.at, c) or overlaps(s.to, c):
    return true

  # Get length of the line.
  let len = s.at.dist(s.to)
  if len == 0:
    return false

  # Get dot product of the line and circle.
  let dot = (
    (c.pos.x - s.at.x) * (s.to.x - s.at.x) +
    (c.pos.y - s.at.y) * (s.to.y - s.at.y)
  ) / pow(len, 2)

  # Find the closest point on the line.
  let closest = s.at + (dot * (s.to - s.at))

  # Is this point actually on the line segment?
  let onSegment = overlaps(closest, s)
  if not onSegment:
    return false

  # Get distance to closest point.
  let distance = closest.dist(c.pos)

  distance <= c.radius

proc overlaps*(s: Segment, c: Circle): bool {.inline.} =
  ## Test overlap: circle vs segment.
  overlaps(c, s)

proc overlaps*(c: Circle, l: Line): bool =
  ## Test overlap: circle vs line.

  # If either control point inside the circle return.
  if overlaps(l.a, c) or overlaps(l.b, c):
    return true

  # Get length of the line.
  let len = l.a.dist(l.b)
  if len == 0:
    return false

  # Get dot product of the line and circle.
  let dot = (
    (c.pos.x - l.a.x) * (l.b.x - l.a.x) +
    (c.pos.y - l.a.y) * (l.b.y - l.a.y)
  ) / pow(len, 2)

  # Find the closest point on the line.
  let closest = l.a + (dot * (l.b - l.a))

  # Get distance to closest point.
  let distance = closest.dist(c.pos)

  distance <= c.radius

proc overlaps*(l: Line, c: Circle): bool {.inline.} =
  ## Test overlap: circle vs line.
  overlaps(c, l)

proc overlaps*(d, s: Segment): bool =
  ## Test overlap: segment vs segment.

  # Calculate the distance to intersection point.
  let
    uA1 = (s.to.x - s.at.x) * (d.at.y - s.at.y) - (s.to.y - s.at.y) * (d.at.x - s.at.x)
    uB1 = (d.to.x - d.at.x) * (d.at.y - s.at.y) - (d.to.y - d.at.y) * (d.at.x - s.at.x)
    uA2 = (s.to.y - s.at.y) * (d.to.x - d.at.x) - (s.to.x - s.at.x) * (d.to.y - d.at.y)
    uB2 = (s.to.y - s.at.y) * (d.to.x - d.at.x) - (s.to.x - s.at.x) * (d.to.y - d.at.y)
    uA = uA1 / uA2
    uB = uB1 / uB2

  # If uA and uB are between 0-1, lines are colliding.
  uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1

proc overlaps*(s: Segment, r: Rect): bool =
  ## Test overlap: segments vs rectangle.

  # Check if start or end of the segment is inside the rectangle.
  if overlaps(s.at, r) or overlaps(s.to, r):
    return true

  for side in r.segments:
    if s.overlaps(side):
      return true

proc overlaps*(r: Rect, s: Segment): bool {.inline.} =
  ## Test overlap: rectangle vs segment.
  overlaps(s, r)

proc overlapsTri*(tri: Polygon, p: Vec2): bool =
  ## Optimization for triangles:

  # get the area of the triangle
  let areaOrig = abs(
    (tri[1].x - tri[0].x) * (tri[2].y - tri[0].y) -
    (tri[2].x - tri[0].x) * (tri[1].y-tri[0].y)
  )

  # get the area of 3 triangles made between the point
  # and the corners of the triangle
  let
    area1 = abs((tri[0].x - p.x) * (tri[1].y - p.y) - (tri[1].x - p.x) * (tri[0].y - p.y))
    area2 = abs((tri[1].x - p.x) * (tri[2].y - p.y) - (tri[2].x - p.x) * (tri[1].y - p.y))
    area3 = abs((tri[2].x - p.x) * (tri[0].y - p.y) - (tri[0].x - p.x) * (tri[2].y - p.y))

  # If the sum of the three areas equals the original,
  # we're inside the triangle!
  area1 + area2 + area3 == areaOrig

proc overlaps*(poly: Polygon, p: Vec2): bool =
  ## Test overlap: polygon vs point.
  if poly.len == 3:
    return overlapsTri(poly, p)

  var collision = false

  # Go through each of the sides of the polygon.
  for s in poly.segments:
    let
      vc = s.at
      vn = s.to
    # Compare position, flip 'collision' variable back and forth.
    if ((vc.y >= p.y and vn.y < p.y) or (vc.y < p.y and vn.y >= p.y)) and
      (p.x < (vn.x - vc.x) * (p.y - vc.y) / (vn.y - vc.y) + vc.x):
        collision = not collision

  collision

proc overlaps*(p: Vec2, poly: Polygon): bool {.inline.} =
  ## Test overlap: point vs polygon.
  overlaps(poly, p)

proc overlaps*(poly: Polygon, c: Circle): bool =
  ## Test overlap: polygon vs circle.

  # Go through each of the sides of the polygon.
  for s in poly.segments:
    # check for collision between the circle and
    # a line formed between the two vertices
    if overlaps(s, c):
      return true

  # Test if circle is inside:
  overlaps(poly, c.pos)

proc overlaps*(c: Circle, poly: Polygon): bool {.inline.} =
  ## Test overlap: circle vs polygon.
  overlaps(poly, c)

proc overlaps*(poly: Polygon, r: Rect): bool =
  ## Test overlap: polygon vs rect.
  for s in poly.segments:
    if overlaps(s, r):
      return true
  # Test if the rectangle is inside the polygon.
  return overlaps(poly, vec2(r.x, r.y))

proc overlaps*(r: Rect, poly: Polygon): bool {.inline.} =
  ## Test overlap: rect vs polygon.
  overlaps(poly, r)

proc overlaps*(poly: Polygon, s: Segment): bool =
  ## Test overlap: polygon vs segment.
  for seg in poly.segments:
    if overlaps(seg, s):
      return true
  # Test if the segment is inside the polygon.
  return overlaps(poly, s.at)

proc overlaps*(s: Segment, poly: Polygon): bool {.inline.} =
  ## Test overlap: segment vs polygon.
  overlaps(poly, s)

proc overlaps*(a: Polygon, b: Polygon): bool =
  ## Test overlap: polygon vs polygon.
  if a.len == 0 or b.len == 0:
    return
  for a in a.segments:
    for b in b.segments:
      if overlaps(a, b):
        return true
  # Test if the a polygon is inside the b polygon.
  return overlaps(a[0], b)

proc overlaps*(a, b: Line): bool {.inline.} =
  ## Test overlap: line vs line.
  let
    s1 = a.b - a.a
    s2 = b.b - b.a
    denominator = (-s2.x * s1.y + s1.x * s2.y)
  denominator != 0

proc overlaps*(l: Line, s: Segment): bool {.inline.} =
  ## Test overlap: line vs segment.
  let
    s1 = l.b - l.a
    s2 = s.to - s.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    numerator = s1.x * (l.a.y - s.at.y) - s1.y * (l.a.x - s.at.x)
    u = numerator / denominator
  u >= 0 and u <= 1

proc overlaps*(s: Segment, l: Line): bool {.inline.} =
  ## Test overlap: segment vs line.
  overlaps(l, s)

proc overlaps*(p: Vec2, l: Line, fudge = 0.1): bool {.inline.} =
  ## Test overlap: point vs line.
  let dir = l.a - l.b
  if dir.x == 0:
    # Line is vertical
    return p.x == l.b.x
  else:
    let
      m = dir.y / dir.x
      b = l.a.y - m * l.a.x
    return abs(p.y - (m * p.x + b)) < fudge

proc overlaps*(l: Line, p: Vec2, fudge = 0.1): bool {.inline.} =
  ## Test overlap: line vs point.
  overlaps(p, l, fudge)

proc overlaps*(r: Rect, l: Line): bool {.inline.} =
  ## Test overlap: rect vs line.
  for s in r.segments:
    if overlaps(s, l):
      return true

proc overlaps*(l: Line, r: Rect): bool {.inline.} =
  ## Test overlap: line vs rect.
  overlaps(r, l)

proc overlaps*(p: Polygon, l: Line): bool {.inline.} =
  ## Test overlap: polygon vs line.
  for s in p.segments:
    if overlaps(s, l):
      return true

proc overlaps*(l: Line, p: Polygon): bool {.inline.} =
  ## Test overlap: line vs polygon.
  overlaps(p, l)

proc intersects*(a, b: Segment, at: var Vec2): bool {.inline.} =
  ## Checks if segment a intersects segment b.
  ## If it returns true, at will have the point of intersection.
  let
    s1 = a.to - a.at
    s2 = b.to - b.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    s = (-s1.y * (a.at.x - b.at.x) + s1.x * (a.at.y - b.at.y)) / denominator
    t = (s2.x * (a.at.y - b.at.y) - s2.y * (a.at.x - b.at.x)) / denominator

  if s >= 0 and s <= 1 and t >= 0 and t <= 1:
    at = a.at + (t * s1)
    return true

proc intersects*(a, b: Line, at: var Vec2): bool {.inline.} =
  let
    s1 = a.b - a.a
    s2 = b.b - b.a
    denominator = (-s2.x * s1.y + s1.x * s2.y)

  if denominator == 0:
    return false

  let t = (s2.x * (a.a.y - b.a.y) - s2.y * (a.a.x - b.a.x)) / denominator
  at = a.a + (t * s1)
  true

proc intersects*(l: Line, s: Segment, at: var Vec2): bool {.inline.} =
  ## Checks if the line intersects the segment.
  ## If it returns true, at will have the point of intersection.
  let
    s1 = l.b - l.a
    s2 = s.to - s.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    numerator = s1.x * (l.a.y - s.at.y) - s1.y * (l.a.x - s.at.x)
    u = numerator / denominator

  if u >= 0 and u <= 1:
    at = s.at + (u * s2)
    return true

proc intersects*(s: Segment, l: Line, at: var Vec2): bool {.inline.} =
  ## Checks if the segment intersects the line.
  ## If it returns true, at will have the point of intersection.
  intersects(l, s, at)

proc length*(s: Segment): float32 {.inline.} =
  (s.at - s.to).length

proc makeHullPresorted(points: Polygon): Polygon =
  ## Monotone chain.

  # Deal with the upper half.
  var upperHull: Polygon
  for i in 0 ..< points.len:
    let p = points[i]
    while upperHull.len >= 2:
      let q = upperHull[upperHull.len - 1]
      let r = upperHull[upperHull.len - 2]
      if (q.x - r.x) * (p.y - r.y) >= (q.y - r.y) * (p.x - r.x):
        discard upperHull.pop()
      else:
        break
    upperHull.add(p)
  discard upperHull.pop()

  # Deal with the lower half.
  var lowerHull: Polygon
  for i in countDown(points.len - 1, 0):
    let p = points[i]
    while lowerHull.len >= 2:
      let q = lowerHull[lowerHull.len - 1]
      let r = lowerHull[lowerHull.len - 2]
      if (q.x - r.x) * (p.y - r.y) >= (q.y - r.y) * (p.x - r.x):
        discard lowerHull.pop()
      else:
        break
    lowerHull.add(p)
  discard lowerHull.pop()

  # See if lower or upper half needs merging.
  if upperHull.len == 1 and
    lowerHull.len == 1 and
    upperHull[0].x == lowerHull[0].x and
    upperHull[0].y == lowerHull[0].y:
    return upperHull
  else:
    return upperHull & lowerHull

proc convexCmp(a, b: Vec2): int =
  ## Convex hull sorter.
  if a.x < b.x:
    return -1
  elif a.x > b.x:
    return +1
  elif a.y < b.y:
    return -1
  elif a.y > b.y:
    return +1
  else:
    return 0

proc convexHull*(points: Polygon): Polygon =
  ## Monotone chain, a.k.a. Andrew's algorithm— O(n log n)
  ## Published in 1979 by A. M. Andrew.

  if points.len <= 3: # It's just a triangle.
    return points

  var sortedPoints = points
  sortedPoints.sort(convexCmp)
  makeHullPresorted(sortedPoints)

proc convexHullNormal*(s: Segment): Vec2 =
  ## Gets the normal of the segment returned from convexHull().
  let t = (s.to - s.at).normalize()
  -vec2(t.y, -t.x)

proc arcTolerance(radius: float32, arc: float32, error: float32): int =
  ## Calculates the number of points needed to represent an arc within a given
  ## error tolerance.
  if radius == 0.0:
    return 1
  else:
    let
      # The formula for the number of points is derived from the error formula
      # for approximating a circle with a regular polygon:
      # error = radius - sqrt(radius^2 - (radius * cos(pi / n))^2)
      n = ceil(Pi / arccos(1 - error / radius))
      # We adjust n for our arc length.
      numPoints = ceil(n * arc / (2 * Pi)).int
    return max(3, numPoints)

proc polygon*(wedge: Wedge, error: float32 = 0.5): Polygon =
  ## Approximates a wedge shape with a Polygon

  let halfArc = wedge.arc / 2

  # Generate min arc if minRadius is not zero.
  if wedge.minRadius > 0:
    let numPointsMin = arcTolerance(wedge.minRadius, wedge.arc, error)
    for i in 0 ..< numPointsMin:
      let
        a = float32(i) / float32(numPointsMin - 1)
        angle = wedge.rot - halfArc + wedge.arc * a
        point = wedge.pos + vec2(cos(angle), sin(angle)) * wedge.minRadius
      result.add point
  else:
    result.add wedge.pos

  # Generate max arc.
  let numPointsMax = arcTolerance(wedge.maxRadius, wedge.arc, error)
  for i in countdown(numPointsMax - 1, 0):
    let
      a = float32(i) / float32(numPointsMax - 1)
      angle = wedge.rot - halfArc + wedge.arc * a
      point = wedge.pos + vec2(cos(angle), sin(angle)) * wedge.maxRadius
    result.add point

  result.add result[0]

proc overlaps*(w: Wedge, p: Vec2): bool {.inline.} =
  ## Test overlap: wedge vs point.
  let distance = p.dist(w.pos)
  if distance <= w.maxRadius and distance >= w.minRadius:
    let angle = angle(p, w.pos)
    if abs(angleBetween(angle, w.rot)) < w.arc / 2:
      return true

proc overlaps*(p: Vec2, w: Wedge): bool {.inline.} =
  ## Test overlap: point vs wedge.
  overlaps(w, p)

proc overlaps*(w: Wedge, l: Line, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs line.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w.polygon(error), l)

proc overlaps*(l: Line, w: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: line vs wedge.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w, l, error)

proc overlaps*(w: Wedge, s: Segment, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs segment.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w.polygon(error), s)

proc overlaps*(s: Segment, w: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: segment vs wedge.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w, s, error)

proc overlaps*(w: Wedge, c: Circle, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs circle.
  ## When needed converts wedge to polygon using error tolerance parameter.
  let distance = w.pos.dist(c.pos)
  if distance - c.radius <= w.maxRadius and
    distance + c.radius >= w.minRadius:
    return overlaps(w.polygon(error), c)

proc overlaps*(c: Circle, w: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: circle vs wedge.
  ## When needed converts wedge to polygon using error tolerance parameter.
  overlaps(w, c, error)

proc overlaps*(w: Wedge, r: Rect, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs rect.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w.polygon(error), r)

proc overlaps*(r: Rect, w: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: rect vs wedge.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w, r, error)

proc overlaps*(w: Wedge, p: Polygon, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs polygon.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w.polygon(error), p)

proc overlaps*(p: Polygon, w: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: polygon vs wedge.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(w, p, error)

proc overlaps*(a: Wedge, b: Wedge, error = 0.5): bool {.inline.} =
  ## Test overlap: wedge vs wedge.
  ## Converts wedge to polygon first using error tolerance parameter.
  overlaps(a.polygon(error), b.polygon(error))
