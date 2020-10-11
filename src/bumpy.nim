## Put your tests here.

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
  ## Does point overlap a circle?
  a.dist(b.pos) <= b.radius

proc overlap*(a: Circle, b: Vec2): bool =
  ## Does circle overlap a point?
  overlap(b, a)

proc overlap*(a, b: Circle): bool =
  ## Do two circles overlap?
  a.pos.dist(b.pos) <= b.radius + a.radius

proc overlap*(a: Vec2, b: Rect): bool =
  ## Does point overlap a rectangle?
  a.x >= b.x and # Right of the left edge AND
  a.x <= b.x + b.w and # left of the right edge AND
  a.y >= b.y and # below the top AND
  a.y <= b.y + b.h # above the bottom.

proc overlap*(a: Rect, b: Vec2): bool =
  ## Does a rect overlap a point?
  overlap(b, a)

proc overlap*(a, b: Rect): bool =
  ## Do two rectangles overlap?
  a.x + a.w >= b.x and # A right edge past b left?
  a.x <= b.x + b.w and # A left edge past b right?
  a.y + a.h >= b.y and # A top edge past b bottom?
  a.y <= b.y + b.h # A bottom edge past b top?

proc overlap*(a: Circle, b: Rect): bool =
  ## Does a circle overlap a rectangle?
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
  ## Does a rect overlap a circle?
  overlap(b, a)

proc overlap*(a: Vec2, s: Segment, buffer = 0.1): bool =
  ## Does a point overlap a segment?

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
  ## Does a segment overlap a point?
  overlap(b, a, buffer)

proc overlap*(c: Circle, s: Segment): bool =
  ## Does a circle overlap a segment?

  # If  either end inside the circle return.
  let inside1 = overlap(s.a, c)
  let inside2 = overlap(s.b, c)
  if inside1 or inside2:
    return true

  # get length of the line
  let len = s.a.dist(s.b)

  # get dot product of the line and circle
  let dot = (((c.pos.x-s.a.x)*(s.b.x-s.a.x)) + ((c.pos.y-s.a.y)*(s.b.y-s.a.y))) / pow(len,2)

  # find the closest point on the line
  let closestX = s.a.x + (dot * (s.b.x-s.a.x))
  let closestY = s.a.y + (dot * (s.b.y-s.a.y))

  # is this point actually on the line segment?
  # if so keep going, but if not, return false
  let onSegment = overlap(vec2(closestX, closestY), s)
  if not onSegment:
    return false

  # get distance to closest point
  let distX = closestX - c.pos.x
  let distY = closestY - c.pos.y
  let distance = sqrt((distX*distX) + (distY*distY))

  distance <= c.radius

proc overlap*(s: Segment, c: Circle): bool =
  ## Does a circle overlap a segment?
  overlap(c, s)

proc overlap*(d, s: Segment): bool =
  ## Do two segments overlap?

  # Calculate the distance to intersection point.
  let
    uA = ((s.b.x-s.a.x)*(d.a.y-s.a.y) - (s.b.y-s.a.y)*(d.a.x-s.a.x)) / ((s.b.y-s.a.y)*(d.b.x-d.a.x) - (s.b.x-s.a.x)*(d.b.y-d.a.y))
    uB = ((d.b.x-d.a.x)*(d.a.y-s.a.y) - (d.b.y-d.a.y)*(d.a.x-s.a.x)) / ((s.b.y-s.a.y)*(d.b.x-d.a.x) - (s.b.x-s.a.x)*(d.b.y-d.a.y))

  # If uA and uB are between 0-1, lines are colliding.
  uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1

proc overlap*(s: Segment, r: Rect): bool =
  ## Does a segments overlap a rectangle?

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
  ## Does a rectangle overlap a segment?
  overlap(s, r)
