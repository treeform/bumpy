import strformat, vmath

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
  ## * all elements of a Rect.
  rect(r.x * v, r.y * v, r.w * v, r.h * v)

proc `/`*(r: Rect, v: float): Rect =
  ## / all elements of a Rect.
  rect(r.x / v, r.y / v, r.w / v, r.h / v)

proc `+`*(a, b: Rect): Rect =
  ## Add two boxes together.
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.w = a.w
  result.h = a.h

proc `$`*(a: Rect): string =
  &"({a.x}, {a.y}: {a.w} x {a.h})"

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

proc circle*(pos: Vec2, radius: float32): Circle {.inline.} =
  Circle(pos: pos, radius: radius)

proc segment*(at, to: Vec2): Segment {.inline.} =
  Segment(at: at, to: to)

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

  # If the distance is less than the radius, collision!
  distance <= a.radius

proc overlaps*(a: Rect, b: Circle): bool {.inline.} =
  ## Test overlap: rect vs circle.
  overlaps(b, a)

proc overlaps*(a: Vec2, s: Segment, buffer = 0.1): bool =
  ## Test overlap: point vs segment.

  # Get distance from the point to the two ends of the line.
  let
    d1 = dist(a, s.at)
    d2 = dist(a, s.to)

  # Get the length of the line.
    lineLen = dist(s.at, s.to)

  # If the two distances are equal to the line's
  # length, the point is on the line!
  # Note we use the buffer here to give a range,
  # rather than one #
  d1 + d2 >= lineLen - buffer and
  d1 + d2 <= lineLen + buffer

proc overlaps*(a: Segment, b: Vec2, buffer = 0.1): bool {.inline.} =
  ## Test overlap: segment vs point.
  overlaps(b, a, buffer)

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

  # Check if start or end of the segment is indie the rectangle.
  if overlaps(s.at, r) or overlaps(s.to, r):
    return true

  # Check if the line has hit any of the rectangle's sides.
  let
    left = overlaps(s, segment(vec2(r.x, r.y), vec2(r.x, r.y + r.h)))
    right = overlaps(s, segment(vec2(r.x + r.w, r.y), vec2(r.x + r.w, r.y + r.h)))
    top = overlaps(s, segment(vec2(r.x, r.y), vec2(r.x + r.w, r.y)))
    bottom = overlaps(s, segment(vec2(r.x, r.y + r.h), vec2(r.x + r.w, r.y + r.h)))

  # If any of the above are true, the line has hit the rectangle.
  left or right or top or bottom

proc overlaps*(r: Rect, s: Segment): bool {.inline.} =
  ## Test overlap: rectangle vs segment.
  overlaps(s, r)

iterator pairwise[T](s: seq[T]): (T, T) =
  ## Return elements in pairs: (1st, 2nd), (2nd, 3rd) ... (last, 1st).
  for i in 0 ..< s.len:
    yield(s[i], s[(i + 1) mod s.len])

proc overlapsTri*(tri: seq[Vec2], p: Vec2): bool =
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

proc overlaps*(poly: seq[Vec2], p: Vec2): bool =
  ## Test overlap: polygon vs point.
  if poly.len == 3:
    return overlapsTri(poly, p)

  var collision = false

  # Go through each of the vertices and the next vertex in the polygon.
  for vc, vn in poly.pairwise:
    # Compare position, flip 'collision' variable back and forth.
    if ((vc.y >= p.y and vn.y < p.y) or (vc.y < p.y and vn.y >= p.y)) and
      (p.x < (vn.x - vc.x) * (p.y - vc.y) / (vn.y - vc.y) + vc.x):
        collision = not collision

  collision

proc overlaps*(p: Vec2, poly: seq[Vec2]): bool {.inline.} =
  ## Test overlap: point vs polygon.
  overlaps(poly, p)

proc overlaps*(poly: seq[Vec2], c: Circle): bool =
  ## Test overlap: polygon vs circle.

  # Go through each of the vertices and the next vertex in the polygon.
  for vc, vn in poly.pairwise:
    # check for collision between the circle and
    # a line formed between the two vertices
    if overlaps(segment(vc, vn), c):
      return true

  # Test of circle is inside:
  overlaps(poly, c.pos)

proc overlaps*(c: Circle, poly: seq[Vec2]): bool {.inline.} =
  ## Test overlap: circle vs polygon.
  overlaps(poly, c)

proc overlaps*(poly: seq[Vec2], r: Rect): bool =
  ## Test overlap: polygon vs rect.
  for vc, vn in poly.pairwise:
    if overlaps(segment(vc, vn), r):
      return true
  # Test if the rectangle is inside the polygon.
  return overlaps(poly, vec2(r.x, r.y))

proc overlaps*(r: Rect, poly: seq[Vec2]): bool {.inline.} =
  ## Test overlap: rect vs polygon.
  overlaps(r, poly)

proc overlaps*(poly: seq[Vec2], s: Segment): bool =
  ## Test overlap: polygon vs segment.
  for vc, vn in poly.pairwise:
    if overlaps(segment(vc, vn), s):
      return true
  # Test if the rectangle is inside the polygon.
  return overlaps(poly, s.at)

proc overlaps*(s: Segment, poly: seq[Vec2]): bool {.inline.} =
  ## Test overlap: segment vs polygon.
  overlaps(poly, s)

proc overlaps*(a: seq[Vec2], b: seq[Vec2]): bool =
  ## Test overlap: polygon vs polygon.
  for a1, a2 in a.pairwise:
    for b1, b2 in b.pairwise:
      if overlaps(segment(a1, a2), segment(b1, b2)):
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
  ## Test overlap: line vs seg.
  let
    s1 = l.b - l.a
    s2 = s.to - s.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    numerator = s1.x * (l.a.y - s.at.y) - s1.y * (l.a.x - s.at.x)
    u = numerator / denominator
  u >= 0 and u <= 1

proc overlaps*(s: Segment, l: Line): bool {.inline.} =
  ## Test overlap: seg vs line.
  overlaps(l, s)

proc intersects*(a, b: Segment, at: var Vec2): bool {.inline.} =
  ## Checks if the a segment intersects b segment.
  ## If it returns true, at will have point of intersection
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
  ## If it returns true, at will have point of intersection
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
  ## Checks if the line intersects the segment.
  ## If it returns true, at will have point of intersection
  intersects(l, s, at)
