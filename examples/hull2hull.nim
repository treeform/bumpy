import bumpy, pixie/demo, vmath, chroma, random, common

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

gen()
start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  for s in hull1.segmentsClosed:
    #let mid = (s.at + s.to)/2
    screen.strokeSegment(s, parseHtmlColor("#3498db"))
    #let normal = s.convexHullNormal
    #screen.strokeSegment(segment(mid, mid + normal*20), rgba(255, 0, 0, 255))

  var hull2shifted = hull2
  for p in hull2shifted.mitems:
    p += getMousePos() - vec2(100, 100)

  for s in hull2shifted.segmentsClosed:
    #let mid = (s.at + s.to)/2
    screen.strokeSegment(s, parseHtmlColor("#2ecc71"))
    #let normal = s.convexHullNormal
    #screen.strokeSegment(segment(mid, mid + normal*20), rgba(255, 0, 0, 255))

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
        screen.strokeCircle(at, 3, rgba(255, 0, 0, 255))
        let normalA = a.convexHullNormal
        screen.strokeSegment(segment(at, at + normalA*40), rgba(255, 0, 0, 255))


        let normalB = b.convexHullNormal
        screen.strokeSegment(segment(at, at + normalB*40), rgba(0, 255, 0, 255))

        avgA += at
        inc numA
        normA += normalA
        normB += normalB


        #let normalAvg = (normalA + normalB) / 2
        #screen.strokeSegment(segment(at, at + normalAvg*40), rgba(0, 0, 255, 255))
  avgA /= numA.float32
  normA /= numA.float32
  normB /= numA.float32
  screen.strokeCircle(avgA, 5, rgba(255, 0, 0, 255))
  screen.strokeSegment(segment(avgA, avgA + normA*80), rgba(255, 0, 0, 255))
  screen.strokeSegment(segment(avgA, avgA + normB*80), rgba(0, 255, 0, 255))



  # for a in hull1.segmentsClosed:
  #   for b in hull2shifted:
  #     let normalA = a.convexHullNormal
  #     let s1 = segment(b, b + normalA * 100)
  #     var at: Vec2
  #     if a.intersects(s1, at):
  #       screen.strokeCircle(at, 3, rgba(255, 0, 0, 255))

  if isKeyDown(KEY_SPACE):
    gen()

  tick()
