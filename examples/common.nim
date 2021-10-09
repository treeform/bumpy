import pixie

proc fillPoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  let path = newPath()
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.fillPath(path, color)

proc strokePoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  let path = newPath()
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.strokePath(path, color)

proc fillRect*(image: Image, rect: Rect, color: SomeColor) =
  let p = newPath()
  p.rect(rect)
  image.fillPath(p, color)

proc fillCircle*(image: Image, circle: Circle, color: SomeColor) =
  let p = newPath()
  p.circle(circle)
  image.fillPath(p, color)

proc strokeCircle*(image: Image, circle: Circle, color: SomeColor) =
  let p = newPath()
  p.circle(circle)
  image.fillPath(p, color)

proc strokeSegment*(image: Image, segment: Segment, color: SomeColor) =
  let p = newPath()
  p.moveTo(segment.at)
  p.lineTo(segment.to)
  image.strokePath(p, color)
