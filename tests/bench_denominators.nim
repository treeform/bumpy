import
  benchy,
  bumpy, vmath

const
  SampleCount = 128
  Iterations = 100_000

type
  LinePair = tuple[a, b: Line]
  SegmentPair = tuple[a, b: Segment]
  LineSegmentPair = tuple[line: Line, segment: Segment]

proc overlapsLineLineWithDenominator(a, b: Line): bool {.inline.} =
  overlaps(a, b)

proc overlapsLineLineWithoutDenominator(a, b: Line): bool {.inline.} =
  let
    s1 = a.b - a.a
    s2 = b.b - b.a
    denominator = (-s2.x * s1.y + s1.x * s2.y)
  denominator != 0

proc overlapsSegmentSegmentWithDenominator(
  a, b: Segment
): bool {.inline.} =
  overlaps(a, b)

proc overlapsSegmentSegmentWithoutDenominator(
  d, s: Segment
): bool {.inline.} =
  let
    uA1 =
      (s.to.x - s.at.x) * (d.at.y - s.at.y) -
      (s.to.y - s.at.y) * (d.at.x - s.at.x)
    uB1 =
      (d.to.x - d.at.x) * (d.at.y - s.at.y) -
      (d.to.y - d.at.y) * (d.at.x - s.at.x)
    uA2 =
      (s.to.y - s.at.y) * (d.to.x - d.at.x) -
      (s.to.x - s.at.x) * (d.to.y - d.at.y)
    uB2 =
      (s.to.y - s.at.y) * (d.to.x - d.at.x) -
      (s.to.x - s.at.x) * (d.to.y - d.at.y)
    uA = uA1 / uA2
    uB = uB1 / uB2
  uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1

proc overlapsLineSegmentWithDenominator(
  l: Line,
  s: Segment
): bool {.inline.} =
  overlaps(l, s)

proc overlapsLineSegmentWithoutDenominator(
  l: Line,
  s: Segment
): bool {.inline.} =
  let
    s1 = l.b - l.a
    s2 = s.to - s.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    numerator = s1.x * (l.a.y - s.at.y) - s1.y * (l.a.x - s.at.x)
    u = numerator / denominator
  u >= 0 and u <= 1

proc intersectsSegmentSegmentWithDenominator(
  a, b: Segment,
  at: var Vec2
): bool {.inline.} =
  intersects(a, b, at)

proc intersectsSegmentSegmentWithoutDenominator(
  a, b: Segment,
  at: var Vec2
): bool {.inline.} =
  let
    s1 = a.to - a.at
    s2 = b.to - b.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    s =
      (-s1.y * (a.at.x - b.at.x) + s1.x * (a.at.y - b.at.y)) /
      denominator
    t =
      (s2.x * (a.at.y - b.at.y) - s2.y * (a.at.x - b.at.x)) /
      denominator

  if s >= 0 and s <= 1 and t >= 0 and t <= 1:
    at = a.at + (t * s1)
    return true

proc intersectsLineSegmentWithDenominator(
  l: Line,
  s: Segment,
  at: var Vec2
): bool {.inline.} =
  intersects(l, s, at)

proc intersectsLineSegmentWithoutDenominator(
  l: Line,
  s: Segment,
  at: var Vec2
): bool {.inline.} =
  let
    s1 = l.b - l.a
    s2 = s.to - s.at
    denominator = (-s2.x * s1.y + s1.x * s2.y)
    numerator = s1.x * (l.a.y - s.at.y) - s1.y * (l.a.x - s.at.x)
    u = numerator / denominator

  if u >= 0 and u <= 1:
    at = s.at + (u * s2)
    return true

proc makeCrossingLinePairs(): seq[LinePair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 10)),
      line(vec2(offset, 10), vec2(offset + 10, 0))
    ))

proc makeParallelLinePairs(): seq[LinePair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 0)),
      line(vec2(offset, 1), vec2(offset + 10, 1))
    ))

proc makeCoincidentLinePairs(): seq[LinePair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 0)),
      line(vec2(offset + 2, 0), vec2(offset + 7, 0))
    ))

proc makeCrossingSegmentPairs(): seq[SegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      segment(vec2(offset, 0), vec2(offset + 10, 10)),
      segment(vec2(offset, 10), vec2(offset + 10, 0))
    ))

proc makeParallelSegmentPairs(): seq[SegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      segment(vec2(offset, 0), vec2(offset + 10, 0)),
      segment(vec2(offset, 1), vec2(offset + 10, 1))
    ))

proc makeCollinearSegmentPairs(): seq[SegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      segment(vec2(offset, 0), vec2(offset + 10, 0)),
      segment(vec2(offset + 5, 0), vec2(offset + 15, 0))
    ))

proc makeCrossingLineSegmentPairs(): seq[LineSegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 0)),
      segment(vec2(offset + 5, -5), vec2(offset + 5, 5))
    ))

proc makeParallelLineSegmentPairs(): seq[LineSegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 0)),
      segment(vec2(offset, 2), vec2(offset + 10, 2))
    ))

proc makeCollinearLineSegmentPairs(): seq[LineSegmentPair] =
  for i in 0 ..< SampleCount:
    let offset = float32(i)
    result.add((
      line(vec2(offset, 0), vec2(offset + 10, 0)),
      segment(vec2(offset + 2, 0), vec2(offset + 8, 0))
    ))

proc mixLinePairs(a, b: seq[LinePair]): seq[LinePair] =
  for i in 0 ..< SampleCount:
    result.add a[i]
    result.add b[i]

proc mixSegmentPairs(a, b: seq[SegmentPair]): seq[SegmentPair] =
  for i in 0 ..< SampleCount:
    result.add a[i]
    result.add b[i]

proc mixLineSegmentPairs(
  a, b: seq[LineSegmentPair]
): seq[LineSegmentPair] =
  for i in 0 ..< SampleCount:
    result.add a[i]
    result.add b[i]

let
  crossingLines = makeCrossingLinePairs()
  parallelLines = makeParallelLinePairs()
  coincidentLines = makeCoincidentLinePairs()
  mixedLines = mixLinePairs(crossingLines, parallelLines)
  crossingSegments = makeCrossingSegmentPairs()
  parallelSegments = makeParallelSegmentPairs()
  collinearSegments = makeCollinearSegmentPairs()
  mixedSegments = mixSegmentPairs(crossingSegments, parallelSegments)
  crossingLineSegments = makeCrossingLineSegmentPairs()
  parallelLineSegments = makeParallelLineSegmentPairs()
  collinearLineSegments = makeCollinearLineSegmentPairs()
  mixedLineSegments = mixLineSegmentPairs(
    crossingLineSegments,
    parallelLineSegments
  )

var
  benchHits = 0
  benchSum = 0.0'f

template benchLinePairs(name, pairs, op: untyped) =
  timeIt name:
    for i in 0 ..< Iterations:
      let pair = pairs[i mod pairs.len]
      if op(pair.a, pair.b):
        inc benchHits

template benchSegmentPairs(name, pairs, op: untyped) =
  timeIt name:
    for i in 0 ..< Iterations:
      let pair = pairs[i mod pairs.len]
      if op(pair.a, pair.b):
        inc benchHits

template benchLineSegmentPairs(name, pairs, op: untyped) =
  timeIt name:
    for i in 0 ..< Iterations:
      let pair = pairs[i mod pairs.len]
      if op(pair.line, pair.segment):
        inc benchHits

template benchSegmentIntersections(name, pairs, op: untyped) =
  timeIt name:
    var at: Vec2
    for i in 0 ..< Iterations:
      let pair = pairs[i mod pairs.len]
      if op(pair.a, pair.b, at):
        inc benchHits
        benchSum += at.x + at.y

template benchLineSegmentIntersections(name, pairs, op: untyped) =
  timeIt name:
    var at: Vec2
    for i in 0 ..< Iterations:
      let pair = pairs[i mod pairs.len]
      if op(pair.line, pair.segment, at):
        inc benchHits
        benchSum += at.x + at.y

benchLinePairs(
  "overlaps line line crossing (with denominator)",
  crossingLines,
  overlapsLineLineWithDenominator
)
benchLinePairs(
  "overlaps line line crossing (without denominator)",
  crossingLines,
  overlapsLineLineWithoutDenominator
)
benchLinePairs(
  "overlaps line line parallel (with denominator)",
  parallelLines,
  overlapsLineLineWithDenominator
)
benchLinePairs(
  "overlaps line line parallel (without denominator)",
  parallelLines,
  overlapsLineLineWithoutDenominator
)
benchLinePairs(
  "overlaps line line coincident (with denominator)",
  coincidentLines,
  overlapsLineLineWithDenominator
)
benchLinePairs(
  "overlaps line line coincident (without denominator)",
  coincidentLines,
  overlapsLineLineWithoutDenominator
)
benchLinePairs(
  "overlaps line line mixed (with denominator)",
  mixedLines,
  overlapsLineLineWithDenominator
)
benchLinePairs(
  "overlaps line line mixed (without denominator)",
  mixedLines,
  overlapsLineLineWithoutDenominator
)

benchSegmentPairs(
  "overlaps segment segment crossing (with denominator)",
  crossingSegments,
  overlapsSegmentSegmentWithDenominator
)
benchSegmentPairs(
  "overlaps segment segment crossing (without denominator)",
  crossingSegments,
  overlapsSegmentSegmentWithoutDenominator
)
benchSegmentPairs(
  "overlaps segment segment parallel (with denominator)",
  parallelSegments,
  overlapsSegmentSegmentWithDenominator
)
benchSegmentPairs(
  "overlaps segment segment parallel (without denominator)",
  parallelSegments,
  overlapsSegmentSegmentWithoutDenominator
)
benchSegmentPairs(
  "overlaps segment segment collinear (with denominator)",
  collinearSegments,
  overlapsSegmentSegmentWithDenominator
)
benchSegmentPairs(
  "overlaps segment segment collinear (without denominator)",
  collinearSegments,
  overlapsSegmentSegmentWithoutDenominator
)
benchSegmentPairs(
  "overlaps segment segment mixed (with denominator)",
  mixedSegments,
  overlapsSegmentSegmentWithDenominator
)
benchSegmentPairs(
  "overlaps segment segment mixed (without denominator)",
  mixedSegments,
  overlapsSegmentSegmentWithoutDenominator
)

benchLineSegmentPairs(
  "overlaps line segment crossing (with denominator)",
  crossingLineSegments,
  overlapsLineSegmentWithDenominator
)
benchLineSegmentPairs(
  "overlaps line segment crossing (without denominator)",
  crossingLineSegments,
  overlapsLineSegmentWithoutDenominator
)
benchLineSegmentPairs(
  "overlaps line segment parallel (with denominator)",
  parallelLineSegments,
  overlapsLineSegmentWithDenominator
)
benchLineSegmentPairs(
  "overlaps line segment parallel (without denominator)",
  parallelLineSegments,
  overlapsLineSegmentWithoutDenominator
)
benchLineSegmentPairs(
  "overlaps line segment collinear (with denominator)",
  collinearLineSegments,
  overlapsLineSegmentWithDenominator
)
benchLineSegmentPairs(
  "overlaps line segment collinear (without denominator)",
  collinearLineSegments,
  overlapsLineSegmentWithoutDenominator
)
benchLineSegmentPairs(
  "overlaps line segment mixed (with denominator)",
  mixedLineSegments,
  overlapsLineSegmentWithDenominator
)
benchLineSegmentPairs(
  "overlaps line segment mixed (without denominator)",
  mixedLineSegments,
  overlapsLineSegmentWithoutDenominator
)

benchSegmentIntersections(
  "intersects segment segment crossing (with denominator)",
  crossingSegments,
  intersectsSegmentSegmentWithDenominator
)
benchSegmentIntersections(
  "intersects segment segment crossing (without denominator)",
  crossingSegments,
  intersectsSegmentSegmentWithoutDenominator
)
benchSegmentIntersections(
  "intersects segment segment parallel (with denominator)",
  parallelSegments,
  intersectsSegmentSegmentWithDenominator
)
benchSegmentIntersections(
  "intersects segment segment parallel (without denominator)",
  parallelSegments,
  intersectsSegmentSegmentWithoutDenominator
)

benchLineSegmentIntersections(
  "intersects line segment crossing (with denominator)",
  crossingLineSegments,
  intersectsLineSegmentWithDenominator
)
benchLineSegmentIntersections(
  "intersects line segment crossing (without denominator)",
  crossingLineSegments,
  intersectsLineSegmentWithoutDenominator
)
benchLineSegmentIntersections(
  "intersects line segment parallel (with denominator)",
  parallelLineSegments,
  intersectsLineSegmentWithDenominator
)
benchLineSegmentIntersections(
  "intersects line segment parallel (without denominator)",
  parallelLineSegments,
  intersectsLineSegmentWithoutDenominator
)
