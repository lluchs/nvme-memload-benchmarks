(function() {
  "use strict"
  const margin = {top: 20, right: 30, bottom: 40, left: 40},
        width = 960 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom
  const dotRadius = 5

  const yAttr = (d) => d['real']

  var x = d3.scale.ordinal()
      .rangeRoundBands([0, width])
  var xOffset = d3.scale.ordinal()
  var y = d3.scale.linear()
      .range([height, 0])
  var loadcolor = d3.scale.category10()

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

  var chart = d3.select('#chart')
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
    .append('g')
      .attr('transform', `translate(${margin.left}, ${margin.right})`);

  chart.append('g')
      .attr('class', 'x axis')
      .attr('transform', `translate(0, ${height})`)
  chart.append('g')
      .attr('class', 'y axis')

  var legend = d3.select('#legend')
      .attr('width', 100)
  legend.append('g')
      .attr('transform', 'translate(10, 10)')

  // drawCSV('i30pc74/benchmark1-00.csv')

  function drawCSV(url) {
    d3.csv(url, type, function(err, data) {
      if (err) alert(err)
      else draw(data)
    })

    function type(d) {
      ['real', 'user', 'sys'].forEach((col) => {
        d[col] = +d[col]
      })
      return d
    }
  }

  var prevDomain = []
  function draw(data) {
    x.domain(data.map((d) => d.benchmark))
    prevDomain = [d3.min(data.map(yAttr).concat(prevDomain)), d3.max(data.map(yAttr).concat(prevDomain))]
    y.domain(prevDomain).nice();
    xOffset
      .domain(data.map((d) => d.loadconfig))
      .rangeRoundBands([0, x.rangeBand()], 1)
    loadcolor.domain(data.map((d) => d.loadconfig))
    drawLegend()

    chart.select('.x.axis').call(xAxis)
    chart.select('.y.axis').call(yAxis)

    var points = chart.selectAll('circle')
        .data(data)
    points.transition()
        .call(updatePoints)
    points.enter().append('circle')
        .attr('r', dotRadius)
        .call(updatePoints)
    points.exit().remove()

    // Bars show the average.
    var average = _.chain(data)
        .groupBy('benchmark')
        .values()
        .map((r) => _.chain(r).groupBy('loadconfig').values().value())
        .flatten(true)
        .map((r) => {
          // find numeric columns
          var cols = d3.set(_.keys(r[0]).filter((k) => _.isNumber(r[0][k])))
          // compute the average for those columns
          return _.mapObject(r[0], (v, k) => cols.has(k) ? d3.mean(r, (o) => o[k]) : v) 
        })
        .value()
    var bars = chart.selectAll('rect')
        .data(average)
    bars.enter().append('rect')
        .attr('width', dotRadius * 2)
        .attr('opacity', 0.5)
        .call(updateBars)
        .attr('height', 0)
        .attr('y', height)
    bars.transition()
        .call(updateBars)
    bars.exit().remove()

    function updatePoints(sel) {
      sel
        .attr('cx', (d, i) => x(d.benchmark))
        .attr('cy', (d, i) => y(yAttr(d)))
        .call(updateCommon)
    }

    function updateBars(sel) {
      sel
        .attr('height', (d) => height - y(yAttr(d)))
        .attr('x', (d) => x(d.benchmark) - dotRadius)
        .attr('y', (d) => y(yAttr(d)))
        .call(updateCommon)
    }

    function updateCommon(sel) {
      sel
        .attr('transform', (d) => `translate(${xOffset(d.loadconfig)}, 0)`)
        .attr('fill', (d) => loadcolor(d.loadconfig))
    }
  }

  function drawLegend() {
    legend
        .attr('height', 15 * loadcolor.domain().length + 5)
    var rows = legend.select('g').selectAll('g')
        .data(loadcolor.domain())
    var g = rows.enter().append('g')
    g.append('circle')
        .attr('r', dotRadius)
        .attr('cx', 2.5)
        .attr('cy', (d, i) => i * 15)
    g.append('text')
        .attr('x', 20)
        .attr('y', (d, i) => i * 15 + 2.5)
    rows.selectAll('circle')
        .attr('fill', (d) => loadcolor(d))
    rows.selectAll('text')
        .text((d) => d)
  }

  /* Benchmark selector */
  d3.tsv('benchmarks.tsv', function(err, data) {
    if (err) debugger

    var benchmarks = d3.select('#benchmarks')

    var benchmark = benchmarks.select('.benchmark')
        .on('change', () => updateRuns(d3.event.target.value))
    benchmark.selectAll('option')
        .data(d3.set(data.map((r) => r.benchmark)).values())
      .enter().append('option')
        .text((t) => t)

    updateRuns(data[0].benchmark)

    function updateRuns(benchmark) {
      var filtered = data.filter((r) => r.benchmark == benchmark)
      var run = benchmarks.select('.run')
          .on('change', () => updateRows(filtered, d3.event.target.value))
      var option = run.selectAll('option')
          .data(d3.set(filtered.map((r) => r.run)).values())
      option.enter().append('option')
      option
          .text((t) => t)
      option.exit().remove()

      updateRows(filtered, filtered[0].run)
    }

    function updateRows(data, run) {
      var filtered = data.filter((r) => r.run == run);
      var rows = benchmarks.select('table').selectAll('tr')
          .data(d3.set(filtered.map((r) => r.pc)).values())
      rows.enter().append('tr')
          .append('td')
      rows.select('td:first-child')
          .text((t) => t)
      rows.exit().remove()
      var td = rows.selectAll('td:not(:first-child)')
          .data((pc) => filtered.filter((r) => r.pc == pc))
      td.enter().append('td')
      var button = td.selectAll('button')
          .data((d) => [d])
      button.enter().append('button')
          .on('click', (t) => drawCSV(t.file))
      button
          .text((t) => t.n)
      td.exit().remove()
    }
  })

})();
