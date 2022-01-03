import bumpy, pixie/demo, random

var
  hull1: seq[Vec2]
  hull2: seq[Vec2]

proc genHull(n = 14): seq[Vec2] =
  var points: seq[Vec2]
  for i in 0 ..< 14:
    let p = vec2(rand(0.0 .. 200.0), rand(0.0 .. 200.0))
    points.add(p)
  convexHull(points)

proc gen() =
  hull1 = genHull(24)

  for p in hull1.mitems:
    p += vec2(300, 200)

  hull2 = genHull(7)

proc drawHull(hull: seq[Vec2]) =
  ctx.beginPath()
  for i, v in hull:
    if i == 0:
      ctx.moveTo(v)
    else:
      ctx.lineTo(v)

  # for v in hull:
  #   ctx.lineTo(v)

  ctx.closePath()
  ctx.strokeStyle = "#3498db"
  ctx.stroke()

gen()
start()

while true:
  screen.fill(rgba(255, 255, 255, 255))
  hull1.drawHull()

  var hull2shifted = hull2
  for p in hull2shifted.mitems:
    p += window.mousePos.vec2 - vec2(100, 100)

  hull2shifted.drawHull()

  var
    numA = 0
    avgA: Vec2
    normA: Vec2
    numB = 0
    avgB: Vec2
    normB: Vec2
  for a in hull1.segmentsClosed:
    for b in hull2shifted.segmentsClosed:
      var at: Vec2
      if a.intersects(b, at):
        ctx.strokeStyle = rgba(255, 0, 0, 255)
        ctx.strokeCircle(circle(at, 3))
        let normalA = a.convexHullNormal
        ctx.strokeStyle = rgba(255, 0, 0, 255)
        ctx.strokeSegment(segment(at, at + normalA*40))

        let normalB = b.convexHullNormal
        ctx.strokeStyle = rgba(0, 255, 0, 255)
        ctx.strokeSegment(segment(at, at + normalB*40))

        avgA += at
        inc numA
        normA += normalA
        normB += normalB

  avgA /= numA.float32
  normA /= numA.float32
  normB /= numA.float32
  ctx.strokeStyle = rgba(255, 0, 0, 255)
  ctx.strokeCircle(circle(avgA, 5))
  ctx.strokeStyle = rgba(255, 0, 0, 255)
  ctx.strokeSegment(segment(avgA, avgA + normA*80))
  ctx.strokeStyle = rgba(0, 255, 0, 255)
  ctx.strokeSegment(segment(avgA, avgA + normB*80))

  if window.buttonDown[KeySpace]:
    gen()

  tick()
