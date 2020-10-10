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

proc overlap*(a, b: Circle): bool =
  ## Do two circles overlap?
  a.pos.dist(b.pos) <= b.radius + a.radius

proc overlap*(a: Vec2, b: Rect): bool =
  ## Does point overlap a rectangle?
  a.x >= b.x and # Right of the left edge AND
  a.x <= b.x + b.w and # left of the right edge AND
  a.y >= b.y and # below the top AND
  a.y <= b.y + b.h # above the bottom.

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

proc overlap*(c: Circle, s: Segment, buffer = 0.1): bool =
  ## Does a circle overlap a segment?

  # is either end INSIDE the circle?
  # if so, return true immediately
  let inside1 = overlap(s.a, c)
  let inside2 = overlap(s.b, c)
  if inside1 or inside2:
    return true

  # get length of the line
  let len = s.a.dist(s.b)

  # get dot product of the line and circle
  let dot = ( ((c.pos.x-s.a.x)*(s.b.x-s.a.x)) + ((c.pos.y-s.a.y)*(s.b.y-s.a.y)) ) / pow(len,2)

  # find the closest point on the line
  let closestX = s.a.x + (dot * (s.b.x-s.a.x))
  let closestY = s.a.y + (dot * (s.b.y-s.a.y))

  # is this point actually on the line segment?
  # if so keep going, but if not, return false
  let onSegment = overlap(vec2(closestX, closestY), s)
  if not onSegment:
    return false

  # optionally, draw a circle at the closest
  # point on the line
  # fill(255,0,0)
  # noStroke()
  # ellipse(closestX, closestY, 20, 20)

  # get distance to closest point
  let distX = closestX - c.pos.x
  let distY = closestY - c.pos.y
  let distance = sqrt( (distX*distX) + (distY*distY) )

  distance <= c.radius
