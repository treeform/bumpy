import vmath

type
  Circle* = object
    pos*: Vec2
    radius*: float32

  Segment* = object
    a*: Vec2
    b*: Vec2

proc circle*(pos: Vec2, radius: float32): Circle =
  Circle(pos: pos, radius: radius)

proc segment*(a, b: Vec2): Segment =
  Segment(a: a, b: b)

proc overlap*(a, b: Vec2): bool =
  ## Do two points overlap? (Must be exactly equal.)
  a == b

proc overlap*(a: Vec2, b: Circle): bool =
  ## Test overlap: point vs circle.
  a.dist(b.pos) <= b.radius

proc overlap*(a: Circle, b: Vec2): bool =
  ## Test overlap: circle vs point.
  overlap(b, a)

proc overlap*(a, b: Circle): bool =
  ## Test overlap: circle vs circle.
  a.pos.dist(b.pos) <= b.radius + a.radius

proc overlap*(a: Vec2, b: Rect): bool =
  ## Test overlap: point vs rectangle.
  a.x >= b.x and # Right of the left edge AND
  a.x <= b.x + b.w and # left of the right edge AND
  a.y >= b.y and # below the top AND
  a.y <= b.y + b.h # above the bottom.

proc overlap*(a: Rect, b: Vec2): bool =
  ## Test overlap: rect vs point.
  overlap(b, a)

proc overlap*(a, b: Rect): bool =
  ## Do two rectangles overlap?
  a.x + a.w >= b.x and # A right edge past b left?
  a.x <= b.x + b.w and # A left edge past b right?
  a.y + a.h >= b.y and # A top edge past b bottom?
  a.y <= b.y + b.h # A bottom edge past b top?

proc overlap*(a: Circle, b: Rect): bool =
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

proc overlap*(a: Rect, b: Circle): bool =
  ## Test overlap: rect vs circle.
  overlap(b, a)

proc overlap*(a: Vec2, s: Segment, buffer = 0.1): bool =
  ## Test overlap: point vs segment.

  # Get distance from the point to the two ends of the line.
  let
    d1 = dist(a, s.a)
    d2 = dist(a, s.b)

  # Get the length of the line.
    lineLen = dist(s.a, s.b)

  # If the two distances are equal to the line's
  # length, the point is on the line!
  # Note we use the buffer here to give a range,
  # rather than one #
  d1 + d2 >= lineLen - buffer and
  d1 + d2 <= lineLen + buffer

proc overlap*(a: Segment, b: Vec2, buffer = 0.1): bool =
  ## Test overlap: segment vs point.
  overlap(b, a, buffer)

proc overlap*(c: Circle, s: Segment): bool =
  ## Test overlap: circle vs segment.

  # If either end inside the circle return.
  if overlap(s.a, c) or overlap(s.b, c):
    return true

  # Get length of the line.
  let len = s.a.dist(s.b)

  # Get dot product of the line and circle.
  let dot = (
    (c.pos.x - s.a.x) * (s.b.x - s.a.x) +
    (c.pos.y - s.a.y) * (s.b.y - s.a.y)
  ) / pow(len,2)

  # Find the closest point on the line.
  let closest = s.a + (dot * (s.b - s.a))

  # Is this point actually on the line segment?
  let onSegment = overlap(closest, s)
  if not onSegment:
    return false

  # Get distance to closest point.
  let distance = closest.dist(c.pos)

  distance <= c.radius

proc overlap*(s: Segment, c: Circle): bool =
  ## Test overlap: circle vs segment.
  overlap(c, s)

proc overlap*(d, s: Segment): bool =
  ## Test overlap: segment vs segment.

  # Calculate the distance to intersection point.
  let
    uA1 = (s.b.x - s.a.x) * (d.a.y - s.a.y) - (s.b.y - s.a.y) * (d.a.x - s.a.x)
    uB1 = (d.b.x - d.a.x) * (d.a.y - s.a.y) - (d.b.y - d.a.y) * (d.a.x - s.a.x)
    uA2 = (s.b.y - s.a.y) * (d.b.x - d.a.x) - (s.b.x - s.a.x) * (d.b.y - d.a.y)
    uB2 = (s.b.y - s.a.y) * (d.b.x - d.a.x) - (s.b.x - s.a.x) * (d.b.y - d.a.y)
    uA = uA1 / uA2
    uB = uB1 / uB2

  # If uA and uB are between 0-1, lines are colliding.
  uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1

proc overlap*(s: Segment, r: Rect): bool =
  ## Test overlap: segments vs rectangle.

  # Check if start or end of the segment is indie the rectangle.
  if overlap(s.a, r) or overlap(s.b, r):
    return true

  # Check if the line has hit any of the rectangle's sides.
  let
    left =   overlap(s, segment(vec2(r.x, r.y), vec2(r.x, r.y + r.h)))
    right =  overlap(s, segment(vec2(r.x + r.w, r.y), vec2(r.x + r.w, r.y + r.h)))
    top =    overlap(s, segment(vec2(r.x, r.y), vec2(r.x + r.w, r.y)))
    bottom = overlap(s, segment(vec2(r.x, r.y + r.h), vec2(r.x + r.w, r.y + r.h)))

  # If any of the above are true, the line has hit the rectangle.
  left or right or top or bottom

proc overlap*(r: Rect, s: Segment): bool =
  ## Test overlap: rectangle vs segment.
  overlap(s, r)

iterator pairwise[T](s: seq[T]): (T, T) =
  ## Return elements in pairs: (1st, 2nd), (2nd, 3rd) ... (last, 1st).
  for i in 0 ..< s.len:
    yield(s[i], s[(i + 1) mod s.len])

proc overlapTri(tri: seq[Vec2], p: Vec2): bool =
  ## Optimization for triangles:

  # get the area of the triangle
  let areaOrig = abs((tri[1].x-tri[0].x)*(tri[2].y-tri[0].y) - (tri[2].x-tri[0].x)*(tri[1].y-tri[0].y))

  # get the area of 3 triangles made between the point
  # and the corners of the triangle
  let
    area1 = abs((tri[0].x-p.x)*(tri[1].y-p.y) - (tri[1].x-p.x)*(tri[0].y-p.y))
    area2 = abs((tri[1].x-p.x)*(tri[2].y-p.y) - (tri[2].x-p.x)*(tri[1].y-p.y))
    area3 = abs((tri[2].x-p.x)*(tri[0].y-p.y) - (tri[0].x-p.x)*(tri[2].y-p.y))

  # If the sum of the three areas equals the original,
  # we're inside the triangle!
  area1 + area2 + area3 == areaOrig

proc overlap*(poly: seq[Vec2], p: Vec2): bool =
  ## Test overlap: polygon vs point.
  if poly.len == 3:
    return overlapTri(poly, p)

  var collision = false

  # Go through each of the vertices and the next vertex in the polygon.
  for vc, vn in poly.pairwise:
    # Compare position, flip 'collision' variable back and forth.
    if
      ((vc.y >= p.y and vn.y < p.y) or (vc.y < p.y and vn.y >= p.y)) and
      (p.x < (vn.x - vc.x) * (p.y - vc.y) / (vn.y - vc.y) + vc.x):
        collision = not collision

  collision

proc overlap*(p: Vec2, poly: seq[Vec2]): bool =
  ## Test overlap: point vs polygon.
  overlap(poly, p)

proc overlap*(poly: seq[Vec2], c: Circle): bool =
  ## Test overlap: polygon vs circle.

  # Go through each of the vertices and the next vertex in the polygon.
  for vc, vn in poly.pairwise:
    # check for collision between the circle and
    # a line formed between the two vertices
    if overlap(segment(vc, vn), c):
      return true

  # Test of circle is inside:
  overlap(poly, c.pos);

proc overlap*(c: Circle, poly: seq[Vec2]): bool =
  ## Test overlap: circle vs polygon.
  overlap(poly, c)

proc overlap*(poly: seq[Vec2], r: Rect): bool =
  ## Test overlap: polygon vs rect.
  for vc, vn in poly.pairwise:
    if overlap(segment(vc, vn), r):
      return true
  # Test if the rectangle is inside the polygon.
  return overlap(poly, vec2(r.x, r.y))

proc overlap*(r: Rect, poly: seq[Vec2]): bool =
  ## Test overlap: rect vs polygon.
  overlap(r, poly)

proc overlap*(poly: seq[Vec2], s: Segment): bool =
  ## Test overlap: polygon vs segment.
  for vc, vn in poly.pairwise:
    if overlap(segment(vc, vn), s):
      return true
  # Test if the rectangle is inside the polygon.
  return overlap(poly, s.a)

proc overlap*(s: Segment, poly: seq[Vec2]): bool =
  ## Test overlap: segment vs polygon.
  overlap(poly, s)

proc overlap*(a: seq[Vec2], b: seq[Vec2]): bool =
  ## Test overlap: polygon vs polygon.
  for a1, a2 in a.pairwise:
    for b1, b2 in b.pairwise:
      if overlap(segment(a1, a2), segment(b1, b2)):
        return true
  # Test if the a polygon is inside the b polygon.
  return overlap(a[0], b)
