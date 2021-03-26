import bumpy, pixie/demo, vmath, chroma, random, common

var
  points: seq[Vec2]
  hull: seq[Vec2]
  dragging = -1

proc gen() =
  points.setLen(0)
  hull.setLen(0)
  for i in 0 ..< 14:
    let p = vec2(rand(200.0 .. 600.0), rand(100.0 .. 400.0))
    points.add(p)
  hull = convexHull(points)

start()
gen()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  if hull.len > 0:
    #screen.strokePoly(hull, parseHtmlColor("#3498db"))

    var i = 0
    for s in hull.segmentsClosed:
      let mid = (s.at + s.to)/2
      screen.strokeSegment(s, parseHtmlColor("#3498db"))
      let normal = s.convexHullNormal
      screen.strokeSegment(segment(mid, mid + normal*20), rgba(255, 0, 0, 255))
      inc i

  for p in points:
    screen.strokeCircle(p, 5, parseHtmlColor("#2ecc71"))

  if isKeyDown(KEY_SPACE):
    gen()

  if isMouseDown():
    if dragging == -1:
      for i, p in points:
        if p.dist(getMousePos()) < 6:
          dragging = i
    if dragging != -1:
      screen.fillCircle(points[dragging], 7, parseHtmlColor("#2ecc71"))
      points[dragging] = getMousePos()
      hull = convexHull(points)
  else:
    dragging = -1

  tick()
