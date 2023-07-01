import bumpy, common, random

var
  wedge: Wedge

  collider: int
  point: Vec2
  circle: Circle
  segment: Segment
  rect: Rect
  polygon: seq[Vec2]

circle.radius = 50

segment.at.x = 50
segment.at.y = 100
segment.to.x = 300
segment.to.y = 400

rect.w = 50
rect.h = 60

polygon.add(vec2(-20, 10))
polygon.add(vec2(40, -13))
polygon.add(vec2(35, 30))
polygon.add(vec2(25, 33))

wedge.pos = vec2(200, 100)
wedge.rot = 30.toRadians()
wedge.minRadius = 100
wedge.maxRadius = 400
wedge.arc = 90.toRadians()

echo "Press space bar to generate random wedge"
echo "Press left mouse button to cycle through colliders"

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  let poly = wedge.polygon(0.05)

  var doesOverlap = false
  case collider:
    of 0:
      point = window.mousePos.vec2
      doesOverlap = overlaps(wedge, point)
      screen.fillCircle(circle(point, 10), parseHtmlColor("#2ecc71"))
    of 1:
      circle.pos = window.mousePos.vec2
      doesOverlap = overlaps(wedge, circle)
      screen.fillCircle(circle, parseHtmlColor("#2ecc71"))
    of 2:
      segment.to = window.mousePos.vec2
      doesOverlap = overlaps(wedge, segment)
      screen.strokeSegment(segment, parseHtmlColor("#2ecc71"))
    of 3:
      rect.xy = window.mousePos.vec2 - rect.wh / 2
      doesOverlap = overlaps(wedge, rect)
      screen.fillRect(rect, parseHtmlColor("#2ecc71"))
    of 4:
      var polygonAdjusted: seq[Vec2]
      let mousePos = window.mousePos.vec2
      for p in polygon:
        polygonAdjusted.add(mousePos + p)
      doesOverlap = overlaps(wedge, polygonAdjusted)
      screen.fillPoly(polygonAdjusted, parseHtmlColor("#2ecc71"))
    else:
      collider = 0

  var color =
    if doesOverlap:
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(poly, color)

  if window.buttonPressed[KeySpace]:
    wedge.pos = vec2(rand(100f..400f), rand(100f..400f))
    wedge.rot = rand(-Pi .. Pi)
    wedge.minRadius = rand(-100f..100f)
    if wedge.minRadius < 0:
      wedge.minRadius = 0
    wedge.maxRadius = rand(100f..400f)
    wedge.arc = rand(0.0 .. Pi*2)

    circle.radius = rand(1f..100f)
    segment.at = vec2(rand(100f..400f), rand(100f..400f))
    rect.wh = vec2(rand(10f..200f), rand(10f..200f))

    polygon.setLen(0)
    polygon.add(vec2(rand(-100f..0f), rand(0f..100f)))
    polygon.add(vec2(rand(-100f..0f), rand(-100f..0f)))
    polygon.add(vec2(rand(0f..100f), rand(-100f..0f)))
    polygon.add(vec2(rand(0f..100f), rand(0f..100f)))

  if window.buttonPressed[MouseLeft]:
    inc collider

  tick()
